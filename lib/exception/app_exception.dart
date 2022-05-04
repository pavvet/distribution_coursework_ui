class SaveStudentException implements Exception {
  String message() {
    return "Не удалось сохранить студента";
  }
}

class SaveTeacherException implements Exception {
  String message() {
    return "Не удалось сохранить преподавателя";
  }
}
