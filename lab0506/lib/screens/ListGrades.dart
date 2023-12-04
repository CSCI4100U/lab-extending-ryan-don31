import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lab0506/models/Grade.dart';
import 'package:lab0506/models/GradesModel.dart';
import 'package:lab0506/screens/GradeForm.dart';
import 'package:lab0506/utils/CsvHandler.dart';
import 'package:lab0506/screens/ChartScreen.dart';
import 'package:lab0506/components/SortButton.dart';
import 'package:lab0506/utils/compareGrades.dart';

class ListGrades extends StatefulWidget {
  const ListGrades({super.key, required this.title});

  final String title; //title of the screen

  @override
  State<ListGrades> createState() => _ListGradesState();
}

class _ListGradesState extends State<ListGrades> {
  List<Grade> grades = []; // holds grades retrieved from the database
  List<String> classes = []; // holds unique class values from database
  Grade? _selectedGrade; // holds currently selected grade
  int idGen = 0; // id key generator for newly entered grades to the db

  // values used by sorting handler (see below)
  bool _sortAscending = true;
  String _sortField = 'sid';

  @override
  void initState() {
    super.initState(); // inheriting initstate method from 'state' class (basically comes with flutter)
    _loadGrades(); // Load grades when the widget is initialized
  }

  // Updates grades list from db
  void _loadGrades() async {
    _loadClasses();
    List<Grade> loadedGrades = await GradesModel.getAllGrades();
    setState(() {
      //calling setState() here makes sure the UI gets updated
      grades = loadedGrades;
    });
  }

  // Updates class list from db (gets UNIQUE VALUES ONLY)
  void _loadClasses() async {
    List<Grade> loadedGrades = await GradesModel.getAllGrades();
    Set<String> uniqueClasses =
    loadedGrades.map((grade) => grade.classValue).toSet();
    setState(() {
      classes = uniqueClasses.toList();
    });
  }

  // Opens empty gradeform, adds form data to db
  void _addGrade() async {
    Map<String, dynamic> result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradeForm(
          data: Grade(id: 0, sid: '', grade: '', classValue: ''),
          onFormSubmitted: (formData) {
            GradesModel.insertGrade(Grade(
                id: idGen,
                sid: formData['sid'],
                grade: formData['grade'],
                classValue: formData['class']));
            idGen += 1;
          },
        ),
      ),
    );

    if (result != null) {
      String newSid = result['sid']!;
      String newGrade = result['grade']!;
    }

    _loadGrades();
  }

  // Opens gradeform with existing grade object, updates entry in db
  void _editGrade() async {
    Map<String, dynamic>? formData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradeForm(
          data: Grade(
            id: 0, //generate automatically
            sid: _selectedGrade?.sid ?? '',
            grade: _selectedGrade?.grade ?? '',
            classValue: _selectedGrade?.classValue ?? '',
          ),
          id: _selectedGrade?.id, // Pass the id to GradeForm
          onFormSubmitted: (formData) async {
            if (_selectedGrade != null) {
              await GradesModel.updateGrade(Grade(
                id: _selectedGrade!.id,
                sid: formData['sid'],
                grade: formData['grade'],
                classValue: formData['class'],
              ));
              _loadGrades();
            }
          },
        ),
      ),
    );

    if (formData != null) {
      Grade result = Grade(
        id: _selectedGrade!.id,
        sid: formData['sid'],
        grade: formData['grade'],
        classValue: formData['class'],
      );

      int index = grades.indexWhere((grade) => grade.id == _selectedGrade?.id);

      if (index != -1) {
        setState(() {
          grades[index] = result;
        });
      }
    }
  }

  // Removes grade from db at index, then removes from grades list
  void _deleteGrade(int index) async {
    if (grades[index].id != null) {
      await GradesModel.deleteGradeById(grades[index].id);
      setState(() {
        grades.removeAt(index);
      });
    }
  }

  // Sorting handler (2 functions):

  // Takes 'sid' or 'grade' as input, changes sort type or toggles asc/desc sort
  void _changeSort(field) {
    if (_sortField == field) {
      _sortAscending = !_sortAscending; // Toggle ascending/descending
    } else {
      _sortField = field;
      _sortAscending = true; // Default to ascending when field changes
    }
    _sortGrades();
  }

  // Handles sorting for sid or grade (these get sorted differently)
  void _sortGrades() {
    if (_sortField == 'sid') {
      grades.sort((a, b) =>
      _sortAscending ? a.sid.compareTo(b.sid) : b.sid.compareTo(a.sid));
    } else if (_sortField == 'grade') {
      grades.sort((a, b) => _sortAscending
          ? compareGrades(a.grade, b.grade)
          : compareGrades(b.grade, a.grade));
    }
    setState(() {});
  }

  // Calls filepicker, inputs results into db
  void _importCsv() async {
    File? csvFile = await pickCsvFile();
    if (csvFile != null) {
      List<List<dynamic>> csvData = await readCsv(csvFile);
      await GradesModel.insertGradesFromCsv(csvData);
      _loadGrades(); // Refresh the grades list
    }
  }

  // Exports grades list data as csv file to device
  Future<void> exportToCsv(List<Grade> grades) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw FileSystemException("Unable to access directory");
      }

      File file = File('${directory.path}/grades_export.csv');

      List<List<dynamic>> csvData = [
        ['ID', 'SID', 'Grade', 'ClassValue']
      ];

      for (var grade in grades) {
        csvData.add([grade.id, grade.sid, grade.grade, grade.classValue]);
      }

      String csvString = const ListToCsvConverter().convert(csvData);

      await file.writeAsString(csvString);

      print('Data exported to ${file.path}');
      _exportPopup(context, file.path);
    } catch (e) {
      // Handle errors
      print('Error exporting data: $e');
    }

  }

  // Callback function for exportToCsv
  void exportData() async{
    await exportToCsv(grades);
  }

  // Opens ChartScreen with data
  // (I know this isn't necessary as a function, but you'll see there's much better readability
  // in the spot it gets called)
  void _showBarChart() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChartScreen(grades: grades)));
  }

  // Simple popup shown when exporting CSV
  Future<void> _exportPopup(BuildContext context, String path) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exported'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Exported file to ${path}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Popup shown when user goes to edit a grade
  Future<void> _editScreenPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Edit grade for ${_selectedGrade?.sid}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _editGrade();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Appbar containing menu options
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lab 05 - 06 TITLE
            Expanded(
              child: Text(widget.title),
            ),

            // EXPORTING DATA
            IconButton(
              icon: Icon(Icons.upload),
              onPressed: () => exportData(),
            ),

            // IMPORTING CSV
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _importCsv(),
            ),

            // SORT DROPDOWN MENU
            SortButton(
              onSortSelected: _changeSort,
            ),

            // SHOW BARCHART
            IconButton(
              icon: Icon(Icons.bar_chart),
              onPressed: () => _showBarChart(),
            ),
          ],
        ),
      ),

      // Main area on screen
      // For the lab extension, students are organized by class, and each is in a
      // dropdown menu that contains the name of the class their grade is for
      body: SingleChildScrollView(
          child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: classes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final classname = classes[index];
                    final classGrades = grades.where((grade) => grade.classValue == classname).toList();

                    return ExpansionTile(
                      title: Text(classname),
                      children: classGrades.map((grade) {
                        return GestureDetector(
                          child: Dismissible(
                            key: Key(grade.id.toString()), // Unique key for each item
                            background: Container(color: Colors.red),
                            onDismissed: (direction) {
                              int originalIndex = grades.indexWhere((g) => g.id == grade.id);
                              if (originalIndex != -1) {
                                _deleteGrade(originalIndex); // Use _deleteGrade function
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Grade removed')),
                                );
                              }
                            },
                            child: ListTile(
                              title: Text(grade.sid),
                              subtitle: Text(grade.grade),
                            ),
                          ),
                          onLongPress: () {
                            _selectedGrade = grade;
                            _editScreenPopup(context);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ]
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGrade,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}