
import 'package:flutter/material.dart';
import 'package:transpo/model/bick.dart';

import '../utils/bick_constants.dart';
import 'bick_attribute.dart';

class bickInfomation extends StatelessWidget {
  const bickInfomation({
     Key? key,
    required this.bicks,
  }) : super(key: key);

  final bick bicks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 24, right: 24,top: 50),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u{20B9}${bicks.price}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'price/hr',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Attribute(
                value: bicks.brand,
                name: 'Brand',
              ),
              Attribute(
                value: bicks.model,
                name: 'Speed',
              ),
              Attribute(
                value: bicks.co2,
                name: 'Engine Displ.',
              ),
              Attribute(
                value: bicks.fuelCons,
                name: 'Fuel Type',
              ),
            ],
          )
        ],
      ),
    );
  }
}