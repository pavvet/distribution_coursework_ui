import 'dart:convert';
import 'dart:html';

import 'package:distribution_coursework/exception/app_exception.dart';
import 'package:distribution_coursework/model/request/auth_student_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/settings_provider.dart';
import 'package:distribution_coursework/util/network_util.dart';

class StudentService {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<Student> saveStudent(SaveStudentRequest student) async {
    final response = await _netUtil.post(SettingsProvider().registerStudentUrl,
        body: jsonEncode(student.toMap()));
    if (response == null) {
      throw SaveStudentException();
    }
    window.localStorage["student"] = jsonEncode(response);
    return Student.shotInfoFromJson(response);
  }

  Future<List<Student>> fetchAllStudents() async {
    final response = await _netUtil.get(SettingsProvider().getAllStudentsUrl);
    List<Student> responseItems = List.empty(growable: true);
    if ((response as List).isNotEmpty) {
      responseItems =
          response.map((student) => Student.fullInfoFromJson(student)).toList();
    }
    return responseItems;
  }

  Future<Student> authStudent(AuthStudentRequest student) async {
    final response = await _netUtil.post(SettingsProvider().authStudentUrl,
        body: jsonEncode(student.toMap()));
    if (response == null) {
      throw AuthStudentException();
    }
    window.localStorage["student"] = jsonEncode(response);
    return Student.fullInfoFromJson(response);
  }

  Future<Student> getInfoStudent(int studentId) async {
    final response = await _netUtil.get(SettingsProvider()
        .getInfoStudentUrl
        .replaceAll("{studentId}", studentId.toString()));
    if (response == null) {
      throw AuthStudentException();
    }
    window.localStorage["student"] = jsonEncode(response);
    return Student.fullInfoFromJson(response);
  }

  Future<void> addPreferredTeacherForStudent(
      int? teacherId, int? studentId) async {
    await _netUtil.put(SettingsProvider()
        .addPreferredTeacherForStudentUrl
        .replaceAll("{studentId}", studentId.toString())
        .replaceAll("{teacherId}", teacherId.toString()));
  }
}
