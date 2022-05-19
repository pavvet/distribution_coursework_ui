import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/teacher.dart';

class Coursework {
  int? id;
  String? name;
  String? description;
  List<Preference>? preferences;
  Teacher? teacher;

  Coursework(this.name);

  Coursework.empty()
      : id = null,
        name = null,
        description = null,
        preferences = <Preference>[],
        teacher = null;

  Coursework.shotInfoFromJson(dynamic obj) {
    id = obj["id"];
    name = obj["name"];
    description = obj["description"];
  }

  String preferenceToString() {
    String? result = preferences?.map((e) => e.name).toList().join(", ");
    return result!;
  }

  Coursework.fullInfoFromJson(dynamic obj) {
    id = obj["id"];
    name = obj["name"];
    description = obj["description"];
    preferences = <Preference>[];
    if (obj["preferences"] != null) {
      obj["preferences"].forEach((pref) {
        preferences!.add(Preference.fromJson(pref));
      });
    }
    teacher = obj["teacher"] != null ? Teacher.fromJson(obj["teacher"]) : null;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["preferences"] = preferences!.map((e) => e.toMap()).toList();
    map["teacher"] = teacher!.toMap();
    return map;
  }

  Map<String, dynamic> toMapWithTeacherId() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["preferences"] = preferences!.map((e) => e.toMap()).toList();
    map["teacherId"] = teacher!.id;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coursework &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
