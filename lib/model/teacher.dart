
import 'dart:html';

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

  bool isAuth(){
    return id != null && name != null;
  }
}
