import 'dart:convert';
import 'dart:html';

import 'package:distribution_coursework/model/request/auth_teacher_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/request/save_teacher_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/service/student_service.dart';
import 'package:distribution_coursework/service/teacher_service.dart';
import 'package:flutter/material.dart';

class TeacherProvider extends ChangeNotifier {
  final TeacherService _teacherService = TeacherService();

  static final TeacherProvider _instance = TeacherProvider.internal();
  TeacherProvider.internal();

  bool _busy = false;
  bool error = false;

  Teacher _teacher;

  Teacher get teacher => _teacher;

  factory TeacherProvider(){
    return _instance;
  }

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _instance._busy = value;
    notifyListeners();
  }

  Future<void> init() async {
    if (_teacher == null || !_teacher.isAuth()){
      if (window.localStorage["teacher"] != null) {
        _teacher = Teacher.fromJson(jsonDecode(window.localStorage["teacher"]));
        notifyListeners();
      }
    }
  }

  Future<void> saveTeacher(SaveTeacherRequest teacherRequest) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      _instance._teacher = await _teacherService.saveTeacher(teacherRequest);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<void> authTeacher(AuthTeacherRequest teacherRequest) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      _instance._teacher = await _teacherService.authTeacher(teacherRequest);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<List<Teacher>> getAllTeachers() async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _teacherService.fetchAllTeachers();
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

}