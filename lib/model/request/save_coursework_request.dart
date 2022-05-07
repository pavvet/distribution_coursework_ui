class SaveCourseworkRequest {
  String name;
  int teacherId;

  SaveCourseworkRequest(this.name, this.teacherId);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["teacherId"] = teacherId;
    return map;
  }
}
