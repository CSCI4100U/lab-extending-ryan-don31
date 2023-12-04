import 'package:flutter/material.dart';
import 'package:lab0506/models/Grade.dart';

// Screen for the gradeform, relatively unchanged from lab instructions
// I added a class value for my lab extension

class GradeForm extends StatefulWidget {
  final Grade data;
  final int? id;
  final Function(Map<String, dynamic>) onFormSubmitted;

  GradeForm({required this.data, this.id, required this.onFormSubmitted});

  @override
  State<GradeForm> createState() => _GradeFormState();
}

class _GradeFormState extends State<GradeForm> {
  TextEditingController _sidController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  int? _id;

  void returnToPreviousPage() {
    Map<String, dynamic> formData = {
      'sid': _sidController.text,
      'grade': _gradeController.text,
      'id': _id, // Pass the id back
      'class': _classController.text,
    };
    widget.onFormSubmitted(formData);
    Navigator.pop(context, formData);
  }

  @override
  void initState() {
    super.initState();
    _sidController.text = widget.data.sid;
    _gradeController.text = widget.data.grade;
    _classController.text = widget.data.classValue;
    _id = widget.id;
  }

  @override
  void didUpdateWidget(covariant GradeForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sidController.text = widget.data.sid;
    _gradeController.text = widget.data.grade;
    _classController.text = widget.data.classValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Grade'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text('SID:',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
                SizedBox(width: 30),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _sidController,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Grade:',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
                SizedBox(width: 30),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _gradeController,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Class:',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
                SizedBox(width: 30),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _classController,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: returnToPreviousPage,
        child: Icon(Icons.save),
      ),
    );
  }
}