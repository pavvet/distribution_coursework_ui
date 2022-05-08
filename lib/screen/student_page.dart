import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/screen/components/add_preference.dart';
import 'package:distribution_coursework/screen/components/select_teacher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/split_choice.dart';
import 'components/swap_choice.dart';
import 'unauthorize_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _scaffoldKey = GlobalKey();

  Student _student;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<StudentProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentProvider>(context).student;
    if (student != null && student.isAuth()) {
      return Scaffold(
        appBar: AppBar(
          key: _scaffoldKey,
        ),
        body: _buildBody(),
      );
    } else {
      return const UnauthorizedPage();
    }
  }

  Widget _buildBody() {
    final studentProvider = Provider.of<StudentProvider>(context);
    if (studentProvider.isBusy) {
      return const CircularProgressIndicator();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _student != null ? _student.name : "",
            style: const TextStyle(fontSize: 40),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(flex: 1, child: SelectTeacherWidget()),
              Expanded(flex: 3, child: SwapChoiceWidget()),
              Expanded(flex: 2, child: SplitChoiceStudentWidget()),
            ],
          ),
        ],
      );
    }
  }
}
