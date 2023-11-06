import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/MainScreen.dart';
import 'package:appoflutter/SelectManScreen.dart';
import 'package:appoflutter/Widgets/SideMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:appoflutter/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool loggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkTheUser();
  }

  void checkTheUser() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        loggedIn = false;
      } else {
        loggedIn = true;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigator(
        initialRoute: loggedIn ? '/main' : '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => const LoginScreen();
              break;
            case '/main':
              builder = (BuildContext context) => const EntryPoint(screen: MainScreen());
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}