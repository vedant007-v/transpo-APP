import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transpo/DeshBord/Grow_business.dart';
import 'package:transpo/DeshBord/Not_Avaliblerequest.dart';
import 'package:transpo/DeshBord/deshbord.dart';
import 'package:transpo/Screen/Delivery/delivery_detail.dart';
import 'package:transpo/Screen/Payment.dart';
import 'package:transpo/Screen/Rent_bick.dart';
import 'package:transpo/Screen/decision.dart';
import 'package:transpo/Screen/manager_login.dart';
import 'package:transpo/Screen/profile_screen.dart';
import 'package:transpo/api.dart';
import 'package:transpo/controller/auth_controller.dart';
import 'package:transpo/model/bick.dart';
import 'package:transpo/utils/color.dart';
import 'package:transpo/utils/utilites.dart';
import 'package:transpo/widgets/RadioBottomSheet.dart';
import 'package:transpo/widgets/bar4.dart';
import 'package:transpo/widgets/otpwidget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:transpo/widgets/text_widget.dart';
import 'package:transpo/widgets/timespan_widget.dart';

import 'Screen/Driver/Diver_profile.dart';
import 'Screen/Driver/bike_registration/pages/Location_page.dart';
import 'Screen/Driver/bike_registration/pages/vehical_type.dart';
import 'Screen/Driver/bike_registration/regis_tempeltes.dart';
import 'dart:math' show cos, sqrt, asin;

class NetworkHelper {
  NetworkHelper(
      {required this.startLng,
      required this.startLat,
      required this.endLng,
      required this.endLat});

  final String url = 'https://api.openrouteservice.org/v2/directions/';
  final String apiKey =
      '5b3ce3597851110001cf62485ac35b0a5cac4ae89175daa80db4d8a3';
  final String journeyMode =
      'driving-car'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(
        '$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));
    print(
        "$url$journeyMode?$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final auth = FirebaseAuth.instance;

  AuthController authController = Get.find<AuthController>();
  PageController pagetimeController = PageController();
  TextEditingController current_location = TextEditingController();
  TextEditingController destination_location = TextEditingController();

  MapController controller = MapController();
  String location = "";
  var lag;
  var long;
  String inputadd = '';
  String clinputadd = '';

  //AnON3Cj0hBOU0H9BuYpAUDdFQbsF_SeBKW3lVsmsfWaJ81rk6KDQGj_ikbWzeM0W
  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  GetcurrentLocation() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  get() async {
    // Position cposition = await GetcurrentLocation();
    Position position = await _determinePosition();
    controller.move(LatLng(position.latitude, position.longitude), 15.0);

    setState(() {
      lag = double.tryParse("${position.longitude}");
      long = double.tryParse("${position.latitude}");
    });
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  int selectedtimetile = 0;

  @override
  void initState() {
    _determinePosition();
    setMarker();
    GetcurrentLocation();
    Firebaseget();
    double distance;
    selectedtimetile = 0;
    // setMarker();

    super.initState();
    // getlocationstrem();
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedtimetile = val;
    });
  }

  // getlocationstrem() {
  //   StreamSubscription<Position> positionStream =
  //       Geolocator.getPositionStream(locationSettings: locationSettings)
  //           .listen((Position? cposition) {
  //     print(cposition == null
  //         ? 'Unknown'
  //         : '${cposition.latitude.toString()}, ${cposition.longitude.toString()}');
  //   });
  // }

  List<Marker> allMarker = [];

  setMarker() async {
    return allMarker;
  }

  addToList() async {
    // List<Location> locations =
    //     await locationFromAddress("Gronausestraat 710, Enschede");
    // final query = clinputadd;
    // var addresses = await Geocoder.local.findAddressesFromQuery(query);
    // var first = addresses.first;
    Position position = await _determinePosition();
    // var first = await locations.first;
    setState(() {
      allMarker.add(Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(position.latitude, position.longitude),
          builder: (context) => Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: AppColors.g,
                  iconSize: 45.0,
                  onPressed: () {},
                ),
              )));
    });
  }

  addToLis() async {
    // List<Location> locations = await locationFromAddress(
    //     "Shree Santram Samadhi Sthan - Nadiad, Kheda, Gujarat, India.");
    // Position position = await _determinePosition();
    // var first = await locations.first;
    final query = inputadd;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    setState(() {
      allMarker.add(Marker(
          width: 45.0,
          height: 45.0,
          point:
              LatLng(first.coordinates.latitude!, first.coordinates.longitude!),
          builder: (context) => Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: AppColors.g,
                  iconSize: 45.0,
                  onPressed: () {},
                ),
              )));
    });
  }

  // addRide() async {
  //   Position cposition = await getlocationstrem();
  //   // List<Location> locations = await locationFromAddress(
  //   //     "Shree Santram Samadhi Sthan - Nadiad, Kheda, Gujarat, India.");
  //   // Position position = await _determinePosition();
  //   // var first = await locations.first;
  //   final query = inputadd;
  //   var addresses = await Geocoder.local.findAddressesFromQuery(query);
  //   var first = addresses.first;
  //   setState(() {
  //     allMarker.add(Marker(
  //         width: 45.0,
  //         height: 45.0,
  //         point: LatLng(cposition.latitude, cposition.longitude),
  //         builder: (context) => Container(
  //               child: IconButton(
  //                 icon: Icon(Icons.location_on),
  //                 color: AppColors.g,
  //                 iconSize: 45.0,
  //                 onPressed: () {},
  //               ),
  //             )));
  //   });
  // }

  Future addMarker() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Add marker',
              style: TextStyle(fontSize: 17.0),
            ),
            children: <Widget>[
              TextField(
                onChanged: (String enteredloc) {
                  setState(() {
                    inputadd = enteredloc;
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'add it',
                  style: TextStyle(color: AppColors.b),
                ),
                onPressed: () {
                  addToList();
                  addToLis();
                  getJsonData();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // List listofpoints = [];
  // List<LatLng> points = [];
  // getCoordinates() async {
  //   Position position = await _determinePosition();
  //   List<Location> locations = await locationFromAddress(
  //       "Shree Santram Samadhi Sthan - Nadiad, Kheda, Gujarat, India.");
  //   var first = await locations.first;
  //   var respose = await http.get(getRouteUrl(
  //       "${position.latitude},${position.longitude}",
  //       "${locations[0].longitude},${locations[0].longitude}"));

  //   setState(() {
  //     if (respose.statusCode == 200) {
  //       var data = jsonDecode(respose.body);
  //       listofpoints = data['fratures'][0]['geometry']['coordinates'];
  //       points = listofpoints
  //           .map((e) => LatLng(e[1].toDouble(), e[0].toDouble()))
  //           .toList();
  //     }
  //   });
  // }

  double totalDistance = 0;
  int dis = 0;
  bool selectedbottomsheet = false;
  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  var data;
  // Dummy Start and Destination Points

  var points = <LatLng>[];

  void getJsonData() async {
    final query = inputadd;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    Position position = await _determinePosition();

    double startLat = position.latitude;
    double startLng = position.longitude;
    double endLat = first.coordinates.latitude!;
    double endLng = first.coordinates.longitude!;
    var pointsGradient = <LatLng>[
      LatLng(startLat, startLng),
      LatLng(endLat, endLng),
    ];

    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        print(ls);
        //print(polyPoints);
      }
    } catch (e) {
      print(e);
      //print(polyPoints);
    }
  }

  @override
  Widget build(BuildContext context) {
    String bingKey =
        'AnON3Cj0hBOU0H9BuYpAUDdFQbsF_SeBKW3lVsmsfWaJ81rk6KDQGj_ikbWzeM0W';
    return Scaffold(
      drawer: buildDrawer(),
      body: Stack(children: [
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: FlutterMap(
              mapController: controller,
              options: MapOptions(
                zoom: 9.2,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: allMarker,
                ),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                      points: polyPoints,
                      color: Colors.blue,
                      strokeWidth: 10,
                    ),
                  ],
                ),
              ],
            )),
        Positioned(
            top: 170,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 15),
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: current_location,
                      onChanged: (String clenteredloc) {
                        setState(() {
                          clinputadd = clenteredloc;
                        });
                      },
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                          hintText: 'enter current location',
                          helperStyle: TextStyle(color: Colors.black),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.location_on,
                    color: AppColors.b,
                  ),
                  tooltip: 'My location',
                  onPressed: () async {
                    get();
                    Position position = await _determinePosition();
                    final coordinates =
                        new Coordinates(position.latitude, position.longitude);
                    List addresses = await Geocoder.local
                        .findAddressesFromCoordinates(coordinates);
                    var first = addresses.first;
                    current_location.text = first
                        .addressLine!; //!+first.adminArea!+first.subLocality!+first.subAdminArea!+first.addressLine!+first.featureName!+first.thoroughfare!+first.subThoroughfare!;
                  },
                )
              ],
            )),
        Positioned(
            top: 230,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 15),
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: destination_location,
                      onChanged: (String enteredloc) {
                        setState(() {
                          inputadd = enteredloc;
                        });
                      },
                      onTap: () {},
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                          hintText: 'Search for a destination',
                          helperStyle: TextStyle(color: Colors.black),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: AppColors.b,
                  ),
                  tooltip: 'Search',
                  onPressed: () async {
                    if (selectedbottomsheet == false) {
                      Get.bottomSheet(Container(
                        width: Get.width,
                        height: Get.height * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Select Your Location",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.b,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Home Address",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.b,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FutureBuilder(
                                  future: Firebaseget(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done)
                                      return textWidget(text: 'Loading');
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          destination_location.text = ha!;
                                        },
                                        child: Container(
                                          width: Get.width,
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                spreadRadius: 3,
                                                blurRadius: 2,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Home Address",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.b,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "business Address",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.b,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FutureBuilder(
                                  future: Firebaseget(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done)
                                      return textWidget(text: 'Loading');
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          destination_location.text = ba!;
                                        },
                                        child: Container(
                                          width: Get.width,
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                spreadRadius: 3,
                                                blurRadius: 2,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Business Address",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.b,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    Get.back();
                                  });

                                  buildChooiesSheet();
                                  addToList();
                                  addToLis();
                                  getJsonData();
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
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Next'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ));
                    } else {
                      buildRideLoadingSheet();
                    }
                  },
                )
              ],
            )),
        buildProfile(),
        buildBottomsheet(),
      ]),
    );
    /*return Scaffold(
      drawer: buildDrawer(),
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: Center(
        child: Column(children: [
          FutureBuilder(
            // ignore: prefer_interpolation_to_compose_strings
            future: getBingUrlTemplate(
                'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/AerialWithLabelsOnDemand?output=json&uriScheme=https&include=ImageryProviders&key=' +
                    bingKey),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final String urlTemplate = snapshot.data;
                return /*SfMaps(
                  layers: [
                    MapTileLayer(
                      initialZoomLevel: 2,
                      initialFocalLatLng: MapLatLng(28.644800, 77.216721),
                      urlTemplate: urlTemplate,
                      zoomPanBehavior: _zoomPanBehavior,
                    ),
                  ],
                );*/
                FlutterMap(
        options: MapOptions(
        zoom: 9.2,
    ),
    children: [
        TileLayer(
           urlTemplate: urlTemplate,
           minZoom: 3,
           maxZoom: 5,
        ),
    ],
);

              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ]),
      ),
    );*/
  }

  List<dynamic> _blackList = [];

  TextEditingController _textcontroller = TextEditingController();

  Widget buildProfile() {
    return Positioned(
        top: 100,
        left: 30,
        right: 20,
        child: Container(
          width: Get.width,
          child: Row(children: [
            FutureBuilder(
                future: Firebaseget(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return textWidget(text: 'Loading');
                  return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage("$_imageUrl"),
                            fit: BoxFit.fill),
                      ));
                }),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Good Morning,  ',
                        style: TextStyle(fontSize: 14, color: AppColors.b),
                      ),
                    ])),
                    FutureBuilder(
                        future: Firebaseget(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done)
                            return textWidget(text: 'Loading');
                          return Text(
                            "$_name",
                            style: TextStyle(fontSize: 16, color: AppColors.b),
                          );
                        }),
                  ],
                ),
                Text(
                  'Whare are you going',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.b,
                  ),
                ),
              ],
            ),
          ]),
        ));
  }

  buildTextTile(context) {
    return Positioned(
        top: 170,
        left: 20,
        right: 20,
        child: Container(
          padding: EdgeInsets.only(left: 15),
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            onTap: () {
              Get.bottomSheet(Container(
                width: Get.width,
                height: Get.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color: Colors.white,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Serch for add')],
                          ),
                        ),
                      )
                    ]),
              ));
            },
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, top: 10),
                hintText: 'Search for a destination',
                helperStyle: TextStyle(color: Colors.black),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.search,
                    color: AppColors.b,
                  ),
                ),
                border: InputBorder.none),
          ),
        ));
  }

  Widget buildClocationIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 10),
        child: FloatingActionButton(
            child: Icon(
              Icons.my_location,
              color: AppColors.b,
            ),
            backgroundColor: AppColors.g,
            onPressed: () {}),
      ),
    );
  }

  Widget buildBottomsheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: Get.width * 0.8,
          height: 25,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12))),
          child: Center(
              child: Container(
            width: Get.width * 0.6,
            height: 4,
            color: Colors.black45,
          )),
        ),
      ),
    );
  }

  buildDrawerItem(
      {required String title,
      required Function onPressed,
      Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w700,
      double height = 45,
      bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        // minVerticalPadding: 0,
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
            const SizedBox(
              width: 5,
            ),
            isVisible
                ? CircleAvatar(
                    backgroundColor: AppColors.g,
                    radius: 15,
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future Firebaseget() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _name = snapshot['name'],
              _number = snapshot['shopping_addess'],
              _imageUrl = snapshot['image'],
              _ha = snapshot['home_address'],
              _ba = snapshot['business_address'],
            });
  }

  buildDrawer() {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const ProfileScreen());
              },
              child: SizedBox(
                height: 150,
                child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FutureBuilder(
                            future: Firebaseget(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done)
                                return textWidget(text: 'Loading');
                              return Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage("$_imageUrl"),
                                        fit: BoxFit.fill),
                                  ));
                            }),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Good Morning, ',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white70, fontSize: 14)),
                              FutureBuilder(
                                  future: Firebaseget(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done)
                                      return textWidget(text: 'Loading');
                                    return Text("$_name");
                                  })
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  buildDrawerItem(
                      title: 'Payment History',
                      onPressed: () {
                        Get.to(() => PaymentScreen());
                      }),
                  buildDrawerItem(
                      title: 'Rent Ride',
                      onPressed: () {
                        Get.to(() => RentBick());
                      }),
                  buildDrawerItem(
                      title: 'Deshbord',
                      onPressed: () async {
                        Get.to(() => Deshbord());
                        // SharedPreferences sp =
                        //     await SharedPreferences.getInstance();
                        // String userType = sp.getString('userType') ?? '';
                        // if (userType == 'manager') {
                        //   Get.to(() => Deshbord());
                        // } else {
                        //   Get.snackbar('your', 'Not authorized Person');
                        // }
                      }),
                  buildDrawerItem(
                      title: 'Ride History', onPressed: () {}, isVisible: true),
                  buildDrawerItem(
                      title: 'Not Avalible',
                      onPressed: () {
                        Get.to(notAvalible());
                      }),
                  buildDrawerItem(
                      title: 'Grow Business',
                      onPressed: () {
                        Get.to(GrowBusiness());
                      }),
                  buildDrawerItem(title: 'Settings', onPressed: () {}),
                  buildDrawerItem(
                      title: 'Support',
                      onPressed: () {
                        Get.to(ManagerLogin());
                      }),
                  buildDrawerItem(
                      title: 'Log Out',
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.clear();
                        Get.to(DecisionScreen());
                      }),
                ],
              ),
            ),
            Spacer(),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                children: [
                  buildDrawerItem(
                      title: 'Do more',
                      onPressed: () {},
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.15),
                      height: 20),
                  const SizedBox(
                    height: 20,
                  ),
                  buildDrawerItem(
                      title: 'Get food delivery',
                      onPressed: () {},
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.15),
                      height: 20),
                  buildDrawerItem(
                      title: 'Make money driving',
                      onPressed: () {},
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.15),
                      height: 20),
                  buildDrawerItem(
                    title: 'Rate us on store',
                    onPressed: () {
                      Get.to(const DiverProfileScreen());
                    },
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.15),
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  buildRideConfirmationSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          textWidget(
            text: 'Select an option:',
            fontSize: 18,
          ),
          const SizedBox(
            height: 20,
          ),
          buildDriversList(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: buildPaymentCardWidget()),
                MaterialButton(
                  onPressed: () async {
                    Get.back();
                    SharedPreferences rd =
                        await SharedPreferences.getInstance();
                    String requestType = rd.getString('requestType') ?? '';
                    if (requestType == 'Ride') {
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .get()
                          .then((DocumentSnapshot snapshot) => {
                                _name = snapshot['name'],
                                _number = snapshot['shopping_addess'],
                              });
                      FirebaseFirestore.instance
                          .collection('Ride_request')
                          .doc(uid)
                          .set({
                        'name': name.toString(),
                        'number': number.toString(),
                        'Current location': current_location.text,
                        'destination location': destination_location.text,
                        'request type': 'ride',
                        'Span time': time.toString(),
                        'pekage': 'Standerd',
                        'distance': totalDistance.toInt().toString(),
                        'payment': payment.toInt().toString(),
                        'card number': dropdownValue.toString(),
                      }).then((value) {});
                    } else if (requestType == 'delivery') {
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .get()
                          .then((DocumentSnapshot snapshot) => {
                                _name = snapshot['name'],
                                _number = snapshot['shopping_addess'],
                              });
                      FirebaseFirestore.instance
                          .collection('deliver_request')
                          .doc(uid)
                          .update({
                        'name': name.toString(),
                        'number': number.toString(),
                        'Current location': current_location.text,
                        'destination location': destination_location.text,
                        'request type': 'delivery',
                        'pekage': 'Standerd',
                        'distance': totalDistance.toInt().toString(),
                        'payment': payment.toString(),
                        'card number': dropdownValue.toString(),
                      }).then((value) {});
                    }
                    setState(() {
                      selectedbottomsheet = true;
                    });
                  },
                  child: textWidget(
                    text: 'Confirm',
                  ),
                  color: AppColors.g,
                  shape: StadiumBorder(),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  String? _name;

  String? get name => _name;

  String? _number;

  String? get number => _number;

  String? _imageUrl;

  String? get imageUrl => _imageUrl;

  int payment = 0;

  String? _ba;

  String? get ba => _ba;

  String? _ha;

  String? get ha => _ha;

  DeliveryFunction() {
    buildRideConfirmationSheet();
  }

  buildChooiesSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          textWidget(
            text: 'Select an option:',
            fontSize: 18,
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              setState(() {
                Get.back();
              });
              _showBottomSheet(context);
              SharedPreferences rd = await SharedPreferences.getInstance();
              rd.setString('requestType', 'Ride');

              Position position = await _determinePosition();
              final query = inputadd;
              var addresses =
                  await Geocoder.local.findAddressesFromQuery(query);
              var first = addresses.first;

              var dis;
              for (var i = 0; i < data.length - 1; i++) {
                totalDistance += calculateDistance(
                    position.latitude,
                    position.longitude,
                    first.coordinates.latitude!,
                    first.coordinates.longitude!);
              }
              dis = totalDistance.toInt();
              payment = totalDistance.toInt() * 2;
              print(totalDistance.toInt() * 2);
              print(payment);
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
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ride'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: AppColors.g,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              Position position = await _determinePosition();
              final query = inputadd;
              var addresses =
                  await Geocoder.local.findAddressesFromQuery(query);
              var first = addresses.first;

              var dis;
              for (var i = 0; i < data.length - 1; i++) {
                totalDistance += calculateDistance(
                    position.latitude,
                    position.longitude,
                    first.coordinates.latitude!,
                    first.coordinates.longitude!);
              }
              dis = totalDistance.toInt();
              payment = totalDistance.toInt() * 2;
              print(totalDistance.toInt() * 2);
              print(payment);
              Get.back();

              SharedPreferences rd = await SharedPreferences.getInstance();
              rd.setString('requestType', 'delivery');

              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SingleChildScrollView(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bar4("Delivery person detail"),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 23),
                              child: Form(
                                key: formkey,
                                child: Column(
                                  children: [
                                    TextFieldWidget(
                                        'Name',
                                        Icons.person_outline,
                                        deliverynameController,
                                        (String? input) {
                                      if (input!.isEmpty) {
                                        return 'delivery person Name is required';
                                      }
                                      if (input.length < 3) {
                                        return 'please enter a valid name!';
                                      }
                                      return null;
                                    }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFieldWidget(
                                        'Number',
                                        Icons.home_outlined,
                                        numberController, (String? input) {
                                      if (input!.isEmpty) {
                                        return 'delivery person number  is required';
                                      }
                                      return null;
                                    }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFieldWidget(
                                        'Home Address',
                                        Icons.card_travel,
                                        deliveryhomeController,
                                        (String? input) {
                                      if (input!.isEmpty) {
                                        return 'delivery  home Address is required';
                                      }
                                      return null;
                                    }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: AppColors.b,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      AppColors.g),
                                            ),
                                          )
                                        : FloatingActionButton.extended(
                                            label: Text(
                                              '      submit      ',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            onPressed: () async {
                                              if (!formkey.currentState!
                                                  .validate()) {
                                                return;
                                              }

                                              setState(() {
                                                isLoading = true;
                                              });
                                              uploadI();
                                              Get.back();
                                            },
                                            backgroundColor: AppColors.b,
                                          ),
                                    SizedBox(
                                      height: 50,
                                    )
                                    /*  FloatingActionButton(onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          uploadI();
                        })*/
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                      ],
                    );
                  });

              // addToList();
              //addToLis();
              //getJsonData();
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
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('delivery'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  TextEditingController deliverynameController = TextEditingController();
  TextEditingController deliveryhomeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  uploadI() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('deliver_request').doc(uid).set({
      'Dname': deliverynameController.text,
      'Dnumber': numberController.text,
      'Dhome_address': deliveryhomeController.text,
    }).then((value) async {
      deliverynameController.clear();
      deliveryhomeController.clear();
      numberController.clear();
      numberController.clear();

      setState(() {
        isLoading = false;
      });
      buildRideConfirmationSheet();
    });
  }

  bool top = false;
  bool isLoading = false;

  int selectedRide = 0;

  buildDriversList() {
    return Container(
      height: 100,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i, i),
            );
          },
          itemCount: 3,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

  List<String> pac = <String>[
    'Standard',
    'primiyam',
    'ordinary',
  ];

// List<package> pckagetype = [
//   package('Standard'),
//   package('premium'),
//   package('ordinary'),
//   ];

  buildDriverCard(bool selected, i) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? AppColors.g.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? AppColors.g : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Standard"),
                Text(("\u{20B9}" + totalDistance.toInt().toString()),
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.normal)),
                Text((payment.toInt().toString() + "Km"),
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset('assets/splander.png'))
        ],
      ),
    );
  }

  String dropdownValue = '**** **** **** 8789';

  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];

  buildPaymentCardWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: textWidget(text: value),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  // String? dropdowntimesapn;
  // List<String> timespan = <String>['10 min', '15 min', '30 min', '60 min'];

  // buildTimeSpanWidget() {
  //   return Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('select time Span'),
  //         SizedBox(
  //           width: 10,
  //         ),
  //         DropdownButton<String>(
  //           value: dropdowntimesapn,
  //           key: (dropdownValue != null) ? Key(dropdownValue) : UniqueKey(),
  //           icon: const Icon(Icons.keyboard_arrow_down),
  //           elevation: 16,
  //           style: const TextStyle(color: Colors.deepPurple),
  //           underline: Container(),
  //           onChanged: (String? value) {
  //             // This is called when the user selects an item.
  //             setState(() {
  //               dropdowntimesapn = value!;
  //             });
  //           },
  //           items: timespan.map<DropdownMenuItem<String>>((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: textWidget(text: value),
  //             );
  //           }).toList(),
  //         )
  //       ],
  //     ),
  //   );
  // }
  String time = '';
  void _showBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          // <-- SEE HERE
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return RadioBottomSheet();
      },
    );

    // Handle the selected value returned from the bottom sheet
    if (result != null) {
      buildRideConfirmationSheet();
      // Do something with the selected value
      time = result;
      print('Selected value: $time');
    }
  }

  buildRideLoadingSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.3,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          textWidget(
            text: 'Cencel Ride',
            fontSize: 18,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.b,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      selectedbottomsheet = false;
                      SharedPreferences rd =
                          await SharedPreferences.getInstance();
                      String requestType = rd.getString('requestType') ?? '';
                      if (requestType == 'Ride') {
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        FirebaseFirestore.instance
                            .collection('Ride_request')
                            .doc(uid)
                            .delete();
                      } else if (requestType == 'delivery') {
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        FirebaseFirestore.instance
                            .collection('deliver_request')
                            .doc(uid)
                            .delete();
                      }
                      selectedbottomsheet = false;
                      current_location.clear();
                      destination_location.clear();
                      allMarker.clear();
                      polyPoints.clear();
                      polyLines.clear();
                      markers.clear();
                      points.clear();
                      rd.clear();
                      totalDistance = 0;
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  TextFieldWidget(String title, IconData iconData,
      TextEditingController controller, Function validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.b),
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            validator: (input) => validator(input),
            controller: controller,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.b),
            decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    iconData,
                    color: AppColors.b,
                  ),
                ),
                border: InputBorder.none),
          ),
        )
      ],
    );
  }

  void setSelectedTime(String s) {}

//   Position? _currentPosition;
//   String? _currentAddress;
//   var log;
//   var late;

//   home() {
//     log = double.tryParse("${_currentPosition!.longitude}") ?? 20.771523;
//     late = double.tryParse("${_currentPosition!.latitude}") ?? 74.471078;
//   }

//   _getCurrentLocation() {
//     Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.best,
//             forceAndroidLocationManager: true)
//         .then((Position position) {
//       setState(() {
//         _currentPosition = position;
//         _getAddressFromLatLng();
//       });
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   _getAddressFromLatLng() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);

//       Placemark place = placemarks[0];

//       setState(() {
//         _currentAddress =
//             "${place.locality}, ${place.postalCode}, ${place.country}";
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
// }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}

class Cd {
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
