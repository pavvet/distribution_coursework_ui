import 'dart:convert';

import 'package:distribution_coursework/model/request/saveStudentRequest.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/settings_provider.dart';
import 'package:distribution_coursework/util/network_util.dart';

class StudentService {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<Student> saveStudent(SaveStudentRequest student) async {
    final response = await _netUtil.post(SettingsProvider().registerStudentUrl,
        body: jsonEncode(student.toMap()));
    return Student.fromJson(response);
  }

  Future<void> addPreferredTeacherForStudent(
      int teacherId, int studentId) async {
    await _netUtil.put(SettingsProvider()
        .addPreferredTeacherForStudentUrl
        .replaceAll("{studentId}", studentId.toString())
        .replaceAll("{teacherId}", teacherId.toString()));
  }
}
