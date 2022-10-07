import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier{
  String get registerStudentUrl {
    return "https://test.pavelv.keenetic.link/student";
  }

  String get authStudentUrl {
    return "https://test.pavelv.keenetic.link/authStudent";
  }

  String get savePreferenceUrl {
    return "https://test.pavelv.keenetic.link/preference";
  }

  String get saveCourseworkUrl {
    return "https://test.pavelv.keenetic.link/coursework";
  }

  String get registerTeacherUrl {
    return "https://test.pavelv.keenetic.link/teacher";
  }

  String get authTeacherUrl {
    return "https://test.pavelv.keenetic.link/authTeacher";
  }

  String get getAllTeacherUrl {
    return "https://test.pavelv.keenetic.link/teachers";
  }

  String get getAllStudentsUrl {
    return "https://test.pavelv.keenetic.link/students";
  }

  String get getInfoStudentUrl {
    return "https://test.pavelv.keenetic.link/student/{studentId}";
  }

  String get getAllCourseworkUrl {
    return "https://test.pavelv.keenetic.link/courseworks";
  }

  String get getCourseworksForTeacherUrl {
    return "https://test.pavelv.keenetic.link/teacher/{teacherId}/courseworks";
  }

  String get getCourseworkUrl {
    return "https://test.pavelv.keenetic.link/coursework/{courseworkId}";
  }

  String get updateCourseworkUrl {
    return "https://test.pavelv.keenetic.link/coursework";
  }

  String get getResultDistributionUrl {
    return "https://test.pavelv.keenetic.link/distribution";
  }

  String get getAllPreferenceUrl {
    return "https://test.pavelv.keenetic.link/preferences";
  }

  String get addPreferredTeacherForStudentUrl {
    return "https://test.pavelv.keenetic.link/student/{studentId}/preferredTeacher/{teacherId}";
  }

  String get addCourseworkForStudent {
    return "https://test.pavelv.keenetic.link/student/{studentId}/coursework";
  }

  String get addPreferencesForStudentUrl {
    return "https://test.pavelv.keenetic.link/student/{studentId}/preferences";
  }

  String get addPreferencesForCourseworkUrl {
    return "https://test.pavelv.keenetic.link/coursework/{courseworkId}/preferences";
  }
}