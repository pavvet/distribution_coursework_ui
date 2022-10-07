class AuthStudentRequest {
  String login;
  String password;
  AuthStudentRequest(this.login, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["login"] = login;
    map["password"] = password;
    return map;
  }
}
