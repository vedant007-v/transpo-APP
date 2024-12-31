import 'package:flutter/material.dart';

import '../../../../utils/color.dart';

class VehicalHave extends StatefulWidget {
  const VehicalHave({Key? key,required this.onSelect,required this.selectedVehicalHave}) : super(key: key);

   final String selectedVehicalHave;
  final Function onSelect;

  @override
  State<VehicalHave> createState() => _VehicalHaveState();
}

class _VehicalHaveState extends State<VehicalHave> {
 
 List<String> vehicalHave = ['Yes', 'no', ];
  @override
  Widget build(BuildContext context) {
    return Column(
       children: [
        Text(
          'You have vehicle as drive?',
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
                  onTap: () => widget.onSelect(vehicalHave[i]),
                  visualDensity: VisualDensity(vertical: -4),
                  title: Text(vehicalHave[i]),
                  trailing: widget.selectedVehicalHave == vehicalHave[i]
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
              itemCount: vehicalHave.length),
        ),
      ],
    );
  }
}