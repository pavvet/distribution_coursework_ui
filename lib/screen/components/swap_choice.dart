import 'package:distribution_coursework/model/coursework.dart';
import 'package:distribution_coursework/model/preference.dart';
import 'package:flutter/material.dart';

class SwapChoiceWidget extends StatefulWidget {
  List<Coursework> items = List.empty(growable: true);
  List<Coursework> selectedItems = List.empty(growable: true);
  List<Coursework> unselectedItems = List.empty(growable: true);

  SwapChoiceWidget(
      {Key key, this.items, this.selectedItems, this.unselectedItems})
      : super(key: key);

  @override
  _SwapChoiceState createState() => _SwapChoiceState();
}

class _SwapChoiceState extends State<SwapChoiceWidget> {
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
                const Text("Не хочу заниматься"),
                Expanded(
                  child: ListView.builder(
                    controller: ScrollController(),
                    itemCount: widget.unselectedItems.length,
                    itemBuilder: _buildListUnselectedItem,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
              thickness: 1, color: Colors.black, indent: 0, endIndent: 0),
          Expanded(
            child: Column(
              children: [
                const Text("Могу заниматься"),
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
              thickness: 1, color: Colors.black, indent: 0, endIndent: 0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Хочу заниматься"),
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

  Widget _buildListUnselectedItem(BuildContext context, int index) {
    return ListTile(
      onTap: () {
        setState(() {
          widget.items.add(widget.unselectedItems[index]);
          widget.unselectedItems.removeAt(index);
        });
      },
      title: Text(widget.unselectedItems[index].name,
          style: const TextStyle(fontSize: 24)),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    String name = widget.items[index].name;
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          setState(() {
            widget.selectedItems.add(widget.items[index]);
            widget.items.removeAt(index);
          });
        } else {
          setState(() {
            widget.unselectedItems.add(widget.items[index]);
            widget.items.removeAt(index);
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
        child: const Icon(Icons.delete),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            widget.selectedItems.add(widget.items[index]);
            widget.items.removeAt(index);
          });
        },
        title: Text(widget.items[index].name,
            style: const TextStyle(fontSize: 24)),
      ),
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
