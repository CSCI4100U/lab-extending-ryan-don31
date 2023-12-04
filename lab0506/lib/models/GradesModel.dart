import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:lab0506/models/Grade.dart';

// SQLite database used throughout the app
class GradesModel {
  static Future<Database> database() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'gradesdatabase.db'),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE grades(id INTEGER PRIMARY KEY, sid TEXT, grade TEXT, classValue TEXT)");
      },
      version: 1,
    );
  }

  static Future<List<Grade>> getAllGrades() async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.query('grades');
    return List.generate(maps.length, (i) {
      return Grade(
        id: maps[i]['id'],
        sid: maps[i]['sid'],
        grade: maps[i]['grade'],
        classValue: maps[i]['classValue'],
      );
    });
  }

  static Future<List<Grade>> getAllGradesByClass(String className) async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db
        .query('grades', where: 'classValue = ?', whereArgs: [className]);
    return List.generate(maps.length, (i) {
      return Grade(
        id: maps[i]['id'],
        sid: maps[i]['sid'],
        grade: maps[i]['grade'],
        classValue: maps[i]['classValue'], // Added classValue
      );
    });
  }

  static Future<void> insertGradesFromCsv(List<List<dynamic>> csvData) async {
    final Database db = await database();
    print("CSV DATA: ${csvData}");
    for (var row in csvData) {
      // Assuming the CSV format is: [id, sid, grade]
      Grade grade = Grade(
          id: row[0],
          sid: row[1].toString(),
          grade: row[2].toString(),
          classValue: row[3].toString());
      await db.insert('grades', grade.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<int> insertGrade(Grade grade) async {
    final Database db = await database();
    return await db.insert('grades', grade.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateGrade(Grade grade) async {
    final Database db = await database();
    await db.update(
      'grades',
      grade.toMap(),
      where: 'id = ?',
      whereArgs: [grade.id],
    );
  }

  static Future<void> deleteGradeById(int id) async {
    final Database db = await database();
    await db.delete(
      'grades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}