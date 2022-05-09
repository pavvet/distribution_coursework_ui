import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/save_coursework_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/request/save_teacher_request.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:distribution_coursework/screen/components/add_preference.dart';
import 'package:distribution_coursework/screen/components/split_choice.dart';
import 'package:distribution_coursework/screen/components/split_choice_teacher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'unauthorize_page.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final _scaffoldKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();

  int? _selectedIndex;
  Teacher? _teacher;
  Coursework _coursework = Coursework.empty();
  List<Preference> _preference = List.empty(growable: true);
  List<Preference>? _selectedPreference = List.empty(growable: true);
  List<Coursework> _courseworks = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<TeacherProvider>(context, listen: false).init();
      _teacher = Provider.of<TeacherProvider>(context, listen: false).teacher;
      if (_teacher != null && _teacher!.isAuth()) {
        initAuthState();
      }
    });
  }

  void initAuthState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<PreferenceProvider>(context, listen: false)
          .getAllPreference()
          .then((List<Preference> value) {
        _preference = value;
      });
      Provider.of<CourseworkProvider>(context, listen: false)
          .getCourseworksForTeacher(_teacher!.id)
          .then((List<Coursework> value) {
        _courseworks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final teacher = Provider.of<TeacherProvider>(context).teacher;
    if (teacher != null && teacher.isAuth()) {
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
      children: [
        _buildTeacherCourseworks(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFieldForNameCoursework(),
            _buildPreferencesList(),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_formKey.currentState!.validate()) {
                    final teacher =
                        Provider.of<TeacherProvider>(context, listen: false)
                            .teacher!;
                    final request = SaveCourseworkRequest(
                        _nameTextController.text, teacher.id);
                    _courseworks.add(await Provider.of<CourseworkProvider>(
                            context,
                            listen: false)
                        .saveCoursework(request));
                  }
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
              child: const Text("Создать"),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildFieldForNameCoursework() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameTextController,
                decoration: const InputDecoration(
                    labelText: "Название курсовой работы",
                    border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите название курсовой";
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesList() {
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    final Coursework coursework =
        Provider.of<CourseworkProvider>(context, listen: false).coursework;
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
                    child: SplitChoiceTeacherWidget(
                      selectedItems: _selectedPreference,
                      items: _preference,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await Provider.of<PreferenceProvider>(context,
                                    listen: false)
                                .getAllPreference()
                                .then(
                              (List<Preference> value) {
                                _preference = value
                                    .where((preference) => !_selectedPreference!
                                        .contains(preference))
                                    .toList();
                              },
                            );
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
                      Flexible(
                        child: AddPreferenceWidget(
                          onTap: () async {
                            await Provider.of<PreferenceProvider>(context,
                                    listen: false)
                                .getAllPreference()
                                .then(
                              (List<Preference> value) {
                                _preference = value
                                    .where((preference) => !_selectedPreference!
                                        .contains(preference))
                                    .toList();
                              },
                            );
                          },
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: coursework.id == null
                              ? null
                              : () async {
                                  try {
                                    await Provider.of<CourseworkProvider>(
                                            context,
                                            listen: false)
                                        .addPreferencesForCoursework(
                                            _selectedPreference!);
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildTeacherCourseworks() {
    final CourseworkProvider courseworkProvider =
        Provider.of<CourseworkProvider>(context);
    if (courseworkProvider.isBusy) {
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
                  const Text("Курсовые преподавателя",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _courseworks.length,
                      itemBuilder: _buildListItemCourseworks,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await Provider.of<CourseworkProvider>(context,
                                    listen: false)
                                .getCourseworksForTeacher(_teacher!.id)
                                .then((List<Coursework> value) {
                              _courseworks = value;
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
                            if (_selectedIndex != null) {
                              _coursework =
                                  await Provider.of<CourseworkProvider>(context,
                                          listen: false)
                                      .getCoursework(
                                          _courseworks[_selectedIndex!].id);
                              _selectedPreference = _coursework.preferences;
                              _nameTextController.text = _coursework.name!;
                              _preference = List.of(
                                  Provider.of<PreferenceProvider>(context,
                                          listen: false)
                                      .allPreference);
                              _preference.removeWhere((preference) =>
                                  _selectedPreference!.contains(preference));
                            }
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

  Widget _buildListItemCourseworks(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      tileColor: index == _selectedIndex ? Colors.blue : Colors.white,
      title: Center(
        child: Text(_courseworks[index].name!,
            style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
