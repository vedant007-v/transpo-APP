import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transpo/utils/color.dart';

import '../utils/bick_constants.dart';

class NDeshbord extends StatefulWidget {
  const NDeshbord({super.key});

  @override
  State<NDeshbord> createState() => _NDeshbordState();
}

bool request = false;

class _NDeshbordState extends State<NDeshbord> {
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
                      .collection("Not avali Request")
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
                              height: 350,
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
                                      'person name: ${snap[Index]['name']}',
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
                                      'person number: ${snap[Index]['number']}',
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
                                      'Not Avalible Area: ${snap[Index]['Not Avalible Area']}',
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
                                      'current locaton: ${snap[Index]['current locaton']}',
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
                                      'Destination location: ${snap[Index]['Destination location']}',
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
                                            color:AppColors.g ,
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
      title: Text('Not Available Ride Request'),
     
    );
  }
}
