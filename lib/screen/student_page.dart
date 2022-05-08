import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/request/save_teacher_request.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:distribution_coursework/screen/components/add_preference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/split_choice.dart';
import 'components/swap_choice.dart';
import 'unauthorize_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _scaffoldKey = GlobalKey();
  int _selectedIndex;
  List<Teacher> _teachers = List.empty(growable: true);
  List<Preference> _preference = List.empty(growable: true);
  final List<Preference> _selectedPreference = List.empty(growable: true);

  List<Coursework> _courseworkList = List.empty(growable: true);
  List<Coursework> _selectedCourseworkList = List.empty(growable: true);
  List<Coursework> _unselectedCourseworkList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<StudentProvider>(context, listen: false).init();
      final student =
          Provider.of<StudentProvider>(context, listen: false).student;
      if (student != null && student.isAuth()) {
        initAuthState();
      }
    });
  }

  void initAuthState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherProvider>(context, listen: false)
          .getAllTeachers()
          .then((value) {
        _teachers = value;
      });
      Provider.of<PreferenceProvider>(context, listen: false)
          .getAllPreference()
          .then((List<Preference> value) {
        _preference = value
            .where((preference) => !_selectedPreference.contains(preference))
            .toList();
      });
      Provider.of<CourseworkProvider>(context, listen: false)
          .getAllCoursework()
          .then((List<Coursework> value) {
        _courseworkList = value
            .where((coursework) =>
                !_selectedCourseworkList.contains(coursework) &&
                !_unselectedCourseworkList.contains(coursework))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentProvider>(context).student;
    if (student != null && student.isAuth()) {
      return Scaffold(
        appBar: AppBar(
          key: _scaffoldKey,
        ),
        body: _buildBody(),
      );
    } else {
      return const UnauthorizedPage();
    }
  }

  Widget _buildBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(flex: 1, child: _buildPreferredTeacherList()),
        Expanded(flex: 3, child: _buildCourseworkList()),
        Expanded(flex: 2, child: _buildPreferencesList()),
      ],
    );
  }

  Widget _buildCourseworkList() {
    final CourseworkProvider courseworkProvider =
        Provider.of<CourseworkProvider>(context);
    if (courseworkProvider.isBusy) {
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
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SwapChoiceWidget(
                            selectedItems: _selectedCourseworkList,
                            items: _courseworkList,
                            unselectedItems: _unselectedCourseworkList,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Provider.of<CourseworkProvider>(context,
                                        listen: false)
                                    .getAllCoursework()
                                    .then((List<Coursework> value) {
                                  _courseworkList = value
                                      .where((coursework) =>
                                          !_selectedCourseworkList
                                              .contains(coursework) &&
                                          !_unselectedCourseworkList
                                              .contains(coursework))
                                      .toList();
                                });
                              },
                              child: const Text("Обновить"),
                            ),
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final student = Provider.of<StudentProvider>(context, listen: false).student;
                                  await Provider.of<CourseworkProvider>(context,
                                          listen: false)
                                      .addCourseworkForStudent(_selectedCourseworkList.map((e) => e.id).toList(), _unselectedCourseworkList.map((e) => e.id).toList(), student.id);
                                },
                                child: const Text("Подтвердить"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildPreferencesList() {
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    if (preferenceProvider.isBusy) {
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
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SplitChoiceWidget(
                            selectedItems: _selectedPreference,
                            items: _preference,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Provider.of<PreferenceProvider>(context,
                                        listen: false)
                                    .getAllPreference()
                                    .then((List<Preference> value) {
                                  _preference = value
                                      .where((preference) =>
                                          !_selectedPreference
                                              .contains(preference))
                                      .toList();
                                });
                              },
                              child: const Text("Обновить"),
                            ),
                            Flexible(
                              child: AddPreferenceWidget(
                                onTap: () async {
                                  await Provider.of<PreferenceProvider>(context,
                                          listen: false)
                                      .getAllPreference()
                                      .then(
                                    (List<Preference> value) {
                                      _preference = value
                                          .where((preference) =>
                                              !_selectedPreference
                                                  .contains(preference))
                                          .toList();
                                    },
                                  );
                                },
                              ),
                            ),
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await Provider.of<StudentProvider>(context,
                                          listen: false)
                                      .addPreferencesForStudent(
                                          _selectedPreference);
                                },
                                child: const Text("Подтвердить"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildPreferredTeacherList() {
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
                      itemBuilder: _buildListItemTeacher,
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

  Widget _buildListItemTeacher(BuildContext context, int index) {
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
