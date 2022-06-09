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
  static const _bluePrimaryValue = -14137996;
  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(-14137996),
      100: Color(-14137996),
      200: Color(-14137996),
      300: Color(-14137996),
      400: Color(-14137996),
      500: Color(_bluePrimaryValue),
      600: Color(-14137996),
      700: Color(-14137996),
      800: Color(-14137996),
      900: Color(-14137996),
    },
  );

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
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: blue,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                textStyle:
                    MaterialStateProperty.all(const TextStyle(fontSize: 17)),
                minimumSize: MaterialStateProperty.all(const Size(100, 45)),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black26;
                    }
                    return const Color(-14137996);
                  },
                ),
              ),
            ),
            buttonTheme: const ButtonThemeData(
              buttonColor: Colors.red,
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