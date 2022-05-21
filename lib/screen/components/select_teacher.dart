import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTeacherWidget extends StatefulWidget {
  const SelectTeacherWidget({Key? key}) : super(key: key);

  @override
  State createState() => _SelectTeacherWidgetState();
}

class _SelectTeacherWidgetState extends State<SelectTeacherWidget> {
  List<Teacher> _teachers = List.empty(growable: true);
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<TeacherProvider>(context, listen: false)
          .getAllTeachers()
          .then((value) {
        _teachers = value;
      });
      Teacher? teacher = context.read<StudentProvider>().student.teacher;
      _selectedIndex = _teachers.indexWhere((e) => e.id == teacher?.id);
      /*final teacher =
          Provider.of<StudentProvider>(context, listen: false).student.teacher;
      if (teacher != null) {
        _selectedIndex =
            _teachers.indexWhere((element) => element.id == teacher.id);
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<TeacherProvider>().isBusy) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {

      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height * 8 / 10,
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
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black,
                      ),
                      itemCount: _teachers.length,
                      itemBuilder: _buildListItemTeacher,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Expanded(child: _buttonRefreshTeacher()),
                      Expanded(child: _buttonConfirmTeacher())
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

  Widget _buttonConfirmTeacher() {
    return ElevatedButton(
      onPressed: _selectedIndex == null
          ? null
          : () async {
              try {
                await Provider.of<StudentProvider>(context, listen: false)
                    .addPreferredTeacherForStudent(
                        _teachers[_selectedIndex!].id);
                await Provider.of<StudentProvider>(context, listen: false)
                    .getStudent();
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
    );
  }

  Widget _buttonRefreshTeacher() {
    return ElevatedButton(
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
    );
  }

  Widget _buildListItemTeacher(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        textColor: index == _selectedIndex ? Colors.white : Colors.black,
        tileColor: index == _selectedIndex ? Color(-14137996) : Colors.white60,
        title: Center(
          child: Text(_teachers[index].name!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
