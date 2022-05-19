import 'package:distribution_coursework/model/preference.dart';

class SaveCourseworkRequest {
  String name;
  String description;
  int? teacherId;
  List<Preference>? preferences=<Preference>[];

  SaveCourseworkRequest(this.name, this.teacherId, this.description, {this.preferences});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["description"] = description;
    map["preferences"] = map["preferences"] = preferences!.map((e) => e.toMap()).toList();
    map["teacherId"] = teacherId;

    return map;
  }
}
