import 'dart:convert';
import 'dart:html';

import 'package:distribution_coursework/exception/app_exception.dart';
import 'package:distribution_coursework/model/request/auth_teacher_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/request/save_teacher_request.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/settings_provider.dart';
import 'package:distribution_coursework/util/network_util.dart';

class TeacherService {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<Teacher> saveTeacher(SaveTeacherRequest teacher) async {
    final response = await _netUtil.post(SettingsProvider().registerTeacherUrl,
        body: jsonEncode(teacher.toMap()));
    if (response == null) {
      throw SaveTeacherException();
    }
    window.localStorage["teacher"] = jsonEncode(response);
    return Teacher.fromJson(response);

  }

  Future<Teacher> authTeacher(AuthTeacherRequest teacher) async {
    final response = await _netUtil.post(SettingsProvider().authTeacherUrl,
        body: jsonEncode(teacher.toMap()));
    if (response == null) {
      throw AuthTeacherException();
    }
    window.localStorage["teacher"] = jsonEncode(response);
    return Teacher.fromJson(response);
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
