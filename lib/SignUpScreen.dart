import 'package:appoflutter/LoginScreen.dart';
import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/MainScreen.dart';
import 'package:appoflutter/Widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String name = '';
  String surname = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  String checkPassword = '';
  bool showSpinner = false;


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
                Container(height: 20,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("AppoVery",style: TextStyle(fontFamily: "ChalkBold",fontSize: 40,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                  ],
                ),
                Container(height: 20,),
                Row(
                  children: [
                    Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: (){
                        PageRouteTransition.effect = TransitionEffect.fade;
                        PageRouteTransition.push(context, LoginScreen());
                      },
                      child: Image.asset('images/backicon.png'))
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 60),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TyperAnimatedText('It is not enough to do your best,',textStyle: const TextStyle(fontFamily: "ChalkBold",fontSize: 15)),
                          TyperAnimatedText('you must know what to do,',textStyle: const TextStyle(fontFamily: "ChalkBold",fontSize: 15)),
                          TyperAnimatedText('and then do your best',textStyle: const TextStyle(fontFamily: "ChalkBold",fontSize: 15)),
                          TyperAnimatedText('- W.Edwards Deming',textStyle: const TextStyle(fontFamily: "ChalkBold",fontSize: 15)),
                        ],
                      ),
                    )
                  ],
                ),
                Container(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //font 25 hint 25
                    TextFieldContainer(currentWidth: 180,currentHeight: currentHeight / 15.8,hintText: "Name",hintSize: currentHeight / 35.4,textSize: currentHeight / 35.4,onTextChanged: (text){name = text;},),
                    TextFieldContainer(currentWidth: 180,currentHeight: currentHeight / 15.8,hintText: "Surname",hintSize: currentHeight / 35.4,textSize: currentHeight / 35.4,onTextChanged: (text){surname = text;},),
                  ],
                ),
                Container(height: 15,),
                TextFieldContainer(currentWidth: 310,currentHeight: currentHeight / 12.8,hintText: "Phone Number",hintSize: currentHeight / 35.4,textSize: currentHeight / 35.4,onTextChanged: (text){phoneNumber = text;},),
                Container(height: 15,),
                TextFieldContainer(currentWidth: 280,currentHeight: currentHeight / 12.7,hintText: "Email",hintSize: currentHeight / 35.4,textSize: currentHeight / 35.4,onTextChanged: (text){email = text;},),
                Container(height: 15,),
                TextFieldContainer(currentWidth: 240,currentHeight: currentHeight / 12.7,hintText: "Password",hintSize: currentHeight / 35.4,textSize: currentHeight / 35.4,onTextChanged: (text){password = text;},),
                Container(height: 15,),
                TextFieldContainer(currentWidth: 240,currentHeight: currentHeight / 12.7,hintText: "Check Password",hintSize: currentHeight / 35.4,textSize: currentHeight / 35.4,onTextChanged: (text){checkPassword = text;},),
                Container(height: 20,),
                Container(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try{
                        if(name.isNotEmpty && surname.isNotEmpty && email.isNotEmpty && phoneNumber.isNotEmpty && password.isNotEmpty && checkPassword.isNotEmpty && password == checkPassword){
                          final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                          if (newUser != null){
                            _firestore.collection("users").doc(newUser.user!.uid).set({
                              'name':name,
                              'surname':surname,
                              'email':email,
                              'phoneNumber':phoneNumber,
                            });
                            setState(() {
                              showSpinner = false;
                            });
                            PageRouteTransition.effect = TransitionEffect.fade;
                            PageRouteTransition.push(context, const EntryPoint(screen: MainScreen(),));
                          }
                        }else{
                          print("Empty here");
                        }

                      }catch(e){
                        print(e);
                      }
                    },
                    child: Container(
                      width: 240,
                      height: currentHeight / 8.7,
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
                          color: const Color(0xFF91D8E4)
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Sign Up", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontFamily: 'Mr. Rockwell', color: Color(0xFF707070), fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(height: 10,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You can also login with Google or Facebook",style: TextStyle(fontFamily: "ChalkBold",fontSize: 12,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                  ],
                ),
                Container(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/googlelogo.png'),
                    Image.asset('images/facebooklogo.png'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
