// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:transpo/utils/bick_constants.dart';
import 'package:transpo/widgets/bick_list_item.dart';

import '../model/bick.dart';
import '../utils/color.dart';

class RentBick extends StatelessWidget {
  const RentBick({
    Key? key,
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mPrimaryColor,
      appBar: buildAppBar(),
      body: ListView.builder(
          itemCount: bickList.length,
          itemBuilder: (context, index) => CarListItem(index)),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: mPrimaryColor,
      elevation: 0,
      title: Text('Available Bicks'),
      actions: [
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
