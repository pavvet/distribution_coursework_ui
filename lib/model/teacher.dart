class Teacher {
  int id;
  String name;

  Teacher(this.name);

  Teacher.empty()
      : id = null,
        name = null;

  Teacher.fromJson(dynamic obj){
    id = obj["id"];
    name = obj["name"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  bool isAuth(){
    return id != null && name != null;
  }
}
