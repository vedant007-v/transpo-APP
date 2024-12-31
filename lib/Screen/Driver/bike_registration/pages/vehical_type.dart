import 'package:flutter/material.dart';

import '../../../../utils/color.dart';

class VehicalType extends StatefulWidget {
  VehicalType({Key? key, required this.onSelect, required this.selectedVehical})
      : super(key: key);

  final String selectedVehical;
  final Function onSelect;

  @override
  State<VehicalType> createState() => _VehicalTypeState();
}

class _VehicalTypeState extends State<VehicalType> {
  List<String> vehicalType = ['Economy', 'Business', 'Middle'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'What type of vehicle is it?',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemBuilder: (ctx, i) {
                return ListTile(
                  onTap: () => widget.onSelect(vehicalType[i]),
                  visualDensity: VisualDensity(vertical: -4),
                  title: Text(vehicalType[i]),
                  trailing: widget.selectedVehical == vehicalType[i]
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.g,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                );
              },
              itemCount: vehicalType.length),
        ),
      ],
    );
  }
}
