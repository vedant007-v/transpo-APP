import 'package:flutter/material.dart';
import 'package:transpo/utils/color.dart';


class Timespan extends StatefulWidget {
  const Timespan({super.key, required this.selectedtime, required this.onSelect});
  final String selectedtime;
    final Function onSelect;

  @override
  State<Timespan> createState() => _TimespanState();
}

class _TimespanState extends State<Timespan> {
  List<String> locations = [
    '0 Min',
    '15 Min',
    '30 Min',
    '60 Min',
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children:   [

          Text('What Service Location you want to register?',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),),

          SizedBox(height: 10,),

          Expanded(
            child: ListView.builder(itemBuilder: (ctx,i){
              return ListTile(
                onTap: ()=> widget.onSelect(locations[i]),
                visualDensity: VisualDensity(vertical: -4),
                title: Text(locations[i]),
                trailing: widget.selectedtime == locations[i]?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: AppColors.g,
                    child: Icon(Icons.check,color: Colors.white,size: 15,),
                  ),
                ): SizedBox.shrink(),
              );
            },itemCount: locations.length),
          ),

      ],
    );
  }
}