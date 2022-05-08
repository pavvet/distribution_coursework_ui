import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/request/save_teacher_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:distribution_coursework/screen/components/add_preference.dart';
import 'package:distribution_coursework/screen/components/select_teacher.dart';
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

  Student _student;
  List<Preference> _preference = List.empty(growable: true);
  List<Preference> _selectedPreference = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<StudentProvider>(context, listen: false).init();
      _student = Provider.of<StudentProvider>(context, listen: false).student;
      if (_student != null && _student.isAuth()) {
        initAuthState();
      }
    });
  }

  void initAuthState() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _student.name,
          style: const TextStyle(fontSize: 40),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Expanded(flex: 1, child: SelectTeacherWidget()),
            Expanded(flex: 3, child: SwapChoiceWidget()),
            Expanded(flex: 2, child: _buildPreferencesList()),
          ],
        ),
      ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
}
