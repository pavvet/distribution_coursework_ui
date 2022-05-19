import 'dart:convert';
import 'dart:html';

import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/auth_student_request.dart';
import 'package:distribution_coursework/model/request/save_coursework_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/service/coursework_service.dart';
import 'package:distribution_coursework/service/preference_service.dart';
import 'package:distribution_coursework/service/student_service.dart';
import 'package:flutter/material.dart';

class CourseworkProvider extends ChangeNotifier {
  final CourseworkService _courseworkService = CourseworkService();
  final PreferenceService _preferenceService = PreferenceService();

  static final CourseworkProvider _instance = CourseworkProvider.internal();

  CourseworkProvider.internal();

  Coursework _coursework = Coursework.empty();

  set coursework(Coursework value) {
    _coursework = value;
  }

  Coursework get coursework => _coursework;

  bool _busy = false;
  bool error = false;

  factory CourseworkProvider() {
    return _instance;
  }

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _instance._busy = value;
    notifyListeners();
  }

  Future<Coursework> saveCoursework(SaveCourseworkRequest courseworkRequest) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      _instance._coursework =
          await _courseworkService.saveCoursework(courseworkRequest);
      return _instance._coursework;
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<List<Coursework>> getAllCoursework() async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _courseworkService.fetchAllCoursework();
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<List<Coursework>> getCourseworksForTeacher(int? teacherId) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _courseworkService.fetchCourseworksForTeacher(teacherId);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<Coursework> getCoursework(int? courseworkId) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      _instance._coursework = await _courseworkService.fetchCoursework(courseworkId);
      return _instance._coursework;
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<void> updateCoursework(String name, String description, List<Preference> preferences) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      _instance.coursework.name = name;
      _instance.coursework.description = description;
      _instance.coursework.preferences = preferences;
      _instance.coursework = await _courseworkService.updateCoursework(coursework);
      return;
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<void> addCourseworkForStudent(List<int?> selected, List<int?> unselected, int? studentId) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      await _courseworkService.addCourseworkForStudent(selected, unselected, studentId);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }
}
