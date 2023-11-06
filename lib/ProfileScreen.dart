import 'dart:io';
import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/LoginScreen.dart';
import 'package:appoflutter/MainScreen.dart';
import 'package:appoflutter/PasswordChange.dart';
import 'package:appoflutter/Widgets/BackIcon.dart';
import 'package:appoflutter/Widgets/ProfileButton.dart';
import 'package:appoflutter/Widgets/TextFieldContainer.dart';
import 'package:appoflutter/Widgets/TopSide.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name = '';
  String surname = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  String hintName = "Name";
  String hintSurname = "Surname";
  String hintPhoneNumber = "Phone Number";
  String hintEmail = "Email";
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  bool showSpinner = true;
  late final user;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final ref = FirebaseStorage.instance.ref();
  String imageUrl = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
      user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        getTheUserData(loggedInUser.uid);
      }
    }catch(e){
      print(e);
    }
  }

  void getTheUserData(String uid) async {
    final docRef = _firestore.collection("users").doc(uid);
    docRef.get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          hintName = data["name"];
          hintSurname = data["surname"];
          hintPhoneNumber = data["phoneNumber"];
          hintEmail = data["email"];
        });
        showSpinner = false;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    downloadFile();
  }

  void deleteUser() async {
    showSpinner = true;
    if (password.isNotEmpty) {
      try{
        AuthCredential credential = EmailAuthProvider.credential(
          email: hintEmail,
          password: password,
        );
        final oldData = _firestore.collection("users").doc(loggedInUser.uid).delete();
        await user?.delete();
      }catch(e){
        print(e);
      }
    }
    showSpinner = false;
  }

  void updateData() async{
    AuthCredential credential = EmailAuthProvider.credential(
      email: hintEmail,
      password: password,
    );
    try{
      await user?.reauthenticateWithCredential(credential);
      final newUserData = _firestore.collection("users").doc(loggedInUser.uid);
      newUserData.update({
        "name": name.isNotEmpty ? name : hintName,
        "surname":surname.isNotEmpty ? surname : hintSurname,
        "phoneNumber":phoneNumber.isNotEmpty ? phoneNumber : hintPhoneNumber,
        "email": email.isNotEmpty ? email : hintEmail,
      }).then(
              (value) => showDialog(context: this.context, builder: (ctx) => AlertDialog(
            title: const Text("Update Succesful"),
            actions: [
              TextButton(onPressed: ()  {
                Navigator.of(ctx).pop();
              }, child: const Text('Ok')),
            ],
          ),
          ),
          onError: (e) => showDialog(context: this.context, builder: (ctx) => AlertDialog(
            title: const Text("Password is wrong!."),
            actions: [
              TextButton(onPressed: ()  {
                Navigator.of(ctx).pop();
              }, child: const Text('Ok')),
            ],
          ),
          ),
      );
    }catch(e){
      showDialog(context: this.context, builder: (ctx) => AlertDialog(
        title: const Text("Password is wrong!."),
        actions: [
          TextButton(onPressed: ()  {
            Navigator.of(ctx).pop();
          }, child: const Text('Ok')),
        ],
      ),
      );
    }
  }

  void updateEmail() async{
    if (email.isNotEmpty && password.isNotEmpty) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: hintEmail,
        password: password,
      );
      try {
        await user?.reauthenticateWithCredential(credential);
        // Reauthentication successful, continue with email update
        await user?.updateEmail(email);
        // Email update successful
        } catch (e) {
        showDialog(context: this.context, builder: (ctx) => AlertDialog(
          title: const Text("Password is wrong!!"),
          actions: [
            TextButton(onPressed: ()  {
                Navigator.of(ctx).pop();
              }, child: const Text('Ok')),
            ],
          ),
        );
        // Reauthentication or email update failed, handle the error

      }
    }

  }

  void setData() async {
    final oldData = _firestore.collection("users").doc(loggedInUser.uid).delete();
    final newUserData = _firestore.collection("users").doc(loggedInUser.uid);
    newUserData.set({
      "name": name.isNotEmpty ? name : hintName,
      "surname":surname.isNotEmpty ? surname : hintSurname,
      "phoneNumber":phoneNumber.isNotEmpty ? phoneNumber : hintPhoneNumber,
      "email": email.isNotEmpty ? email : hintEmail,
    }).then(
        (value) => showDialog(context: this.context, builder: (ctx) => AlertDialog(
          title: const Text("Email Updated"),
          actions: [
            TextButton(onPressed: ()  {
              Navigator.of(ctx).pop();
            },
                child: const Text('Ok')),
          ],
        ),
        ),
        onError: (e) => print("Error updating document $e"));
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  void uploadFile() async {
    final path = 'files/profilepictures/${loggedInUser.uid}pp';
    final file = File(pickedFile!.path!);

    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {
      showDialog(context: this.context, builder: (ctx) => AlertDialog(
        title: const Text("Profile Picture Uploaded."),
        actions: [
            TextButton(onPressed: ()  {
              Navigator.of(ctx).pop();
            },
              child: const Text('Ok')),
          ],
        ),
      );
    });
  }

  void downloadFile() async {
    try{
      imageUrl = await ref.child('files/profilepictures/${loggedInUser.uid}pp').getDownloadURL();
    }catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    final currentHeight = MediaQuery.of(context).size.height.round();

    return MaterialApp(
      home: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Color(0xFFEAFDFC),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TopSide(),
                Row(
                  children: [
                    BackIcon(whichScreen: MainScreen()),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 65.0),
                          child: const Text("Your Profile",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                        )),
                  ],
                ),
                Container(height: currentHeight / 200,),
                GestureDetector(
                  onTap: () {
                    pickFile();
                  },
                  child: imageUrl == '' ? Container(
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    child: pickedFile == null ? Image.asset('images/addimage.png') : Image.file(File(pickedFile!.path!), fit: BoxFit.cover,),
                  ) : Container(
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    child: Image.network(imageUrl)
                  )
                ),
                Container(height: 5,),
                const Text("You can change your information from here",style: TextStyle(fontFamily: "ChalkBold",fontSize: 12,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                Container(height: currentHeight / 150,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFieldContainer(currentWidth: 180,currentHeight: currentHeight / 16.8,hintText: hintName,hintSize: currentHeight / 40.4,textSize: currentHeight / 40.4,onTextChanged: (text){name = text;},),
                    TextFieldContainer(currentWidth: 180,currentHeight: currentHeight / 16.8,hintText: hintSurname,hintSize: currentHeight / 40.4,textSize: currentHeight / 40.4,onTextChanged: (text){surname = text;},),
                  ],
                ),
                Container(height: currentHeight / 89,),
                TextFieldContainer(currentWidth: 390,currentHeight: currentHeight / 16.8,hintText: hintPhoneNumber,hintSize: currentHeight / 40.4,textSize: currentHeight / 40.4,onTextChanged: (text){phoneNumber = text;},),
                Container(height: currentHeight / 44.5,),
                TextFieldContainer(currentWidth: 390,currentHeight: currentHeight / 16.8,hintText: hintEmail,hintSize: currentHeight / 40.4,textSize: currentHeight / 40.4,onTextChanged: (text){email = text;},),
                Container(height: currentHeight / 44.5,),
                TextFieldContainer(currentWidth: 390,currentHeight: currentHeight / 16.8,hintText: "Enter your password to save",hintSize: currentHeight / 40.4,textSize: currentHeight / 40.4,onTextChanged: (text){password = text;},),
                Container(height: currentHeight / 44.5,),
                GestureDetector(
                  onTap: () async {
                    showSpinner = true;
                    try{
                      if(pickedFile != null){
                        uploadFile();
                      }
                      if(email.isNotEmpty && password.isNotEmpty){
                        updateEmail();
                        setData();
                      }else{
                        if(password.isNotEmpty){
                          updateData();
                        }
                      }
                      showSpinner = false;
                      PageRouteTransition.effect = TransitionEffect.fade;
                      PageRouteTransition.push(context, const EntryPoint(screen: MainScreen(),));
                    }catch(e){
                      print(e);
                    }
                  },
                  child: Container(
                    width: currentHeight / 4.2,
                    height: currentHeight / 10.4,
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
                    child:Center(child: const Text("Save",style: TextStyle(fontFamily: "ChalkBold",fontSize: 40,color: Color(0xFF707070)),textAlign: TextAlign.center,)),
                  ),
                ),
                Container(height: currentHeight / 49.3,),
                GestureDetector(
                  onTap: () {
                    PageRouteTransition.effect = TransitionEffect.fade;
                    PageRouteTransition.push(context, const EntryPoint(screen: PasswordChange(),));
                  },
                  child: Container(
                    width: 150,
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
                    child:Center(child: const Text("Change Password",style: TextStyle(fontFamily: "ChalkBold",fontSize: 15,color: Color(0xFF707070)),textAlign: TextAlign.center,)),
                  ),
                ),
                Container(height: currentHeight / 49.3,),
                GestureDetector(
                  onTap: () async {
                    showSpinner = true;
                    await FirebaseAuth.instance.signOut();
                    showSpinner = false;
                    PageRouteTransition.effect = TransitionEffect.fade;
                    PageRouteTransition.push(context, const EntryPoint(screen: LoginScreen(),));
                  },
                  child: Container(
                    width: 150,
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
                    child:Center(child: const Text("Sign Out",style: TextStyle(fontFamily: "ChalkBold",fontSize: 15,color: Color(0xFF707070)),textAlign: TextAlign.center,)),
                  ),
                ),
                Container(height: currentHeight / 49.3,),
                GestureDetector(
                  onTap: () {
                    deleteUser();
                    PageRouteTransition.effect = TransitionEffect.fade;
                    PageRouteTransition.push(context,LoginScreen(),);
                  },
                  child: Container(
                    width: 150,
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
                        color: Colors.red
                    ),
                    child:Center(child: const Text("Delete Profile",style: TextStyle(fontFamily: "ChalkBold",fontSize: 15,color: Colors.white),textAlign: TextAlign.center,)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
