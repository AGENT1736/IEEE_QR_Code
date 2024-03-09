import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ieee_qr_code/Pages/qrCodePage.dart';
import 'package:ieee_qr_code/api/sheets/sheets_api.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PreScan extends StatefulWidget {
  final QueryDocumentSnapshot eventDoc;
  const PreScan({super.key, required this.eventDoc});
  @override
  State<PreScan> createState() => _PreScanState();
}

class _PreScanState extends State<PreScan> {
  late String selectedSheet;
  late String selectedColumn;
  bool isSheetSelected = false;
  bool isColumnSelected = false;

  @override
  Widget build(BuildContext context) {
    List<String> sheets = widget.eventDoc['WorkSheets'].keys.toList();
    if(!isSheetSelected) {
      selectedSheet = sheets[0];
    }
    List<dynamic> columns = widget.eventDoc['WorkSheets'][selectedSheet];
    if(!isColumnSelected) {
      selectedColumn = columns[0];
    }
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
          child: Text("Pre scan",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white)
          ),
        ),
      ),
      body: LoaderOverlay(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.shade900, borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.lightBlue,
                  underline: const SizedBox(),
                  value: selectedSheet,
                  items: sheets.map((sheet) {return DropdownMenuItem(value: sheet, child: Text(sheet, style: const TextStyle(color: Colors.white)));}).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSheet = value!;
                      columns = widget.eventDoc['WorkSheets'][selectedSheet];
                      isSheetSelected = true;
                      isColumnSelected = false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.shade900, borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.lightBlue,
                  underline: const SizedBox(),
                  value: selectedColumn,
                  items: columns.map((columns) {return DropdownMenuItem(value: columns, child: Text(columns, style: const TextStyle(color: Colors.white)));}).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedColumn = value!.toString();
                      isColumnSelected = true;
                    });
                  },
                ),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                    fixedSize: const Size(double.maxFinite, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade900,
                    textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    shape: (RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blue.shade900)))),
                onPressed: () async {
                  context.loaderOverlay.show();
                  String? ssID = SheetsApi.getSheetIdFromUrl(widget.eventDoc['sheetUrl']);
                  int targetColumn = await SheetsApi.headerNameToIndex(ssID, selectedSheet, selectedColumn);
                  List<int> qrIndex = [];
                  for (int i = 0; i <widget.eventDoc['QrCols'].length; i++) {
                    qrIndex.add(await SheetsApi.headerNameToIndex(ssID, selectedSheet, widget.eventDoc['QrCols'][i]));
                  }
                  if(context.mounted){
                    SheetsApi.init(ssID);
                    SheetsApi.updateRowsLocal(selectedSheet);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QrCodePage(ssID: ssID!, checkName: selectedColumn ,workSheet: selectedSheet, qrColumns: qrIndex, checkColumn: targetColumn,)),);}
                },
                child: const Text('Start Scan'),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
