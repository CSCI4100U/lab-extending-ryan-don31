//sorts grades ASCENDING order
int compareGrades(String grade1, String grade2) {
  // Helper function to compare grades including + or -
  if (grade1 == grade2) {
    return 0; // Same grade
  }

  // Extract the base grade without + or -
  String baseGrade(String grade) {
    return grade.replaceAll(RegExp(r'[+-]'), '');
  }

  // Compare base grades
  var result = baseGrade(grade1).compareTo(baseGrade(grade2));
  if (result != 0) {
    return result * -1; // If base grades are different, return the comparison
  }

  // If base grades are the same, compare the modifiers (+ or -)
  if (grade1.contains('+')) {
    return 1; // grade1 is greater if it has a +
  } else if (grade2.contains('+')) {
    return -1; // grade2 is greater if it has a +
  }

  // If no modifiers, compare as equal
  return 0;
}