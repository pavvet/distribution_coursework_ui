import 'dart:convert';

import 'package:distribution_coursework/model/request/saveStudentRequest.dart';
import 'package:distribution_coursework/model/request/saveTeacherRequest.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/provider/settings_provider.dart';
import 'package:distribution_coursework/util/network_util.dart';

class StudentService {
  final NetworkUtil _netUtil = NetworkUtil();
  
  Future<void> saveStudent (SaveStudentRequest student) async {
    _netUtil.post(SettingsProvider().registerStudentUrl, body: jsonEncode(student.toMap()));
  }

  Future<void> saveTeacher (SaveTeacherRequest teacher) async {
    _netUtil.post(SettingsProvider().registerTeacherUrl, body: jsonEncode(teacher.toMap()));
  }
}
