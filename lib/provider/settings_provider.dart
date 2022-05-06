import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier{
  String get registerStudentUrl {
    return "http://localhost:8095/student";
  }

  String get savePreferenceUrl {
    return "http://localhost:8095/preference";
  }

  String get registerTeacherUrl {
    return "http://localhost:8095/teacher";
  }

  String get getAllTeacherUrl {
    return "http://localhost:8095/teachers";
  }

  String get getAllPreferenceUrl {
    return "http://localhost:8095/preferences";
  }

  String get addPreferredTeacherForStudentUrl {
    return "http://localhost:8095/student/{studentId}/preferredTeacher/{teacherId}";
  }

  String get addPreferencesForStudentUrl {
    return "http://localhost:8095/student/{studentId}/preferences";
  }
}