import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:lab0506/models/Grade.dart';
import 'package:lab0506/utils/compareGrades.dart';

// Part of the lab extending, shows DataTable with a subsequent barchart underneath

class ChartScreen extends StatefulWidget {
  List<Grade> grades;

  ChartScreen({super.key, required this.grades});

  @override
  State<ChartScreen> createState() => _ChartScreenState(grades: grades);
}

class _ChartScreenState extends State<ChartScreen> {
  List<Grade> grades;
  Map<String, int> gradeFrequency = {}; // dict to hold grades information

  _ChartScreenState({required this.grades});

  @override
  void initState() {
    super.initState();
    _calculateGradeFrequency();
  }

  // Function to get frequency of each grade occurrence
  void _calculateGradeFrequency() {
    gradeFrequency.clear();

    for (var grade in grades) {
      gradeFrequency[grade.grade] = (gradeFrequency[grade.grade] ?? 0) + 1;
    }

    setState(() {
      _sortGradeFrequency();
    });
  }

  // Sorts each letter grades
  void _sortGradeFrequency() {
    gradeFrequency = Map.fromEntries(gradeFrequency.entries.toList()
      ..sort((a, b) => compareGrades(
          a.key, b.key)) // Sort entries by custom grade comparison
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create a list of series for the chart using the calculated frequency
    var series = [
      charts.Series<MapEntry<String, int>, String>(
        id: 'Grades',
        data: gradeFrequency.entries.toList(),
        domainFn: (entry, _) => entry.key,
        measureFn: (entry, _) => entry.value,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chart Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 400,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              //height: 300,
              child: DataTable(
                  columns: [
                    DataColumn(label: Text("SID")),
                    DataColumn(label: Text("Grade")),
                  ],
                  rows: grades.map((grade) {
                    return DataRow(cells: [
                      DataCell(Text(grade.sid)),
                      DataCell(Text(grade.grade)),
                    ]);
                  }).toList()),
            ),
          ),
          Container(
            height: 300,
            padding: EdgeInsets.all(16),
            child: charts.BarChart(
              series,
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}