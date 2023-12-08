import 'package:flutter/material.dart';
import 'package:task_sheet_wiederholung/NameAgeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Age Estimation',
      home: NameAgeScreen(),
    );
  }
}
