import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ieee_qr_code/Pages/userPage.dart';

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

  //this is used to check if the user is logged in or not?
  @override
  void initState(){
    FirebaseAuth.instance.authStateChanges().listen((User? user){
      if(user == null)
        {
          print("User is currently signed out!");
        } else {
        print("User is signed in!");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //this statement checks if the user is logged in if so? => it automatically skips the login page and goes to the qr code scanner page
      //if not it navigates to the login page
      home: FirebaseAuth.instance.currentUser == null? const UserPage():const UserPage(),
    );
  }
}
