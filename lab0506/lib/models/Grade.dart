// Grade class used throughout the app
class Grade {
  final int id;
  final String sid;
  final String grade;
  final String classValue; // New property

  Grade({
    required this.id,
    required this.sid,
    required this.grade,
    required this.classValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sid': sid,
      'grade': grade,
      'classValue': classValue,
    };
  }
}