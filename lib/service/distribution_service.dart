import 'dart:convert';
import 'dart:html';

import 'package:distribution_coursework/exception/app_exception.dart';
import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/pair_student_coursework.dart';
import 'package:distribution_coursework/model/request/auth_student_request.dart';
import 'package:distribution_coursework/model/request/save_coursework_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/settings_provider.dart';
import 'package:distribution_coursework/util/network_util.dart';

class DistributionService {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<List<PairStudentCoursework>> fetchResultDistribution() async {
    final response = await _netUtil.get(SettingsProvider().getResultDistributionUrl);
    List<PairStudentCoursework> responseItems = List.empty(growable: true);
    if ((response as List).isNotEmpty) {
      responseItems = (response as List)
          .map((pair) => PairStudentCoursework.fromJson(pair))
          .toList();
    }
    return responseItems;
  }
}
