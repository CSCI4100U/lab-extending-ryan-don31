import 'package:flutter/material.dart';

// Dropdown menu from the appbar to pick which method to sort
// User can decide between sid or grade
// Clicking an option sorts it ascending, clicking again sorts it descending

class SortButton extends StatelessWidget {
  final Function(String) onSortSelected;

  const SortButton({Key? key, required this.onSortSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PopupMenuButton<String>(
          onSelected: (String value) {
            // Handle the selection here
            onSortSelected(value);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'sid',
              child: Text('Sort by: SID'),
            ),
            PopupMenuItem<String>(
              value: 'grade',
              child: Text('Sort by: Grade'),
            ),
          ],
        ),
      ],
    );
  }
}