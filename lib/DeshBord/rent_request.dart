import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transpo/utils/color.dart';

import '../utils/bick_constants.dart';

class RReshbord extends StatefulWidget {
  const RReshbord({super.key});

  @override
  State<RReshbord> createState() => _RReshbordState();
}

bool request = false;

class _RReshbordState extends State<RReshbord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
     backgroundColor: mPrimaryColor,
      appBar: buildAppBar(),
      
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Rent ride rq")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snap.length,
                          itemBuilder: (context, Index) {
                            return Container(
                              height: 400,
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                  color: AppColors.b,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(2, 2),
                                      blurRadius: 10,
                                    )
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   SizedBox(
                                    height: 10,
                                  ),
                                   Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'name: ${snap[Index]['name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                   Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'number: ${snap[Index]['number']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Bick Name: ${snap[Index]['bick name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'payment: \u{20B9}${snap[Index]['payment']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'person to deliver address: ${snap[Index]['person to deliver address']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'pick up date: ${snap[Index]['pick up date']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'drop date: ${snap[Index]['drop date']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'pick up time: ${snap[Index]['pick up time']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'drop off time: ${snap[Index]['drop off time ']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: InkWell(
                                         onTap: () {
                                          request = true;
                                          setState(() {
                                            if (request == true) {
                                              print('request accept');
                                            } else {
                                  
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color:  AppColors.g ,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Center(
                                            child: Text( 'Accept'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    } else {
                      return const SizedBox();
                    }
                  })
            ],
          )),
        ),
      ),
    );
  }
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: mPrimaryColor,
      elevation: 0,
      title: Text('Rent Ride Request'),
     
    );
  }
}
