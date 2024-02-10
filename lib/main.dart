import 'package:flutter/material.dart';
import 'package:ieee_qr_code/Pages/qrCodePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QrCodePage(),
    );
  }
}
