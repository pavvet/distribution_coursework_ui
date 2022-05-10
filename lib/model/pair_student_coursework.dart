import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/student.dart';

class PairStudentCoursework {
  Student? student;
  Coursework? coursework;
  int? score;

  PairStudentCoursework(this.student, this.coursework);

  PairStudentCoursework.empty()
      : student = null,
        coursework = null,
  score = null;

  PairStudentCoursework.fromJson(dynamic obj) {
    student = Student.shotInfoFromJson(obj["student"]);
    coursework = Coursework.shotInfoFromJson(obj["coursework"]);
    score = obj["score"];
  }
}
