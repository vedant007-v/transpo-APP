import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transpo/utils/color.dart';

import '../utils/bick_constants.dart';

class GDeshbord extends StatefulWidget {
  const GDeshbord({super.key});

  @override
  State<GDeshbord> createState() => _GDeshbordState();
}

bool request = false;

class _GDeshbordState extends State<GDeshbord> {
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
                      .collection("Grow Business_request")
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
                              height: 250,
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
                                      'Business name: ${snap[Index]['Bname']}',
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
                                      'Business Phone number: ${snap[Index]['Bnumber']}',
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
                                      'Business Email: ${snap[Index]['BEmail']}',
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
                                      'Business Activity: ${snap[Index]['BActivity']}',
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
                                      'Ride Activity: ${snap[Index]['RideActivity']}',
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
                                            color: AppColors.g ,
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
      title: Text('Grow Business Request'),
     
    );
  }
}
