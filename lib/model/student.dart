import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/teacher.dart';

class Student {
  int? id;
  String? name;
  List<Preference>? preferences;
  Teacher? teacher;
  List<Coursework>? selectedCoursework;
  List<Coursework>? unselectedCoursework;
  

  Student(this.name);

  Student.empty()
      : id = null,
        name = null,
        preferences = <Preference>[],
        selectedCoursework = <Coursework>[],
        unselectedCoursework = <Coursework>[],
        teacher = null;

  Student.shotInfoFromJson(dynamic obj) {
    id = obj["id"];
    name = obj["name"];
  }

  Student.fullInfoFromJson(dynamic obj) {
    id = obj["id"];
    name = obj["name"];
    preferences = <Preference>[];
    if (obj["preferences"] != null) {
      obj["preferences"].forEach((pref) {
        preferences!.add(Preference.fromJson(pref));
      });
    }
    selectedCoursework = <Coursework>[];
    if (obj["selectedCoursework"] != null) {
      obj["selectedCoursework"].forEach((coursework) {
        selectedCoursework!.add(Coursework.shotInfoFromJson(coursework));
      });
    }
    unselectedCoursework = <Coursework>[];
    if (obj["unselectedCoursework"] != null) {
      obj["unselectedCoursework"].forEach((coursework) {
        unselectedCoursework!.add(Coursework.shotInfoFromJson(coursework));
      });
    }
    teacher = obj["teacher"] != null ? Teacher.fromJson(obj["teacher"]) : null;
  }

  bool isAuth() {
    return id != null && name != null;
  }
}
