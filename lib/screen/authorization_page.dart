import 'package:distribution_coursework/exception/app_exception.dart';
import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/request/auth_student_request.dart';
import 'package:distribution_coursework/model/request/auth_teacher_request.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:distribution_coursework/util/scaffold_messenger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

enum Status { student, teacher }

class _AuthorizationPageState extends State<AuthorizationPage> {
  final _formKey = GlobalKey<FormState>();

  Status? _status = Status.student;

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  _AuthorizationPageState();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2,
        child: Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Студент'),
                          leading: Radio<Status>(
                            value: Status.student,
                            groupValue: _status,
                            onChanged: (Status? value) {
                              setState(() {
                                _status = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Преподаватель'),
                          leading: Radio<Status>(
                            value: Status.teacher,
                            groupValue: _status,
                            onChanged: (Status? value) {
                              setState(() {
                                _status = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _loginController,
                    decoration: const InputDecoration(labelText: 'Логин'),
                    validator: (value) {
                      return _validEmpty(value!);
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    validator: (value) {
                      return _validEmpty(value!);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buttonEntry(),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _buttonRegister(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(child: _buttonDistribution()),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonDistribution() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, "/distribution");
      },
      child: const Text("Распределение"),
    );
  }

  Widget _buttonRegister() {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, "/register");
        },
        child: const Text("Зарегистрироваться"));
  }

  Widget _buttonEntry() {
    return ElevatedButton(
      onPressed: () async {
        try {
          if (_formKey.currentState!.validate()) {
            if (_status!.name == Status.student.name) {
              final request = AuthStudentRequest(
                  _loginController.text, _passwordController.text);
              await Provider.of<StudentProvider>(context, listen: false)
                  .authStudent(request);
              Provider.of<CourseworkProvider>(context, listen: false)
                  .coursework = Coursework.empty();
              Navigator.pushNamed(context, "/student");
            } else {
              final request = AuthTeacherRequest(
                  _loginController.text, _passwordController.text);
              await Provider.of<TeacherProvider>(context, listen: false)
                  .authTeacher(request);
              Provider.of<CourseworkProvider>(context, listen: false)
                  .coursework = Coursework.empty();
              Navigator.pushNamed(context, "/teacher");
            }
          }
        } on AuthStudentException catch (exception) {
          CustomScaffoldMessenger.build(
            text: exception.message(),
            isGreen: false,
            context: context,
          );
          if (kDebugMode) {
            print(exception);
          }
        } on AuthTeacherException catch (exception) {
          CustomScaffoldMessenger.build(
            text: exception.message(),
            isGreen: false,
            context: context,
          );
          if (kDebugMode) {
            print(exception);
          }
        } catch (exception) {
          CustomScaffoldMessenger.build(
            text: "Произошла ошибка",
            isGreen: false,
            context: context,
          );
          if (kDebugMode) {
            print(exception);
          }
        }
      },
      child: const Text("Войти"),
    );
  }

  String? _validEmpty(String value) {
    if (value.isEmpty) {
      return "Поле не должно быть пустым";
    }
    return null;
  }
}
