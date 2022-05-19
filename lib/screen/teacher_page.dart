import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/save_coursework_request.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:distribution_coursework/screen/components/add_preference.dart';
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
  final _descriptionTextController = TextEditingController();

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
        appBar: _buildAppBar(),
        body: _buildBody(),
      );
    } else {
      return const UnauthorizedPage();
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      key: _scaffoldKey,
      title: const Center(child: Text("Личная страница преподавателя")),
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            constraints: const BoxConstraints.expand(width: 80, height: 80),
            onPressed: () {
              Provider.of<TeacherProvider>(context, listen: false).exit();
              Navigator.pushNamed(context, "/auth");
            },
            icon: const Icon(Icons.arrow_back));
      }),
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertDialog();
                },
              );
            },
            icon: const Icon(Icons.help_outline_outlined))
      ],
    );
  }

  AlertDialog alertDialog() {
    return AlertDialog(
      title: const Text("Описание"),
      content: const Text(
          'В столбце "Курсовые преподавателя" находится список курсовых, которые созданны данным преподавателем.'
          '\nКнопка "Обновить" - обновляет данный список.'
          '\nКнопка "Новая" - начинает создание новой курсовой работы.'
          '\nКнопка "Подтвердить" - делает выделенную в списке курсовую работу в качестве текущей, то есть все изменения, будут применяться к ней.'
          '\n\nВ поле "Название курсовой работы" нужно ввести название для создаваемого проекта.'
          '\nЕсли поле оставить пустым, курсовую создать не получится.'
          '\n\nВ поле "Описание курсовой работы" нужно ввести описание создаваемого проекта.'
          '\n\nСписок, состоящий из двух столбцов, отвечает за выбранные предпочтения, которые должны быть у студента для данной курсовой.'
          '\nДанные слова должны описывать тему курсовой работы.'
          '\nНажатие на элементы списка перемещает их из одного столбца в другой.'
          '\nКнопка "Обновить" - обновляет список.'
          '\nКнопка "Добавить" - добавляет новое слово в данный список.'
          '\nКнопка "Создать" - создаёт курсовую работу с указанными данными.'
          '\nКнопка "Подтвердить" - подтверждает сделанные изменения в курсовой работе.'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Закрыть"))
      ],
    );
  }

  Widget _buildBody() {
    return Center(
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 3 / 10,
            height: MediaQuery.of(context).size.height * 8 / 10,
            child: _buildTeacherCourseworks(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 3 / 10,
            height: MediaQuery.of(context).size.height * 8 / 10,
            child: Column(
              children: [
                _buildFieldForNameCoursework(),
                Expanded(child: _buildFieldForDescriptionCoursework()),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 4 / 10,
            height: MediaQuery.of(context).size.height * 8 / 10,
            child: _buildPreferencesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldForNameCoursework() {
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameTextController,
            style: const TextStyle(fontSize: 24),
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
    );
  }

  Widget _buildFieldForDescriptionCoursework() {
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _descriptionTextController,
          style: const TextStyle(fontSize: 18, overflow: TextOverflow.clip),
          decoration: const InputDecoration(
              labelText: "Описание курсовой работы", border: InputBorder.none),
        ),
      ),
    );
  }

  Widget _buildPreferencesList() {
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    if (preferenceProvider.isBusy) {
      return const CircularProgressIndicator();
    } else {
      return Card(
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                  Flexible(child: _buttonRefreshPreference()),
                  Flexible(child: _buttonAddPreference()),
                  Flexible(child: _buttonCreateCoursework()),
                  Flexible(child: _buttonConfirmPreference()),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buttonRefreshPreference() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await Provider.of<PreferenceProvider>(context, listen: false)
              .getAllPreference()
              .then(
            (List<Preference> value) {
              _preference = value
                  .where((preference) =>
                      !_selectedPreference!.contains(preference))
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
    );
  }

  Widget _buttonAddPreference() {
    return AddPreferenceWidget(
      onTap: () async {
        await Provider.of<PreferenceProvider>(context, listen: false)
            .getAllPreference()
            .then(
          (List<Preference> value) {
            _preference = value
                .where(
                    (preference) => !_selectedPreference!.contains(preference))
                .toList();
          },
        );
      },
    );
  }

  Widget _buttonCreateCoursework() {
    final coursework =
        Provider.of<CourseworkProvider>(context, listen: false).coursework;
    return ElevatedButton(
      onPressed: coursework.id != null
          ? null
          : () async {
              try {
                if (_formKey.currentState!.validate()) {
                  final teacher =
                      Provider.of<TeacherProvider>(context, listen: false)
                          .teacher!;
                  final request = SaveCourseworkRequest(
                      _nameTextController.text,
                      teacher.id,
                      _descriptionTextController.text,
                      preferences: _selectedPreference);
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
    );
  }

  Widget _buttonConfirmPreference() {
    final coursework =
        Provider.of<CourseworkProvider>(context, listen: false).coursework;
    return ElevatedButton(
      onPressed: coursework.id == null
          ? null
          : () async {
              try {
                await Provider.of<CourseworkProvider>(context, listen: false)
                    .updateCoursework(_nameTextController.text,
                        _descriptionTextController.text, _selectedPreference!);
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

  Widget _buildTeacherCourseworks() {
    final CourseworkProvider courseworkProvider =
        Provider.of<CourseworkProvider>(context);
    if (courseworkProvider.isBusy) {
      return const CircularProgressIndicator();
    } else {
      return Card(
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Курсовые преподавателя",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                    ),
                    itemCount: _courseworks.length,
                    itemBuilder: _buildListItemCourseworks,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: _buttonRefreshCourseworks()),
                  Flexible(child: _buttonCreateCourseworks()),
                  Flexible(child: _buttonConfirmCourseworks())
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _buttonRefreshCourseworks() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await Provider.of<CourseworkProvider>(context, listen: false)
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
    );
  }

  Widget _buttonCreateCourseworks() {
    return ElevatedButton(
      onPressed: () async {
        try {
          Provider.of<CourseworkProvider>(context, listen: false).coursework =
              Coursework.empty();
          setState(() {
            _nameTextController.clear();
            _descriptionTextController.clear();
            _selectedPreference!.clear();
            _preference = List.of(
                Provider.of<PreferenceProvider>(context, listen: false)
                    .allPreference);
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
      child: const Text("Новая"),
    );
  }

  Widget _buttonConfirmCourseworks() {
    return ElevatedButton(
      onPressed: () async {
        try {
          if (_selectedIndex != null) {
            _coursework =
                await Provider.of<CourseworkProvider>(context, listen: false)
                    .getCoursework(_courseworks[_selectedIndex!].id);
            _selectedPreference = _coursework.preferences;
            _nameTextController.text = _coursework.name!;
            _descriptionTextController.text = _coursework.description ?? "";
            _preference = List.of(
                Provider.of<PreferenceProvider>(context, listen: false)
                    .allPreference);
            _preference.removeWhere(
                (preference) => _selectedPreference!.contains(preference));
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
    );
  }

  Widget _buildListItemCourseworks(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      textColor: index == _selectedIndex ? Colors.white : Colors.black,
      tileColor: index == _selectedIndex ? Color(-14137996) : Colors.white,
      title: Center(
        child: Text(
          _courseworks[index].name!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
