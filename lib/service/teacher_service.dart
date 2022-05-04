import 'dart:convert';

import 'package:distribution_coursework/model/request/saveStudentRequest.dart';
import 'package:distribution_coursework/model/request/saveTeacherRequest.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/settings_provider.dart';
import 'package:distribution_coursework/util/network_util.dart';

class TeacherService {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<void> saveTeacher(SaveTeacherRequest teacher) async {
    _netUtil.post(SettingsProvider().registerTeacherUrl,
        body: jsonEncode(teacher.toMap()));
  }

  Future<List<Teacher>> fetchAllTeachers() async {
    final response = await _netUtil.get(SettingsProvider().getAllTeacherUrl);
    List<Teacher> responseItems = List.empty(growable: true);
    if ((response as List).isNotEmpty) {
      responseItems = (response as List)
          .map((teacher) => Teacher.fromJson(teacher))
          .toList();
    }
    return responseItems;
  }
}
