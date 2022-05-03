import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'provider/settings_provider.dart';
import 'screen/register_page.dart';

class RootApp extends StatelessWidget {
  const RootApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
            create: (context) => SettingsProvider()),
        ChangeNotifierProvider<StudentProvider>(
            create: (context) => StudentProvider()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            buttonTheme: const ButtonThemeData(
              buttonColor: Colors.blue,
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => const RegisterPage(),
            "/register": (context) => const RegisterPage(),
            "/student": (context) => const RegisterPage(),
          }),
    );
  }
}
