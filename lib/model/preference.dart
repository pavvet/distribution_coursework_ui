class Preference {
  int? id;
  String? name;
  Preference(this.name);

  Preference.empty()
      : id = null,
        name = null;

  Preference.fromJson(dynamic obj) {
    id = obj["id"];
    name = obj["name"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Preference &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
