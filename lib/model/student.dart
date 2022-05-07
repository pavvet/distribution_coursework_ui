import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/teacher.dart';

class Student {
  int id;
  String name;
  List<Preference> preferences;
  Teacher teacher;

  Student(this.name);

  Student.empty()
      : id = null,
        name = null,
        preferences = <Preference>[],
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
        preferences.add(Preference.fromJson(pref));
      });
    }
    teacher = obj["teacher"] != null ? Teacher.fromJson(obj["teacher"]) : null;
  }

  bool isAuth() {
    return id != null && name != null;
  }
}
