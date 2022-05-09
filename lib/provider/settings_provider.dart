import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier{
  String get registerStudentUrl {
    return "http://localhost:8095/student";
  }

  String get authStudentUrl {
    return "http://localhost:8095/authStudent";
  }

  String get savePreferenceUrl {
    return "http://localhost:8095/preference";
  }

  String get saveCourseworkUrl {
    return "http://localhost:8095/coursework";
  }

  String get registerTeacherUrl {
    return "http://localhost:8095/teacher";
  }

  String get authTeacherUrl {
    return "http://localhost:8095/authTeacher";
  }

  String get getAllTeacherUrl {
    return "http://localhost:8095/teachers";
  }

  String get getAllStudentsUrl {
    return "http://localhost:8095/students";
  }

  String get getAllCourseworkUrl {
    return "http://localhost:8095/courseworks";
  }

  String get getCourseworksForTeacherUrl {
    return "http://localhost:8095/teacher/{teacherId}/courseworks";
  }

  String get getCourseworkUrl {
    return "http://localhost:8095/coursework/{courseworkId}";
  }

  String get getResultDistributionUrl {
    return "http://localhost:8095/distribution";
  }

  String get getAllPreferenceUrl {
    return "http://localhost:8095/preferences";
  }

  String get addPreferredTeacherForStudentUrl {
    return "http://localhost:8095/student/{studentId}/preferredTeacher/{teacherId}";
  }

  String get addCourseworkForStudent {
    return "http://localhost:8095/student/{studentId}/coursework";
  }

  String get addPreferencesForStudentUrl {
    return "http://localhost:8095/student/{studentId}/preferences";
  }

  String get addPreferencesForCourseworkUrl {
    return "http://localhost:8095/coursework/{courseworkId}/preferences";
  }
}