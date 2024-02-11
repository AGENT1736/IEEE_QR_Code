import 'package:flutter/material.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}


class _QrCodePageState extends State<QrCodePage> {

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back,
              color: Colors.white),
          onPressed: (){
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        backgroundColor: Colors.blue[900],
        title:const Center(
          child: Text("IEEE QR-CODE",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white)
          ),
        ),
      ),
    );
  }
}
