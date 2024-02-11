import 'package:flutter/material.dart';
import 'package:ieee_qr_code/Pages/qrCodePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          ElevatedButton(onPressed: () {
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QrCodePage()),);
            });
          }, child: const Text("LOGIN"))
        ],
      ),
    );
  }
}
