import 'package:distribution_coursework/model/request/saveStudentRequest.dart';
import 'package:distribution_coursework/model/request/saveTeacherRequest.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _scaffoldKey = GlobalKey();
  int _selectedIndex;
  List<Teacher> _teachers = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherProvider>(context, listen: false)
          .getAllTeachers()
          .then((value) {
        _teachers = value;
      });
    });
  }

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
                  const Text("Предпочтительный руководитель"),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _teachers.length,
                      itemBuilder: _buildListItem,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Provider.of<StudentProvider>(context, listen: false)
                          .addPreferredTeacherForStudent(
                              _teachers[_selectedIndex].id);
                    },
                    child: const Text("Подтвердить"),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildListItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // устанавливаем индекс выделенного элемента
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: index == _selectedIndex ? Colors.blue : Colors.white60,
        child:
            Text(_teachers[index].name, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
