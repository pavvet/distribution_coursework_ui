import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/save_coursework_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/request/save_teacher_request.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'unauthorize_page.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key key}) : super(key: key);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final _scaffoldKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();

  int selectedIndex;
  List<Preference> _preference = List.empty(growable: true);
  List<Preference> _selectedPreference = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<TeacherProvider>(context, listen: false).init();
      final teacher =
          Provider.of<TeacherProvider>(context, listen: false).teacher;
      if (teacher != null && teacher.isAuth()) {
        initAuthState();
      }
    });
  }

  void initAuthState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PreferenceProvider>(context, listen: false)
          .getAllPreference()
          .then((List<Preference> value) {
        _preference = value;
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
    return Column(
      children: [
        _buildFieldForNameCoursework(),
        _buildPreferencesList(),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              final teacher = Provider.of<TeacherProvider>(context, listen: false).teacher;
              final request =
                  SaveCourseworkRequest(_nameTextController.text, teacher.id);
              Provider.of<CourseworkProvider>(context, listen: false)
                  .saveCoursework(request);
            }
          },
          child: const Text("Создать"),
        )
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Предпочтения"),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _preference.length,
                            itemBuilder: _buildListItemPreference,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await Provider.of<PreferenceProvider>(context,
                                    listen: false)
                                .getAllPreference()
                                .then((List<Preference> value) {
                              _preference = value
                                  .where((preference) =>
                                      !_selectedPreference.contains(preference))
                                  .toList();
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
                        const Text("Выбранные предпочтения"),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _selectedPreference.length,
                            itemBuilder: _buildListItemSelectedPreference,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await inputDialog(context);
                                },
                                child: const Text("Добавить"),
                              ),
                            ),
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await Provider.of<CourseworkProvider>(context,
                                          listen: false)
                                      .addPreferencesForCoursework(
                                          _selectedPreference);
                                },
                                child: const Text("Подтвердить"),
                              ),
                            ),
                          ],
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

  Future inputDialog(BuildContext context) async {
    String preferenceName = "";
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавление предпочтений'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Название предпочтения',
                      hintText: 'Программирование'),
                  onChanged: (value) {
                    preferenceName = value;
                  },
                ),
              )
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Добавить'),
              onPressed: () async {
                try {
                  if (preferenceName.isEmpty) {
                    throw Exception();
                  }
                  await Provider.of<PreferenceProvider>(context, listen: false)
                      .savePreference(preferenceName);
                  await Provider.of<PreferenceProvider>(context, listen: false)
                      .getAllPreference()
                      .then((List<Preference> value) {
                    _preference = value
                        .where((preference) =>
                            !_selectedPreference.contains(preference))
                        .toList();
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Произошла ошибка")));
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
            ),
            ElevatedButton(
              child: const Text('Отмена'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildListItemPreference(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPreference.add(_preference[index]);
          _preference.removeAt(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.white60,
        child:
            Text(_preference[index].name, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildListItemSelectedPreference(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _preference.add(_selectedPreference[index]);
          _selectedPreference.removeAt(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.white60,
        child: Text(_selectedPreference[index].name,
            style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
