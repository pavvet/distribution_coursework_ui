import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/service/student_service.dart';
import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier {
  final StudentService _studentService = StudentService();

  static final StudentProvider _instance = StudentProvider.internal();
  StudentProvider.internal();

  Student student = Student.empty();

  bool _busy = false;
  bool error = false;

  factory StudentProvider(){
    return _instance;
  }

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _instance._busy = value;
    notifyListeners();
  }

  Future<void> saveStudent(SaveStudentRequest studentRequest) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      student = await _studentService.saveStudent(studentRequest);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<void> addPreferredTeacherForStudent(int teacherId) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _studentService.addPreferredTeacherForStudent(teacherId, student.id);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }
}