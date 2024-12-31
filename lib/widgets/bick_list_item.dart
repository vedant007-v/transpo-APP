import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transpo/Screen/Rent_bick_register.dart';
import 'package:transpo/model/bick.dart';
import 'package:transpo/widgets/bick_info.dart';

import '../utils/bick_constants.dart';

class CarListItem extends StatelessWidget {
  const CarListItem(
    this.index, {
    Key? key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    bick car = bickList[index];
    return GestureDetector(
      onTap: () {
        Get.to(Rentrideregister(bicks: car,));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            bickInfomation(bicks: car),
            Positioned(
              right: 40,
              child: ClipRRect(
                 borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  car.image,
                  height: 110,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
