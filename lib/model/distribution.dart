import 'package:distribution_coursework/model/pair_student_coursework.dart';

class Distribution {
  List<PairStudentCoursework>? distribution;
  Distribution(this.distribution);

  Distribution.empty()
      : distribution = null;

  Distribution.fromJson(dynamic obj) {
    distribution = [];
    if (obj["distribution"] != null) {
      obj["distribution"].forEach((result) {
        distribution!.add(PairStudentCoursework.fromJsonShort(result));
      });
    }
  }
}
