import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ieee_qr_code/Pages/adminPage.dart';
import 'package:ieee_qr_code/Pages/qrCodePage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController emailController = new TextEditingController();
  //
  // TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
        elevation:5,
        backgroundColor: Colors.blue[900],
        leading: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text("Login",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),


      body: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          //email input
          const Text("Email",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            )
            ,),


          SizedBox(height: 10,width:screenWidth),

          //Email Text form field
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: emailController,
              decoration:const InputDecoration(
                border: OutlineInputBorder(borderRadius:BorderRadius.all(
                    Radius.circular(25)
                ),
                    borderSide:BorderSide(color: Colors.blueAccent
                        ,width: 2.0
                    )
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),


          //password
          const Text("Password",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              )
          ),
          const SizedBox(height: 10),


          //password text form field
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration:const InputDecoration(
                border: OutlineInputBorder(borderRadius:BorderRadius.all(
                    Radius.circular(25)
                ),
                    borderSide:BorderSide(color: Colors.blueAccent
                        ,width: 2.0
                    )
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),


          SizedBox(
            width: 250,
            child: AnimatedButton(
              text: "LOGIN",
              color: Colors.blue[900],
              pressEvent: (){
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  title: "CONFIRM?",
                  showCloseIcon: true,
                  animType: AnimType.scale,
                  btnOkText: "YES!",
                  btnCancelText: "NO!",
                  btnOkOnPress: (){
                    setState(() async{
                      try {

                        String emailData = emailController.text;
                        String passwordData = passwordController.text;

                        var re = RegExp(r'@admin.com');

                        var re2 = RegExp(r'@dev.com');

                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailData,
                          password: passwordData,
                        );

                        if(re.hasMatch(emailData))
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPage()),);
                          }
                        else
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const QrCodePage()),);
                          }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    });
                  }
                ).show();
              } ,
            ),
          )

        ],
      ),
    );
  }
}
