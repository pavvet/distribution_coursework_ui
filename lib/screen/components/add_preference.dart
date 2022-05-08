import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPreferenceWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Function() onTap;

  AddPreferenceWidget({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await inputDialog(context);
      },
      child: const Text("Добавить"),
    );
  }

  Future inputDialog(BuildContext context) async {
    String preferenceName = "";
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавление предпочтений'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: 'Название предпочтения',
                  hintText: 'Программирование'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Заполните поле";
                }
                return null;
              },
              onChanged: (value) {
                preferenceName = value;
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Добавить'),
              onPressed: () async {
                try {
                  if (_formKey.currentState.validate()) {
                    await Provider.of<PreferenceProvider>(context,
                            listen: false)
                        .savePreference(preferenceName);
                    await onTap();
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Произошла ошибка")));
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
            ),
            ElevatedButton(
              child: const Text('Отмена'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
