import 'package:distribution_coursework/exception/app_exception.dart';
import 'package:distribution_coursework/model/request/auth_student_request.dart';
import 'package:distribution_coursework/model/request/auth_teacher_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/request/save_teacher_request.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({Key key}) : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

enum Status { student, teacher }

class _AuthorizationPageState extends State<AuthorizationPage> {
  final _scaffoldKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  Status _status = Status.student;

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  _AuthorizationPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
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
                            onChanged: (Status value) {
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
                            onChanged: (Status value) {
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
                      return _validEmpty(value);
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    validator: (value) {
                      return _validEmpty(value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (_formKey.currentState.validate()) {
                                  if (_status.name == Status.student.name) {
                                    final request = AuthStudentRequest(
                                        _loginController.text,
                                        _passwordController.text);
                                    await Provider.of<StudentProvider>(context,
                                        listen: false)
                                        .authStudent(request);
                                    Navigator.pushNamed(context, "/student");
                                  } else {
                                    final request = AuthTeacherRequest(
                                        _loginController.text,
                                        _passwordController.text);
                                    await Provider.of<TeacherProvider>(context,
                                        listen: false)
                                        .authTeacher(request);
                                    Navigator.pushNamed(context, "/teacher");
                                  }
                                }
                              } on AuthStudentException catch (exception) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(exception.message())));
                                if (kDebugMode) {
                                  print(exception);
                                }
                              } on AuthTeacherException catch (exception) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(exception.message())));
                                if (kDebugMode) {
                                  print(exception);
                                }
                              } catch (exception) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Произошла ошибка")));
                                if (kDebugMode) {
                                  print(exception);
                                }
                              }
                            },
                            child: const Text("Войти"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/register");
                              },
                              child: const Text("Зарегистрироваться"),),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/distribution");
                      },
                      child: const Text("Распределение"),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _validEmpty(String value) {
    if (value.isEmpty) {
      return "Поле не должно быть пустым";
    }
    return null;
  }
}
