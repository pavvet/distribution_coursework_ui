import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier{
  String get registerStudentUrl {
    return "http://localhost:8095/student";
  }

  String get registerTeacherUrl {
    return "http://localhost:8095/teacher";
  }
}