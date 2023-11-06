import 'package:appoflutter/MainScreen.dart';
import 'package:appoflutter/Widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'SignUpScreen.dart';
import 'package:appoflutter/Entry_Point.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
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
                Container(height: currentHeight / 44.5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("AppoVery",style: TextStyle(fontFamily: "ChalkBold",fontSize: currentHeight / 17.8,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                  ],
                ),
                Container(height: currentHeight / 29.6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(currentHeight / 111.25),
                          child: Text("AppoVery",style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: currentHeight / 44.5,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: EdgeInsets.all(currentHeight / 111.25),
                          child: Text("AppoVery",style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: currentHeight / 44.5,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: EdgeInsets.all(currentHeight / 111.25),
                          child: Text("AppoVery",style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: currentHeight / 44.5,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: EdgeInsets.all(currentHeight / 111.25),
                          child: Text("AppoVery",style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: currentHeight / 44.5,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                    Image.asset('images/exlogo.png'),
                  ],
                ),
                Container(height: currentHeight / 44.5,),
                TextFieldContainer(currentWidth: 300,currentHeight: currentHeight / 12.7,hintText: "Email",hintSize: currentHeight / 25.4,textSize: currentHeight / 40.4,onTextChanged: (text){email = text;},),
                Container(height: currentHeight / 89,),
                TextFieldContainer(currentWidth: 300,currentHeight: currentHeight / 12.7,hintText: "Password",hintSize: currentHeight / 25.4,textSize: currentHeight / 40.4,onTextChanged: (text){password = text;},),
                Container(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 50),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try{
                            if(email.isNotEmpty && password.isNotEmpty){
                              final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                              if (user != null){
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
                          width: 180,
                          height: 60,
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
                              color: const Color(0xFF91D8E4)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Login", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontFamily: 'Mr. Rockwell', color: Color(0xFF707070), fontWeight: FontWeight.bold,),),
                              Image.asset('images/righticon.png',width: 40,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(height: 30,),
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
                Container(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Don't have an account",style: TextStyle(fontFamily: "ChalkBold",fontSize: 18,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          print(currentHeight.toString());
                          PageRouteTransition.effect = TransitionEffect.fade;
                          PageRouteTransition.push(context, const SignUpScreen());
                        },
                        child: Container(
                          width: 150,
                          height: 50,
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
                              color: const Color(0xFF91D8E4)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Sign Up", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontFamily: 'Mr. Rockwell', color: Color(0xFF707070), fontWeight: FontWeight.bold,),),
                            ],
                          ),
                        ),
                      ),
                    ),
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
