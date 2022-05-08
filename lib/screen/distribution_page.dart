import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/pair_student_coursework.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/distribution_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistributionPage extends StatefulWidget {
  const DistributionPage({Key key}) : super(key: key);

  @override
  State<DistributionPage> createState() => _DistributionPageState();
}

class _DistributionPageState extends State<DistributionPage> {
  final _scaffoldKey = GlobalKey();
  int _selectedIndex;
  List<Coursework> _coursework = List.empty(growable: true);
  List<Student> _students = List.empty(growable: true);

  List<Coursework> _courseworkResult = List.empty(growable: true);
  List<Student> _studentsResult = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseworkProvider>(context, listen: false)
          .getAllCoursework()
          .then((value) {
        _coursework = value;
      });
      Provider.of<StudentProvider>(context, listen: false)
          .getAllStudents()
          .then((value) {
        _students = value;
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
    return Row(
      children: [
        _buildStudentsAndCourseworkList(),
        _buildResultDistributionList(),
      ],
    );
  }

  Widget _buildResultDistributionList() {
    final DistributionProvider distributionProvider =
        Provider.of<DistributionProvider>(context);
    if (distributionProvider.isBusy) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          child: Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Студенты",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _studentsResult.length,
                            itemBuilder: _buildListItemStudentResult,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Provider.of<DistributionProvider>(context,
                                    listen: false)
                                .getResultDistribution()
                                .then((List<PairStudentCoursework> value) {
                              _studentsResult.clear();
                              _courseworkResult.clear();
                              for (var element in value) {
                                _studentsResult.add(element.student);
                                _courseworkResult.add(element.coursework);
                              }
                            });
                          },
                          child: const Text("Распределить"),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                      thickness: 1,
                      color: Colors.black,
                      indent: 0,
                      endIndent: 0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Курсовые",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _courseworkResult.length,
                            itemBuilder: _buildListItemCourseworkResult,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Provider.of<CourseworkProvider>(context,
                                    listen: false)
                                .getAllCoursework()
                                .then((List<Coursework> value) {
                              _coursework = value;
                            });
                          },
                          child: const Text("Обновить"),
                        ),
                      ],
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

  Widget _buildStudentsAndCourseworkList() {
    final StudentProvider studentProvider =
        Provider.of<StudentProvider>(context);
    final CourseworkProvider courseworkProvider =
        Provider.of<CourseworkProvider>(context);
    if (studentProvider.isBusy || courseworkProvider.isBusy) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          child: Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Студенты",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _students.length,
                            itemBuilder: _buildListItemStudent,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Provider.of<StudentProvider>(context, listen: false)
                                .getAllStudents()
                                .then((List<Student> value) {
                              _students = value;
                            });
                          },
                          child: const Text("Обновить"),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                      thickness: 1,
                      color: Colors.black,
                      indent: 0,
                      endIndent: 0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Курсовые",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _coursework.length,
                            itemBuilder: _buildListItemCoursework,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Provider.of<CourseworkProvider>(context,
                                    listen: false)
                                .getAllCoursework()
                                .then((List<Coursework> value) {
                              _coursework = value;
                            });
                          },
                          child: const Text("Обновить"),
                        ),
                      ],
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

  Widget _buildListItemCoursework(BuildContext context, int index) {
    return ListTile(
      title: Text(_coursework[index].name, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildListItemStudent(BuildContext context, int index) {
    return ListTile(
      title: Text(_students[index].name, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildListItemCourseworkResult(BuildContext context, int index) {
    return ListTile(
      title: Text(_courseworkResult[index].name,
          style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildListItemStudentResult(BuildContext context, int index) {
    return ListTile(
      title: Text(_studentsResult[index].name,
          style: const TextStyle(fontSize: 20)),
    );
  }
}
