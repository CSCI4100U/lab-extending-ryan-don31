import 'package:flutter/material.dart';
import 'package:lab0506/screens/ListGrades.dart';
import 'package:lab0506/screens/GradeForm.dart';
import 'package:lab0506/models/GradesModel.dart';
import 'package:lab0506/models/Grade.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab0506',
      home: ListGrades(title: 'Lab 05 - 06'),
      routes: <String, WidgetBuilder>{
        '/GradeForm': (BuildContext context) => GradeForm(
              data: Grade(id: 0, sid: '', grade: '', classValue: ''),
              onFormSubmitted: (Map<String, dynamic> mainMap) {
                GradesModel.insertGrade(Grade(
                    id: mainMap['id'],
                    sid: mainMap['sid'],
                    grade: mainMap['grade'],
                    classValue: mainMap['classValue']));
              },
            )
      },
    );
  }
}
