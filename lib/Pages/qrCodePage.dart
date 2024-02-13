import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ieee_qr_code/api/sheets/sheets_api.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodePage extends StatefulWidget {
  final String ssID, workSheet;
  final List<int> qrColumns;
  final int checkColumn;

  const QrCodePage({super.key, required this.ssID, required this.workSheet, required this.qrColumns, required this.checkColumn});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}


class _QrCodePageState extends State<QrCodePage> {
  bool gotValidQr = false;
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
    controller.scannedDataStream.listen((barcode)=> setState(() async {
      if(gotValidQr) {return;}
      gotValidQr = true;

      this.barcode = barcode;
      await _dialogBuilder(context);

      gotValidQr = false;
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

  // This is used for the alert dialogue on scan
  Future<void> _dialogBuilder(BuildContext context) {
    String? data = barcode?.code;
    barcode = null;
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Confirm?"),
        content: Text("Data:\n$data"),
        actions: [
          TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Deny", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),)),
          TextButton(onPressed: () async {
            // Simple internet check
            if(await InternetConnectionChecker().hasConnection) {
              bool checkedComplete = await SheetsApi.scanQRtoSheet(widget.ssID, widget.workSheet, data!, widget.qrColumns, widget.checkColumn);
              // Handles if the check was completed and error cases
              if (checkedComplete) {
                if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully added")));}
              }
              else {
                if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error has occurred")));}
              }
              if(context.mounted){Navigator.of(context).pop();}
            }
            else {
              if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No internet connection, Try again")));}
            }
            }, child: Text("Confirm",
            style: TextStyle(color: Colors.blue[900],
                fontWeight: FontWeight.bold),
            )
          )
        ],
      );
    });
  }

}

