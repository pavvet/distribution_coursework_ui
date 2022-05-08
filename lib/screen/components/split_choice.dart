import 'package:distribution_coursework/model/preference.dart';
import 'package:flutter/material.dart';

class SplitChoiceWidget extends StatefulWidget {

  List<Preference> items = List.empty(growable: true);
  List<Preference> selectedItems = List.empty(growable: true);
  
  SplitChoiceWidget({Key key, this.items, this.selectedItems}) : super(key: key);

  @override
  _SplitChoiceState createState() => _SplitChoiceState();
}

class _SplitChoiceState extends State<SplitChoiceWidget>{

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text("Предпочтения"),
                  Expanded(
                    child: ListView.builder(
                      controller: ScrollController(),
                      itemCount: widget.items.length,
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
                  const Text("Выбранные предпочтения"),
                  Expanded(
                    child: ListView.builder(
                      controller: ScrollController(),
                      itemCount: widget.selectedItems.length,
                      itemBuilder: _buildListSelectedItem,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          widget.selectedItems.add(widget.items[index]);
          widget.items.removeAt(index);
        });
      },
      title: Text(widget.items[index].name, style: const TextStyle(fontSize: 24)),
    );
  }

  Widget _buildListSelectedItem(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          widget.items.add(widget.selectedItems[index]);
          widget.selectedItems.removeAt(index);
        });
      },
      title: Text(widget.selectedItems[index].name,
          style: const TextStyle(fontSize: 24)),
    );
  }
}