import 'dart:convert';

import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/settings_provider.dart';
import 'package:distribution_coursework/util/network_util.dart';

class PreferenceService {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<Preference> savePreference(String name) async {
    final request = {"name" : name};
    final response = await _netUtil.post(SettingsProvider().savePreferenceUrl,
        body: jsonEncode(request));
    return Preference.fromJson(response);
  }

  Future<void> addPreferencesForStudent(
      List<Preference> preferences, int studentId) async {
    final request = {"preferences" : preferences.map((e) => e.toMap()).toList()};
    //String request = jsonEncode(preferences.map((e) => e.toMap()).toList());
    await _netUtil.put(SettingsProvider()
        .addPreferencesForStudentUrl
        .replaceAll("{studentId}", "1"), body: jsonEncode(request));
  }

  Future<List<Preference>> fetchAllPreference() async {
    final response = await _netUtil.get(SettingsProvider().getAllPreferenceUrl);
    List<Preference> responseItems = List.empty(growable: true);
    if ((response as List).isNotEmpty) {
      responseItems = (response as List)
          .map((preference) => Preference.fromJson(preference))
          .toList();
    }
    return responseItems;
  }
}
