import 'package:flutter/material.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/services/authServices.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: Constants.BUTTON_BG,
            primaryColor: Constants.BUTTON_TXT),
        debugShowCheckedModeBanner: false,
        home: AuthService().handleAuth());
  }
}
