import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTeacherWidget extends StatefulWidget {
  const SelectTeacherWidget({Key key}) : super(key: key);

  @override
  State createState() => _SelectTeacherWidgetState();
}

class _SelectTeacherWidgetState extends State<SelectTeacherWidget> {
  List<Teacher> _teachers = List.empty(growable: true);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<TeacherProvider>(context, listen: false)
          .getAllTeachers()
          .then((value) {
        _teachers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TeacherProvider teacherProvider =
        Provider.of<TeacherProvider>(context);
    if (teacherProvider.isBusy) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 2,
          child: Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Предпочтительный руководитель",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _teachers.length,
                      itemBuilder: _buildListItemTeacher,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await Provider.of<TeacherProvider>(context, listen: false)
                                .getAllTeachers()
                                .then((value) {
                              _teachers = value;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Произошла ошибка"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        },
                        child: const Text("Обновить"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await Provider.of<StudentProvider>(context,
                                    listen: false)
                                .addPreferredTeacherForStudent(
                                    _teachers[_selectedIndex].id);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Произошла ошибка"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        },
                        child: const Text("Подтвердить"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildListItemTeacher(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: index == _selectedIndex ? Colors.blue : Colors.white60,
        child: Center(
            child: Text(_teachers[index].name,
                style: const TextStyle(fontSize: 20))),
      ),
    );
  }
}
