import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ieee_qr_code/Pages/qrCodePage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //these are the controllers that are used to fetch the data entered by the user
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  //this bool is used to check if the used is an admin
  late bool isAdmin;


  @override void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //this is the signup function that will be used to enter the data required to register and login
  Future signUp() async{
    if(passwordConfirmed()){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );

      //this is where the use details will be added!
      addUserData(usernameController.text.trim(), emailController.text.trim(), passwordController.text.trim(), isAdmin);
    }
  }

  // this function will be used to add the user credential to cloud firestore to use them later
  Future addUserData(String username,String email,String password, bool isAdmin) async{
    await FirebaseFirestore.instance.collection('users').add({
      'username': username,
      'email': email,
      'password': password,
      'isAdmin': isAdmin,
    });
  }

  bool passwordConfirmed(){
    if(passwordController.text.trim().isNotEmpty)
      {
        return true;
      }
    else{
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        title: const Center(
          child: Text("Login",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //developer exclusive
          const Text("Email",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            )
            ,),
          SizedBox(height: 10,width:screenWidth),
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: emailController,
              decoration:const InputDecoration(
                border: OutlineInputBorder(borderRadius:BorderRadius.all(
                    Radius.circular(25)
                ),
                    borderSide:BorderSide(color: Colors.black
                        ,width: 2.0
                    )
                ),
              ),
            ),
          ),


          //all users
          const Text("Username",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            )
            ,),
          SizedBox(height: 10,width:screenWidth),
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: usernameController,
              decoration:const InputDecoration(
                border: OutlineInputBorder(borderRadius:BorderRadius.all(
                    Radius.circular(25)
                ),
                    borderSide:BorderSide(color: Colors.black
                        ,width: 2.0
                    )
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),


          const Text("Password",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              )
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration:const InputDecoration(
                border: OutlineInputBorder(borderRadius:BorderRadius.all(
                    Radius.circular(25)
                ),
                    borderSide:BorderSide(color: Colors.black
                        ,width: 2.0
                    )
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          // ElevatedButton(onPressed: () {
          //   setState(() {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => const QrCodePage()),);
          //   });
          // }, child: const Text("LOGIN")
          // )
          SizedBox(
            width: 250,
            child: AnimatedButton(pressEvent: (){
              AwesomeDialog(context: context,
              dialogType: DialogType.question,
                title: "CONFIRM?",
                showCloseIcon: true,
                animType: AnimType.scale,
                btnOkText: "CONFIRM!",
                btnCancelText: "DON'T CONFIRM!",
                btnOkOnPress: (){
                setState(() async {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const QrCodePage()),);

                  try {
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text
                    );
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const QrCodePage()),);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                }
                );
                },
                btnCancelOnPress: (){}
              ).show();
            },
              text: "LOGIN",
              buttonTextStyle: const TextStyle(color: Colors.white),
              color: Colors.blue[900],
            ),
          ),
          //developer exclusive
          SizedBox(
            width: 250,
            child: AnimatedButton(pressEvent: (){
              AwesomeDialog(context: context,
                  dialogType: DialogType.question,
                  title: "CONFIRM?",
                  showCloseIcon: true,
                  animType: AnimType.scale,
                  btnOkText: "CONFIRM!",
                  btnCancelText: "DON'T CONFIRM!",
                  btnOkOnPress: (){
                    setState(() async {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const QrCodePage()),);
                      try {
                        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const QrCodePage()),);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    );
                  },
                  btnCancelOnPress: (){}
              ).show();
            },
              text: "REGISTER",
              buttonTextStyle: const TextStyle(color: Colors.white),
              color: Colors.red[900],
            ),
          )
        ],
      ),
    );
  }
}