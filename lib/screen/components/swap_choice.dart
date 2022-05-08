import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwapChoiceWidget extends StatefulWidget {
  SwapChoiceWidget({Key key}) : super(key: key);

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
          height: MediaQuery.of(context).size.height / 2,
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
                                child: ListView.builder(
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
                                child: ListView.builder(
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
                                child: ListView.builder(
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Provider.of<CourseworkProvider>(context,
                                  listen: false)
                              .getAllCoursework()
                              .then((List<Coursework> value) {
                            _courseworkList = value
                                .where((coursework) =>
                                    !_selectedCourseworkList
                                        .contains(coursework) &&
                                    !_unselectedCourseworkList
                                        .contains(coursework))
                                .toList();
                          });
                        },
                        child: const Text("Обновить"),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () async {
                            final student = Provider.of<StudentProvider>(
                                    context,
                                    listen: false)
                                .student;
                            await Provider.of<CourseworkProvider>(context,
                                    listen: false)
                                .addCourseworkForStudent(
                                    _selectedCourseworkList
                                        .map((e) => e.id)
                                        .toList(),
                                    _unselectedCourseworkList
                                        .map((e) => e.id)
                                        .toList(),
                                    student.id);
                          },
                          child: const Text("Подтвердить"),
                        ),
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

  Widget _buildListUnselectedItem(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          _courseworkList.add(_unselectedCourseworkList[index]);
          _unselectedCourseworkList.removeAt(index);
        });
      },
      title: Center(
        child: Text(_unselectedCourseworkList[index].name,
            style: const TextStyle(fontSize: 20)),
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
          setState(() {
            _selectedCourseworkList.add(_courseworkList[index]);
            _courseworkList.removeAt(index);
          });
        },
        title: Center(
          child: Text(_courseworkList[index].name,
              style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Widget _buildListSelectedItem(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          _courseworkList.add(_selectedCourseworkList[index]);
          _selectedCourseworkList.removeAt(index);
        });
      },
      title: Center(
        child: Text(_selectedCourseworkList[index].name,
            style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
