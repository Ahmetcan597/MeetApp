import 'dart:io';
import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/MainScreen.dart';
import 'package:appoflutter/Widgets/ProfileButton.dart';
import 'package:appoflutter/Widgets/TextFieldContainer.dart';
import 'package:appoflutter/Widgets/TopSide.dart';
import 'package:appoflutter/AddLocation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:file_picker/file_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';


const List<String> list = <String>['Barber', 'Repairman', 'Dentist', 'Doctor','Lawyer','Esthetician','Teacher','Dietitian','Veterinarian','Masseur/Masseuse','Hairdresser','Beauty Salon Specialist','psychologist'];
class GiveServiceScreen extends StatefulWidget {
  const GiveServiceScreen({Key? key}) : super(key: key);

  @override
  State<GiveServiceScreen> createState() => _GiveServiceScreenState();
}

class _GiveServiceScreenState extends State<GiveServiceScreen> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String dropdownValue = list.first;
  String shopName = '';
  String jobName = '';
  String description = '';
  String workingHours = '';
  String phoneNumber = '';
  String email = '';
  late User loggedInUser;
  bool showSpinner = false;
  late final user;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final ref = FirebaseStorage.instance.ref();
  List<File> files = [];
  List<String> textDataList = [];
  late var result;
  var uuid = Uuid();

  void pickMultipleFiles() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if(result != null){
      if(result.paths.length <= 5){
        setState(() {
          files = result.paths.map((path) => File(path!)).toList();
        });
      }else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Exceeded File Limit'),
              content: Text('You can select up to 5 files.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }else{

    }

  }

  void uploadFile(String jobId,List<File> images) async {
    for (var i = 0; i < images.length; i++) {
      final path = 'files/jobpictures/$dropdownValue/$jobId/${jobId + i.toString()}';
      final file = images[i];
      UploadTask uploadTask = ref.child(path).putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {

      });
    }

    setState(() {
      showSpinner = false;
    });
    showDialog(context: this.context, builder: (ctx) => AlertDialog(
      title: const Text("Process Completed"),
      actions: [
        TextButton(onPressed: ()  {
          Navigator.of(ctx).pop();
        },
            child: const Text('Ok')),
      ],
    ),
    );
    PageRouteTransition.effect = TransitionEffect.fade;
    PageRouteTransition.push(context, const EntryPoint(screen: MainScreen(),));

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFFEAFDFC),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 8,),
                TopSide(),
                Container(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFieldContainer(currentHeight: 50, hintText: "Your Shop Name", currentWidth: 270, hintSize: 18, textSize: 18, onTextChanged: (text){shopName = text;}),
                  ],
                ),
                Container(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 165,
                      height: 50,
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
                      child: Center(
                        child: DropdownButton(
                          value: dropdownValue,
                          style: const TextStyle(color: Color(0xFF707070),fontSize: 12,fontFamily: "ChalkBold"),
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
                    Text("AND",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                    TextFieldContainer(currentHeight: 50, hintText: "Your Job Name", currentWidth: 165, hintSize: 18, textSize: 18, onTextChanged: (text){jobName = text;}),
                  ],
                ),
                Container(height: 15,),
                Container(
                  width: 300,
                  height: 100,
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
                  child: Center(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 115,
                      onChanged: (text) {
                        description = text;
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write Short Description",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Mr. Rockwell',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(height: 8,),
                Text("Max 115 Characters",style: TextStyle(fontFamily: "ChalkBold",fontSize: 10,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 5),
                  child: Text("Add Photos (Max 5 Photos)",style: TextStyle(fontFamily: "ChalkBold",fontSize: 18,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                ),
                Text("Hold to delete photos.",style: TextStyle(fontFamily: "ChalkBold",fontSize: 10,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                files.isEmpty ? GestureDetector(
                  onTap: () {
                    pickMultipleFiles();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 350,
                    height: 170,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 1, // Spread radius
                            blurRadius: 2, // Blur radius
                            offset: Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFBFEAF5)
                    ),
                    child: Center(
                      child: Image.asset("images/galleryicon.png",),
                    ),
                  ),
                ) : GestureDetector(
                  onLongPress: () {
                    setState(() {
                      files = [];
                    });
                  },
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 16/9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: files.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: 350,
                            height: 170,
                            margin: EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFEAFDFC),
                            ),
                            child: Image.file(i,fit: BoxFit.fill,),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text("Add Services (Example: Haircut = 100TL)",style: TextStyle(fontFamily: "ChalkBold",fontSize: 18,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      textDataList.add('');
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 10,right: 10),
                    width: 350,
                    height: 40,
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
                    child: Image.asset("images/addicon2.png",),
                  ),
                ),
                SizedBox(
                  width: 370,
                  height: textDataList.length * 70.0,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: textDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15,),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            textDataList[index] = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Service',

                          ),
                          style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070))
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text("Add the Shop Location",style: TextStyle(fontFamily: "ChalkBold",fontSize: 18,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                ),
                GestureDetector(
                  onTap: () async {
                    result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddLocation()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 350,
                    height: 170,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 1, // Spread radius
                            blurRadius: 2, // Blur radius
                            offset: Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFBFEAF5)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset("images/biglocationicon.png",scale: 1.1,),
                        Text("Click To Add The Location",style: TextStyle(fontFamily: "ChalkBold",fontSize: 18,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25,bottom: 5),
                  child: Text("Add Your Working Hours",style: TextStyle(fontFamily: "ChalkBold",fontSize: 18,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                ),
                TextFieldContainer(currentHeight: 80, hintText: "MidWeek 09:00-21:00", currentWidth: 320, hintSize: 18, textSize: 18, onTextChanged: (text){workingHours = text;}),
                Padding(
                  padding: const EdgeInsets.only(top: 25,bottom: 5),
                  child: Text("Add Contact Addresses",style: TextStyle(fontFamily: "ChalkBold",fontSize: 18,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                ),
                TextFieldContainer(currentHeight: 55, hintText: "Phone Number", currentWidth: 330, hintSize: 18, textSize: 18, onTextChanged: (text){phoneNumber = text;}),
                Container(height: 10,),
                TextFieldContainer(currentHeight: 55, hintText: "Email", currentWidth: 330, hintSize: 18, textSize: 18, onTextChanged: (text){email = text;}),
                Container(height: 20,),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try{
                      if(shopName != '' && jobName != '' && description != '' && workingHours != '' && phoneNumber != '' && email != '' && files.isNotEmpty && textDataList.isNotEmpty && result['latitude'] != null){
                        Map<String, dynamic> data = {};
                        //Uploading String Datas
                        String jobId = uuid.v4();
                        data['shopName'] = shopName;
                        data['jobName'] = jobName;
                        data['description'] = description;
                        data['workingHours'] = workingHours;
                        data['phoneNumber'] = phoneNumber;
                        data['email'] = email;
                        data['latitude'] = result['latitude'];
                        data['longitude'] = result['longitude'];
                        for (int i = 0; i < textDataList.length; i++) {
                          data['service$i'] = textDataList[i];
                        }
                        _firestore.collection(dropdownValue).doc(jobId).set(data);

                        //Uploading Images
                        uploadFile(jobId,files);

                      }else{
                        //Someone is Empty
                      }

                    }catch(e){
                      print(e);
                    }
                  },
                  child: Container(
                    width: 256,
                    height: 105,
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
                        color: Color(0xFFBFEAF5)
                    ),
                    child:Center(child: const Text("Publish",style: TextStyle(fontFamily: "ChalkBold",fontSize: 35,color: Color(0xFF707070)),textAlign: TextAlign.center,)),
                  ),
                ),
                Container(height: 15,),
                GestureDetector(
                  onTap: () {
                    PageRouteTransition.effect = TransitionEffect.fade;
                    PageRouteTransition.push(context, const EntryPoint(screen: MainScreen(),));
                  },
                  child: Container(
                    width: 109,
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
                    child:Center(child: const Text("Discard",style: TextStyle(fontFamily: "ChalkBold",fontSize: 15,color: Color(0xFF707070)),textAlign: TextAlign.center,)),
                  ),
                ),
                Container(height: 40,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
