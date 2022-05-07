import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/service/preference_service.dart';
import 'package:distribution_coursework/service/student_service.dart';
import 'package:flutter/material.dart';

class PreferenceProvider extends ChangeNotifier {
  final PreferenceService _preferenceService = PreferenceService();

  static final PreferenceProvider _instance = PreferenceProvider.internal();
  PreferenceProvider.internal();

  bool _busy = false;
  bool error = false;

  factory PreferenceProvider(){
    return _instance;
  }

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _instance._busy = value;
    notifyListeners();
  }

  Future<Preference> savePreference(String preferenceName) async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _preferenceService.savePreference(preferenceName);
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }

  Future<List<Preference>> getAllPreference() async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _preferenceService.fetchAllPreference();
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }
}