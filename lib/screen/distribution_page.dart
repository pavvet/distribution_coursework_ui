import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/pair_student_coursework.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/distribution_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistributionPage extends StatefulWidget {
  const DistributionPage({Key? key}) : super(key: key);

  @override
  State<DistributionPage> createState() => _DistributionPageState();
}

class _DistributionPageState extends State<DistributionPage> {
  final _scaffoldKey = GlobalKey();
  List<Coursework> _coursework = List.empty(growable: true);
  List<Student> _students = List.empty(growable: true);

  List<Coursework?> _courseworkResult = List.empty(growable: true);
  List<Student?> _studentsResult = List.empty(growable: true);
  List<int?> _scoreResult = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        key: _scaffoldKey,
        title: const Center(child: Text("Распределение курсовых работ")),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              constraints: const BoxConstraints.expand(width: 80, height: 80),
              onPressed: () {
                Navigator.pushNamed(context, "/auth");
              },
              icon: const Icon(Icons.arrow_back));
        }));
  }

  Widget _buildBody() {
    return Row(
      children: [
        Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                child: _buildStudentsAndCourseworkList())),
        Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                child: _buildResultDistributionList())),
      ],
    );
  }

  Widget _buildStudentsAndCourseworkList() {
    final StudentProvider studentProvider =
        Provider.of<StudentProvider>(context);
    final CourseworkProvider courseworkProvider =
        Provider.of<CourseworkProvider>(context);
    if (studentProvider.isBusy || courseworkProvider.isBusy) {
      return const CircularProgressIndicator();
    } else {
      return Card(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            color: Colors.black,
                          ),
                          controller: ScrollController(),
                          itemCount: _students.length,
                          itemBuilder: _buildListItemStudent,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          Provider.of<StudentProvider>(context, listen: false)
                              .getAllStudents()
                              .then((List<Student> value) {
                            _students = value;
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
                  ],
                ),
              ),
              const VerticalDivider(
                  thickness: 1, color: Colors.black, indent: 0, endIndent: 0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Курсовые",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            color: Colors.black,
                          ),
                          controller: ScrollController(),
                          itemCount: _coursework.length,
                          itemBuilder: _buildListItemCoursework,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          Provider.of<CourseworkProvider>(context,
                                  listen: false)
                              .getAllCoursework()
                              .then((List<Coursework> value) {
                            _coursework = value;
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
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _buildResultDistributionList() {
    final DistributionProvider distributionProvider =
        Provider.of<DistributionProvider>(context);
    if (distributionProvider.isBusy) {
      return const CircularProgressIndicator();
    } else {
      return Card(
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
                      "Распределение",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            color: Colors.black,
                          ),
                          controller: ScrollController(),
                          itemCount: _studentsResult.length,
                          itemBuilder: _buildListItemDistributionResult,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await Provider.of<DistributionProvider>(context,
                                  listen: false)
                              .getResultDistribution()
                              .then((List<PairStudentCoursework> value) {
                            _studentsResult.clear();
                            _courseworkResult.clear();
                            _scoreResult.clear();
                            for (var element in value) {
                              _studentsResult.add(element.student);
                              _courseworkResult.add(element.coursework);
                              _scoreResult.add(element.score);
                            }
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Ошибка при распределении"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                      child: const Text("Распределить"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildListItemCoursework(BuildContext context, int index) {
    return ListTile(
      title:
          Text(_coursework[index].name!, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildListItemStudent(BuildContext context, int index) {
    return ListTile(
      title: Text(_students[index].name!, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildListItemDistributionResult(BuildContext context, int index) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              _studentsResult[index]!.name!,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Text(
              _courseworkResult[index]!.name!,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Text(
              _scoreResult[index]!.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
