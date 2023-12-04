import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';

// Functions used to import csv files

Future<File?> pickCsvFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  if (result != null) {
    return File(result.files.single.path!);
  } else {
    return null;
  }
}

Future<List<List<dynamic>>> readCsv(File file) async {
  final input = await file.readAsString();
  final fields = const CsvToListConverter().convert(input);
  return fields;
}