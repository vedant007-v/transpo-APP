import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transpo/widgets/text_widget.dart';
import 'package:transpo/Home_page.dart';

class RadioBottomSheet extends StatefulWidget {
  @override
  _RadioBottomSheetState createState() => _RadioBottomSheetState();
}

class _RadioBottomSheetState extends State<RadioBottomSheet> {
  String selectedValue = "";

  final List<String> options = ['0 Min', '15 Min', '30 Min', '60 Min'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
              text: 'Select an option:',
              fontSize: 18,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile<String>(
                  title: Text(options[index]),
                  value: options[index],
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                );
              },
            ),
            Center(
              child:InkWell(
                                onTap: () async {
                                    Navigator.of(context).pop(selectedValue);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: Get.width,
                                    height: 50,
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.10),
                                          spreadRadius: 5,
                                          blurRadius: 3,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Let's Go"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
            ),
          ],
        ),
      ),
    );
  }
}
