import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/util/scaffold_messenger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwapChoiceWidget extends StatefulWidget {
  const SwapChoiceWidget({Key? key}) : super(key: key);

  @override
  _SwapChoiceState createState() => _SwapChoiceState();
}

class _SwapChoiceState extends State<SwapChoiceWidget> {
  List<Coursework> _courseworkList = List.empty(growable: true);
  List<Coursework> _selectedCourseworkList = List.empty(growable: true);
  List<Coursework> _unselectedCourseworkList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final _student =
          Provider.of<StudentProvider>(context, listen: false).student;
      _selectedCourseworkList =
          _student.selectedCoursework ?? List.empty(growable: true);
      _unselectedCourseworkList =
          _student.unselectedCoursework ?? List.empty(growable: true);
      await Provider.of<CourseworkProvider>(context, listen: false)
          .getAllCoursework()
          .then((List<Coursework> value) {
        _courseworkList = value
            .where((coursework) =>
                !_selectedCourseworkList.contains(coursework) &&
                !_unselectedCourseworkList.contains(coursework))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final CourseworkProvider courseworkProvider =
        Provider.of<CourseworkProvider>(context);
    if (courseworkProvider.isBusy) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height * 8 / 10,
          child: Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "Не хочу заниматься",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.black,
                                  ),
                                  controller: ScrollController(),
                                  itemCount: _unselectedCourseworkList.length,
                                  itemBuilder: _buildListUnselectedItem,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(
                            thickness: 1,
                            color: Colors.black,
                            indent: 0,
                            endIndent: 0),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "Могу заниматься",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.black,
                                  ),
                                  controller: ScrollController(),
                                  itemCount: _courseworkList.length,
                                  itemBuilder: _buildListItem,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(
                            thickness: 1,
                            color: Colors.black,
                            indent: 0,
                            endIndent: 0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Хочу заниматься",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.black,
                                  ),
                                  controller: ScrollController(),
                                  itemCount: _selectedCourseworkList.length,
                                  itemBuilder: _buildListSelectedItem,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buttonRefreshCourseworks(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buttonConfirmCourseworks(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buttonConfirmCourseworks() {
    return ElevatedButton(
      onPressed: () async {
        try {
          final student =
              Provider.of<StudentProvider>(context, listen: false).student;
          await Provider.of<CourseworkProvider>(context, listen: false)
              .addCourseworkForStudent(
                  _selectedCourseworkList.map((e) => e.id).toList(),
                  _unselectedCourseworkList.map((e) => e.id).toList(),
                  student.id);
          await Provider.of<StudentProvider>(context, listen: false)
              .getStudent();
          CustomScaffoldMessenger.build(
            text: "Курсовые проекты успешно выбраны",
            isGreen: true,
            context: context,
          );
        } catch (e) {
          CustomScaffoldMessenger.build(
            text: "Произошла ошибка",
            isGreen: false,
            context: context,
          );
          if (kDebugMode) {
            print(e);
          }
        }
      },
      child: const Text("Подтвердить"),
    );
  }

  Widget _buttonRefreshCourseworks() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await Provider.of<CourseworkProvider>(context, listen: false)
              .getAllCoursework()
              .then((List<Coursework> value) {
            _courseworkList = value
                .where((coursework) =>
                    !_selectedCourseworkList.contains(coursework) &&
                    !_unselectedCourseworkList.contains(coursework))
                .toList();
          });
          CustomScaffoldMessenger.build(
            text: "Список курсовых проектов успешно обновлен",
            isGreen: true,
            context: context,
          );
        } catch (e) {
          CustomScaffoldMessenger.build(
            text: "Произошла ошибка",
            isGreen: false,
            context: context,
          );
          if (kDebugMode) {
            print(e);
          }
        }
      },
      child: const Text("Обновить"),
    );
  }

  Widget _buildListUnselectedItem(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        setState(() {
          _courseworkList.add(_unselectedCourseworkList[index]);
          _unselectedCourseworkList.removeAt(index);
        });
      },
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialog(_unselectedCourseworkList[index]);
            },
          );
        },
        title: Center(
          child: Text(
            _unselectedCourseworkList[index].name!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          setState(() {
            _selectedCourseworkList.add(_courseworkList[index]);
            _courseworkList.removeAt(index);
          });
        } else {
          setState(() {
            _unselectedCourseworkList.add(_courseworkList[index]);
            _courseworkList.removeAt(index);
          });
        }
      },
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.check),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.clear),
      ),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialog(_courseworkList[index]);
            },
          );
        },
        title: Center(
          child: Text(
            _courseworkList[index].name!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildListSelectedItem(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {
        setState(() {
          _courseworkList.add(_selectedCourseworkList[index]);
          _selectedCourseworkList.removeAt(index);
        });
      },
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialog(_selectedCourseworkList[index]);
            },
          );
        },
        title: Center(
          child: Text(
            _selectedCourseworkList[index].name!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  AlertDialog alertDialog(Coursework coursework) {
    return AlertDialog(
      title: Text(coursework.name.toString()),
      content: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: "Преподаватель: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: coursework.teacher?.name.toString(),
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
            const TextSpan(
              text: "\n\nКлючевые слова:\n",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: coursework.preferenceToString(),
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
            const TextSpan(
              text: "\n\nОписание:\n",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: coursework.description.toString(),
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Закрыть"))
      ],
    );
  }
}
