import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ieee_qr_code/Pages/add_event_page.dart';
import 'package:ieee_qr_code/Pages/pre_scan_page.dart';
import 'package:ieee_qr_code/Widgets/event_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../api/fireStore/fireStore_api.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add, color: Colors.white,),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEventPage()),);
      }),
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
          child: Text("Admin Page",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white)
          ),
        ),
      ),
      body: FutureBuilder <QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('events').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("An error has occurred"),);
          }
          else if (snapshot.hasData) {
            var events = snapshot.data;
            List eventDocuments = [];
            for(var i in events!.docs) {
              eventDocuments.add(i);
            }
            return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 5,),
                itemCount: events.size,
                itemBuilder: (context, index) {
                  return EventCard(text: eventDocuments[index]['name'], imageUrl: eventDocuments[index]['iconUrl'], onPressed: (){
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: Text(eventDocuments[index]['name']),
                        content: Text("What would you like to do?", style: TextStyle(color: Colors.blue.shade900, fontSize: 15, fontWeight: FontWeight.bold),),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PreScan(eventDoc: eventDocuments[index])),);
                            }, child: Text("Scan", style: TextStyle(color: Colors.blue.shade900, fontSize: 15, fontWeight: FontWeight.bold),)),
                          TextButton(onPressed: (){}, child: const Text("Edit", style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),)),
                          TextButton(onPressed: (){
                            setState(() {
                              FireStoreApi.deleteEvent(eventDocuments[index].reference.id);
                              Navigator.of(context).pop();
                            });
                            }, child: const Text("Delete", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),)),
                        ],
                      );
                    });
                  });
                },
            );
          }
          else {
            return Center(child: LoadingAnimationWidget.inkDrop(color: Colors.blue.shade500, size: 200),);
          }
        },)
    );
  }
}

