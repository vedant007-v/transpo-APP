

import 'package:flutter/material.dart';
import 'package:transpo/Home_page.dart';

class _RadioBottomSheetState extends State<home> {
  int selectedValue = 0;
  
  final List<String> options = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Adjust the height as needed
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (BuildContext context, int index) {
          return RadioListTile(
            title: Text(options[index]),
            value: index,
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
              });
            },
          );
        },
      ),
    );
  }
}
