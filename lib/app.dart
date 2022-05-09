import 'package:distribution_coursework/provider/coursework_provider.dart';
import 'package:distribution_coursework/provider/distribution_provider.dart';
import 'package:distribution_coursework/provider/preference_provider.dart';
import 'package:distribution_coursework/provider/student_provider.dart';
import 'package:distribution_coursework/provider/teacher_provider.dart';
import 'package:distribution_coursework/screen/authorization_page.dart';
import 'package:distribution_coursework/screen/student_page.dart';
import 'package:distribution_coursework/screen/teacher_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/settings_provider.dart';
import 'screen/distribution_page.dart';
import 'screen/register_page.dart';

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

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
        ChangeNotifierProvider<PreferenceProvider>(
            create: (context) => PreferenceProvider()),
        ChangeNotifierProvider<CourseworkProvider>(
            create: (context) => CourseworkProvider()),
        ChangeNotifierProvider<DistributionProvider>(
            create: (context) => DistributionProvider()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            buttonTheme: const ButtonThemeData(
              buttonColor: Colors.blue,
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          initialRoute: "/auth",
          routes: {
            "/auth": (context) => const AuthorizationPage(),
            "/register": (context) => const RegisterPage(),
            "/student": (context) => const StudentPage(),
            "/teacher": (context) => const TeacherPage(),
            "/distribution": (context) => const DistributionPage(),
          }),
    );
  }
}
