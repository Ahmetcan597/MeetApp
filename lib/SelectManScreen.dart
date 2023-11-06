import 'package:appoflutter/BusinessScreen.dart';
import 'package:appoflutter/MainScreen.dart';
import 'package:appoflutter/Widgets/BackIcon.dart';
import 'package:appoflutter/Widgets/HumansWidget.dart';
import 'package:appoflutter/Widgets/ProfileButton.dart';
import 'package:appoflutter/Widgets/TextFieldContainer.dart';
import 'package:appoflutter/Widgets/TopSide.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:carousel_slider/carousel_slider.dart';


const List<String> list = <String>['Nearest'];

class SelectManScreen extends StatefulWidget {
  const SelectManScreen({Key? key, required this.whichJob}) : super(key: key);

  final String whichJob;

  @override
  State<SelectManScreen> createState() => _SelectManScreenState();
}

class _SelectManScreenState extends State<SelectManScreen> {

  String dropdownValue = list.first;
  late String name;
  late String min;
  late String max;
  late String locationMax;
  bool showSpinner = false;
  final humanList = [
    ['0','0','Barber','Hairdresser','images/barberpng.png'],];


  //calisanlarin verilerini cekip siralamada kaldik
  //5 tane getiricek her calistiginda bunu bir listeye eklicek ve sergilicek simdi soyle olsun
  //ve en son getirdiginin konum uzakligini belirleyip bundan sonra getiricekleri bu konumdan bir tik uzaga gore getiricek

  // void getTheData(String collectionName) async {
  //   smallestOne = 0;
  //   availableNumber = 0;
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionName).get();
  //   for (var doc in querySnapshot.docs) {
  //     Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  //     if (data != null && data['latitude'] != null && data['longitude'] != null) {
  //       checkNumber = haversineDistance(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble(), data['latitude'], data['longitude']);
  //       if(smallestOne == 0){
  //         smallestOne = haversineDistance(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble(), data['latitude'], data['longitude']);
  //       }else if(checkNumber < smallestOne){
  //         smallestOne = checkNumber;
  //       }
  //     }
  //     availableNumber++;
  //   }
  //   setState(() {
  //     jobList[whichOne][0] = smallestOne.round().toString();
  //     jobList[whichOne][1] = availableNumber.toString();
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    final currentHeight = MediaQuery.of(context).size.height.round();

    return MaterialApp(
      home: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: const Color(0xFFEAFDFC),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 8,),
                TopSide(),
                TextFieldContainer(currentWidth: 260,currentHeight: currentHeight / 15.7,hintText: "Name",hintSize: currentHeight / 30.4,textSize: currentHeight / 40.4,onTextChanged: (text){name = text;},),
                Container(height: 15,),
                Row(
                  children: [
                    Container(width: 7,),
                    Image.asset("images/pricetagicon.png",width: 20,),
                    Container(width: 8,),
                    TextFieldContainer(currentWidth: 100,currentHeight: currentHeight / 20.4,hintText: "Min",hintSize: currentHeight / 40.4,textSize: currentHeight / 40.4,onTextChanged: (text){min = text;},),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.asset("images/minusicon.png",),
                    ),
                    TextFieldContainer(currentWidth: 100,currentHeight: currentHeight / 20.4,hintText: "Max",hintSize: currentHeight / 40.4,textSize: currentHeight / 40.4,onTextChanged: (text){max = text;},),
                    Container(width: 7,),
                    Image.asset("images/locationicon.png",width: 20,),
                    Container(width: 7,),
                    TextFieldContainer(currentWidth: 100,currentHeight: currentHeight / 20.4,hintText: "Max",hintSize: currentHeight / 40.4,textSize: currentHeight / 40.4,onTextChanged: (text){locationMax = text;},),
                  ],
                ),
                Container(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BackIcon(whichScreen: MainScreen()),
                    Text("Available ${widget.whichJob}",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                    Column(
                      children: [
                        Container(
                          width: 85,
                          height: 30,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: const Offset(0, 3),
                                )
                              ],
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left:15.0),
                            child: DropdownButton(
                              value: dropdownValue,
                              style: const TextStyle(color: Colors.black,fontSize: 12),
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              underline: Container(),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(height: 15,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  height: currentHeight / 1.78,
                  child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Center(
                            child: HumansWidget(),
                          ),
                        );
                      }
                  ),
                ),
              ],
            )
          ,),
        ),
      ),
    );
  }
}