import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/util/scaffold_messenger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_preference.dart';

class SplitChoiceStudentWidget extends StatefulWidget {
  const SplitChoiceStudentWidget({Key? key}) : super(key: key);

  @override
  _SplitChoiceStudentState createState() => _SplitChoiceStudentState();
}

class _SplitChoiceStudentState extends State<SplitChoiceStudentWidget> {
  List<Preference> _preference = List.empty(growable: true);
  List<Preference> _selectedPreference = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final _student =
          Provider.of<StudentProvider>(context, listen: false).student;
      _selectedPreference = _student.preferences ?? List.empty(growable: true);
      await Provider.of<PreferenceProvider>(context, listen: false)
          .getAllPreference()
          .then((List<Preference> value) {
        _preference = value
            .where((preference) => !_selectedPreference.contains(preference))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          height: MediaQuery.of(context).size.height * 8 / 10,
          child: Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "Предпочтения",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.black,
                                  ),
                                  controller: ScrollController(),
                                  itemCount: _preference.length,
                                  itemBuilder: _buildListItem,
                                ),
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
                                "Выбранные предпочтения",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.black,
                                  ),
                                  controller: ScrollController(),
                                  itemCount: _selectedPreference.length,
                                  itemBuilder: _buildListSelectedItem,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await Provider.of<PreferenceProvider>(context,
                                    listen: false)
                                .getAllPreference()
                                .then((List<Preference> value) {
                              _preference = value
                                  .where((preference) =>
                                      !_selectedPreference.contains(preference))
                                  .toList();
                            });
                            CustomScaffoldMessenger.build(
                              text: "Список предпочтений успешно обновлён",
                              isGreen: true,
                              context: context,
                            );
                          } catch (e) {
                            CustomScaffoldMessenger.build(
                              text: "Произошла ошибка",
                              isGreen: false,
                              context: context,
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
                                    .where((preference) => !_selectedPreference
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
                            try {
                              await Provider.of<StudentProvider>(context,
                                      listen: false)
                                  .addPreferencesForStudent(
                                      _selectedPreference);
                              await Provider.of<StudentProvider>(context, listen: false)
                                  .getStudent();
                              CustomScaffoldMessenger.build(
                                text: "Предпочтения успешно выбраны",
                                isGreen: true,
                                context: context,
                              );
                            } catch (e) {
                              CustomScaffoldMessenger.build(
                                text: "Произошла ошибка",
                                isGreen: false,
                                context: context,
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

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          _selectedPreference.add(_preference[index]);
          _preference.removeAt(index);
        });
      },
      title: Center(
        child: Text(_preference[index].name!,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _buildListSelectedItem(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          _preference.add(_selectedPreference[index]);
          _selectedPreference.removeAt(index);
        });
      },
      title: Center(
        child: Text(_selectedPreference[index].name!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
