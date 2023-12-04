[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/61LKI4JB)
# Lab Extension
For my lab extension I decided to use lab 5-6, I will list below what I did for each extension, along with what I did for my additional custom ones.

<img src="/images/demo1.PNG" width=200px>
<img src="/images/demo2.PNG" width=200px>

### Add the ability to delete grades using the swiping gesture, then remove the delete icon from the appBar.
- Made a `dismissible` widget for each list entry
- calls `_deleteGrade` for the `onDismiss`

### Add the ability to edit grades using the long press gesture, with a popup menu, then remove the edit icon from the appBar.
- Made an `onLongPress` prop that calls a popup

### Add a single icon to the appBar that allows users to sort the grades in one of four ways (increasing/decreasing sid/grade).
- `IconButton` on the appBar to handle sorting (three dots icon)
- User can select between sorting by sid, or grade
- Selecting either option will sort ascending, selecting the same option again will toggle between ascending/descending

### Add an icon to the appBar that shows a DataTable, which generates a vertical bar chart of the grade data. The Y axis should be frequency, and the X axis should be the grade in ascending order.
- Button takes user to a seperate screen with the mentioned information

### Add an icon to the appBar that enables a user to import a .csv file from local files to populate the list of grades. The csv file should have 2 columns (sid, grade) and append all new grades to the existing list of grades.
- Made a "Plus" button on the appBar that does this

### Add two more features of your choice other than those listed here. Mention these features explicitly in your README.md.

#### Feature 1: .csv export
- Added a new button on the appBar that exports the data as a .csv file
- Output path is presented to the user as a popup

#### Feature 2: Student grading info is now categorized by class
- `Grade` entries all have a new column/value: `classValue`
- This represents which class their grade is from (English, Math, etc)
- `ListView` elements are wrapped in `ExpansionTiles`, which are expandable sections that display the class name
- Sort method now performs the sorting within each class category
