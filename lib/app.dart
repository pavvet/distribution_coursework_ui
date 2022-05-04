import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:distribution_coursework/screen/student_page.dart';
import 'package:distribution_coursework/screen/teacher_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider<TeacherProvider>(
            create: (context) => TeacherProvider()),
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
            "/student": (context) => const StudentPage(),
            "/teacher": (context) => const TeacherPage(),
          }),
    );
  }
}
