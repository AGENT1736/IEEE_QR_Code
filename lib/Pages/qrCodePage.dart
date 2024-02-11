import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}


class _QrCodePageState extends State<QrCodePage> {

  final qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? barcode;

  QRViewController? controller;

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async{
    if (Platform.isAndroid){
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

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
        body: Stack(alignment: Alignment.center,
          children:<Widget> [
            buildQrView(context),
            Positioned(
                bottom: 10,
                child: buildResult()
            )
          ],
        )
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
        borderWidth: 10,
        borderLength: 20,
        borderRadius: 10,
        borderColor: Colors.blueAccent
    ),
  );

  void onQRViewCreated(QRViewController controller)
  {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((barcode)=> setState(() {
      this.barcode = barcode;
    }));
  }

  Widget buildResult () => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white24,
    ),
    child: Text(
      barcode != null ? "Result: ${barcode!.code}" : "Scan a code!",
      maxLines: 3,),
  );
}

