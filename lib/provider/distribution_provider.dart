import 'dart:convert';
import 'dart:html';

import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/distribution.dart';
import 'package:distribution_coursework/model/pair_student_coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/request/auth_student_request.dart';
import 'package:distribution_coursework/model/request/save_coursework_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/service/coursework_service.dart';
import 'package:distribution_coursework/service/distribution_service.dart';
import 'package:distribution_coursework/service/preference_service.dart';
import 'package:distribution_coursework/service/student_service.dart';
import 'package:flutter/material.dart';

class DistributionProvider extends ChangeNotifier {
  final DistributionService _distributionService = DistributionService();

  static final DistributionProvider _instance = DistributionProvider.internal();

  DistributionProvider.internal();

  bool _busy = false;
  bool error = false;

  factory DistributionProvider() {
    return _instance;
  }

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _instance._busy = value;
    notifyListeners();
  }

  Future<List<PairStudentCoursework>> getResultDistribution() async {
    _instance.error = false;
    _instance.setBusy(true);
    try {
      return await _distributionService.fetchResultDistribution();
    } catch (error) {
      _instance.error = true;
      rethrow;
    } finally {
      _instance.setBusy(false);
    }
  }
}
