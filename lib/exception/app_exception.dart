class SaveStudentException implements Exception {
  String message() {
    return "Не удалось сохранить студента";
  }
}

class SaveCourseworkException implements Exception {
  String message() {
    return "Не удалось сохранить курсовую работу";
  }
}

class SaveTeacherException implements Exception {
  String message() {
    return "Не удалось сохранить преподавателя";
  }
}

class SavePreferenceException implements Exception {
  String message() {
    return "Не удалось сохранить предпочтение";
  }
}

class AuthStudentException implements Exception {
  String message() {
    return "Не удалось найти данного студента";
  }
}

class AuthTeacherException implements Exception {
  String message() {
    return "Не удалось найти данного преподавателя";
  }
}