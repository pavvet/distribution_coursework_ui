import 'dart:convert';
import 'dart:html';

import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/auth_student_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/service/preference_service.dart';
import 'package:distribution_coursework/service/student_service.dart';
import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier {
  final StudentService _studentService = StudentService();
  final PreferenceService _preferenceService = PreferenceService();

  static final StudentProvider _instance = StudentProvider.internal();
  StudentProvider.internal();

  Student _student = Student.empty();

  Student get student => _student;

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

  Future<void> init() async {
    if (_student == null || !_student.isAuth()){
      if (window.localStorage["student"] != null) {
        _student = Student.fullInfoFromJson(
            jsonDecode(window.localStorage["student"]!));
        notifyListeners();
      }
    }
  }

  void exit(){
    window.localStorage.remove("student");
  }

  Future<void> saveStudent(SaveStudentRequest studentRequest) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      _instance._student = await _studentService.saveStudent(studentRequest);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<List<Student>> getAllStudents() async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _studentService.fetchAllStudents();
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<void> authStudent(AuthStudentRequest authStudentRequest) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      _instance._student = await _studentService.authStudent(authStudentRequest);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<void> getStudent() async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      _instance._student = await _studentService.getInfoStudent(_instance.student.id!);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<void> addPreferredTeacherForStudent(int? teacherId) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      await _studentService.addPreferredTeacherForStudent(teacherId, _student.id);
      return;
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<void> addPreferencesForStudent(List<Preference> preferences) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _preferenceService.addPreferencesForStudent(preferences, _student.id);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }
}