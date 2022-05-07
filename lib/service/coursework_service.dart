import 'dart:convert';
import 'dart:html';

import 'package:distribution_coursework/exception/app_exception.dart';
import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/request/auth_student_request.dart';
import 'package:distribution_coursework/model/request/save_coursework_request.dart';
import 'package:distribution_coursework/model/request/save_student_request.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/model/teacher.dart';
import 'package:distribution_coursework/provider/settings_provider.dart';
import 'package:distribution_coursework/util/network_util.dart';

class CourseworkService {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<Coursework> saveCoursework(SaveCourseworkRequest courseworkRequest) async {
    final response = await _netUtil.post(SettingsProvider().saveCourseworkUrl,
        body: jsonEncode(courseworkRequest.toMap()));
    if(response == null) {
      throw SaveCourseworkException();
    }
    return Coursework.fullInfoFromJson(response);
  }

  Future<List<Coursework>> fetchAllCoursework() async {
    final response = await _netUtil.get(SettingsProvider().getAllCourseworkUrl);
    List<Coursework> responseItems = List.empty(growable: true);
    if ((response as List).isNotEmpty) {
      responseItems = (response as List)
          .map((coursework) => Coursework.fullInfoFromJson(coursework))
          .toList();
    }
    return responseItems;
  }
}
