import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreApi {
  static Future<void> addEvent (String name, String sheetUrl, String iconUrl, Map<String, List<String>> workSheets, Map<String, List<String>> qrSheet) async {
    await FirebaseFirestore.instance.collection('events').add(
      {
        "name" : name,
        "iconUrl" : iconUrl,
        "sheetUrl" : sheetUrl,
        "WorkSheets" : workSheets,
        "QrSheet" : qrSheet
      }
    ).then((value) => print("Addition Success"));
  }

  static Future<void> deleteEvent (String eventID) async {
    await FirebaseFirestore.instance.collection('events').doc(eventID).delete().then((value) => print("Deletion success"));
  }
}