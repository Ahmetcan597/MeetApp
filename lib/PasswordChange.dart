import 'package:appoflutter/MainScreen.dart';
import 'package:appoflutter/Widgets/ProfileButton.dart';
import 'package:appoflutter/Widgets/TextFieldContainer.dart';
import 'package:appoflutter/Widgets/TopSide.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'Entry_Point.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key? key}) : super(key: key);

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {

  String oldPassword = '';
  String newPassword = '';
  String checkPassword = '';
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  bool showSpinner = false;
  late final user;


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
      }
    }catch(e){
      print(e);
    }
  }

  void updatePassword() async {
    showSpinner = true;
    AuthCredential credential = EmailAuthProvider.credential(
      email: loggedInUser.email.toString(),
      password: oldPassword,
    );

    try{
      if(newPassword == checkPassword && newPassword.isNotEmpty && checkPassword.isNotEmpty){
        await user?.reauthenticateWithCredential(credential);
        await user?.updatePassword(newPassword);
        showDialog(context: this.context, builder: (ctx) => AlertDialog(
          title: const Text("Password changed successfully."),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(ctx).pop();
            }, child: const Text('Ok')),
          ],
        ),
        );
      }else{
        showDialog(context: this.context, builder: (ctx) => AlertDialog(
          title: const Text("Make sure you entered the values correctly."),
          actions: [
            TextButton(onPressed: () {
                Navigator.of(ctx).pop();
              }, child: const Text('Ok')),
            ],
          ),
        );
      }
      showSpinner = false;
    }catch (e) {
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
                Container(height: 8,),
                TopSide(),
                Container(height: 50,),
                const Text("Password Change",style: TextStyle(fontFamily: "ChalkBold",fontSize: 30,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                const Text("You can change your password from here",style: TextStyle(fontFamily: "ChalkBold",fontSize: 12,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                Container(height: 20,),
                TextFieldContainer(currentWidth: 300,currentHeight: currentHeight / 12.7,hintText: "Current Password",hintSize: currentHeight / 35.4,textSize: currentHeight / 40.4,onTextChanged: (text){oldPassword = text;},),
                Container(height: 20,),
                TextFieldContainer(currentWidth: 300,currentHeight: currentHeight / 12.7,hintText: "New Password",hintSize: currentHeight / 35.4,textSize: currentHeight / 40.4,onTextChanged: (text){newPassword = text;},),
                Container(height: 20,),
                TextFieldContainer(currentWidth: 300,currentHeight: currentHeight / 12.7,hintText: "Check Password",hintSize: currentHeight / 35.4,textSize: currentHeight / 40.4,onTextChanged: (text){checkPassword = text;},),
                Container(height: 50,),
                GestureDetector(
                  onTap: () {
                    updatePassword();
                    PageRouteTransition.effect = TransitionEffect.fade;
                    PageRouteTransition.push(context, const EntryPoint(screen: MainScreen(),));
                  },
                  child: Container(
                    width: currentHeight / 3.4,
                    height: currentHeight / 8.9,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
