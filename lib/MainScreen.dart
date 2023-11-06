import 'package:appoflutter/AddLocation.dart';
import 'package:appoflutter/Widgets/JobsWidgets.dart';
import 'package:appoflutter/Widgets/TopSide.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'Widgets/ProfileButton.dart';
import 'dart:math';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  bool showSpinner = false;
  final _firestore = FirebaseFirestore.instance;
  double smallestOne = 0;
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  double checkNumber = 0;
  int availableNumber = 0;
  final jobList = [
    ['0','0','Barber','Hairdresser','images/barberpng.png'],
    ['0','0','Doctor','Medicine','images/dentistback.png'],
    ['0','0','Dietitian','Hairdresser','images/dietitianback.png'],
    ['0','0','Esthetician','Hairdresser','images/estheticianback.png'],
    ['0','0','HairDresser','Hairdresser','images/hairdresserback.png'],
    ['0','0','Lawyer','Hairdresser','images/lawyerback.png'],
    ['0','0','Repairman','Hairdresser','images/repairmanback.png'],
    ['0','0','Teacher','Hairdresser','images/teacherback.png'],
    ['0','0','Veterinarian','Hairdresser','images/veterinarianback.png'],
    ['0','0','Psychologist','Hairdresser','images/psychologist.png'],];

  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    // Convert degrees to radians
    lat1 = lat1 * pi / 180;
    lon1 = lon1 * pi / 180;
    lat2 = lat2 * pi / 180;
    lon2 = lon2 * pi / 180;

    // Haversine formula
    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;
    double a = pow(sin(dlat / 2), 2) +
        cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    double c = 2 * asin(sqrt(a));

    // Radius of the Earth in kilometers
    const R = 6371.0;

    // Calculate the distance
    double distance = R * c;
    return distance;
  }

  void getTheLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  void getTheData(String collectionName, int whichOne) async {
    smallestOne = 0;
    availableNumber = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionName).get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['latitude'] != null && data['longitude'] != null) {
        checkNumber = haversineDistance(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble(), data['latitude'], data['longitude']);
        if(smallestOne == 0){
          smallestOne = haversineDistance(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble(), data['latitude'], data['longitude']);
        }else if(checkNumber < smallestOne){
          smallestOne = checkNumber;
        }
      }
      availableNumber++;
    }
    setState(() {
      jobList[whichOne][0] = smallestOne.round().toString();
      jobList[whichOne][1] = availableNumber.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getTheLocation();
    for(int i = 0;i < jobList.length;i++){
      getTheData(jobList[i][2],i);
    }
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    final currentHeight = MediaQuery.of(context).size.height.round();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFEAFDFC),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 8,),
              TopSide(),
              Container(height: 10,),
              Container(
                width: 260,
                height: 55,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 2, // Blur radius
                        offset: Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      width: 150,
                      child: TextField(
                        onChanged: (text) {

                        },
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                          hintStyle: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Mr. Rockwell',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      left: 200,
                        child: Image.asset("images/searchicon.png")
                    ),
                  ]
                ),
              ),
              Container(height: 15,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50)
                ),
                height: 700,
                child: ListView.builder(
                    itemCount: jobList.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Center(
                          child: JobsWidgets(distance: jobList[index][0],money: "50-300",available: jobList[index][1], jobName: jobList[index][2], jobDescription: jobList[index][3], imageLoc: jobList[index][4],),
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}