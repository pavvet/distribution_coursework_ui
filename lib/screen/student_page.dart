import 'package:distribution_coursework/model/student.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/screen/components/select_teacher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/split_choice.dart';
import 'components/swap_choice.dart';
import 'unauthorize_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _scaffoldKey = GlobalKey();

  Student? _student;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<StudentProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentProvider>(context).student;
    if (student != null && student.isAuth()) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      );
    } else {
      return const UnauthorizedPage();
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      key: _scaffoldKey,
      title: const Center(child: Text("Личная страница студента")),
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            constraints: const BoxConstraints.expand(width: 80, height: 80),
            onPressed: () {
              Provider.of<StudentProvider>(context, listen: false).exit();
              Navigator.pushNamedAndRemoveUntil(context, "/auth", (route)=>false);
            },
            icon: const Icon(Icons.arrow_back));
      }),
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertDialog();
                },
              );
            },
            icon: const Icon(Icons.help_outline_outlined))
      ],
    );
  }

  AlertDialog alertDialog() {
    return AlertDialog(
      title: const Text("Описание"),
      content: const Text(
          'Столбец "Предпочтительный руководитель" - устанавливает предпочтительного руководителя для данного студента.'
          '\nКнопка "Подтвердить" подтверждает выбор руководителя.'
          '\n\nСписок посередине, состоящий из трёх столбцов, отвечает за выбранные курсовые проекты.'
          '\nВыбор осуществляется перетягиванием из среднего столбца курсовых влево или вправо. '
          '\nПеремещение из левого или правого столбца в средний осуществляется перетягиванием в соответствующую сторону.'
          '\nЧтобы узнать информацию о курсовом проекте, нужно нажать на её название.'
          '\n\nПоследний список, состоящий из двух столбцов, отвечает за выбранные предпочтения студента.'
          '\nНажатие на элементы списка перемещает их из одного столбца в другой.'
          '\nКнопка "Обновить" - обновляет список.'
          '\nКнопка "Добавить" - добавляет новое слово в данный список.'
          '\nКнопка "Подтвердить" - сохраняет сделанный выбор.'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Закрыть"))
      ],
    );
  }

  Widget _buildBody() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _student != null ? _student!.name! : "",
            style: const TextStyle(fontSize: 40),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(flex: 1, child: SelectTeacherWidget()),
              Expanded(flex: 3, child: SwapChoiceWidget()),
              Expanded(flex: 2, child: SplitChoiceStudentWidget()),
            ],
          ),
        ],
      );
  }
}
