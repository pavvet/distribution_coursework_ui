import 'package:distribution_coursework/model/request/saveStudentRequest.dart';
import 'package:distribution_coursework/model/request/saveTeacherRequest.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

enum Status { student, teacher }

class RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey();

  Status _status = Status.student;

  final _nameController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  RegisterPageState();

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
        width: MediaQuery.of(context).size.width/4,
        height: MediaQuery.of(context).size.height/2,
        child: Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                  controller: _nameController,
                ),
                TextFormField(
                  controller: _loginController,
                ),
                TextFormField(
                  controller: _passwordController,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_status.name == Status.student.name) {
                        final request = SaveStudentRequest(_nameController.text,
                            _loginController.text, _passwordController.text);
                        Provider.of<StudentProvider>(context, listen: false)
                            .saveStudent(request);
                      } else {
                        final request = SaveTeacherRequest(_nameController.text,
                            _loginController.text, _passwordController.text);
                        Provider.of<StudentProvider>(context, listen: false)
                            .saveTeacher(request);
                      }
                      //Navigator.pushNamed(context, "/student");
                    },
                    child: const Text("Зарегистрироваться"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
