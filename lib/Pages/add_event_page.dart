import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sheetUrlController = TextEditingController();
  TextEditingController iconUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          child: Text("Add Event",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white)
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center ,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Event name",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                )
                ,),
              const SizedBox(height: 10),
              SizedBox(
                width: double.maxFinite,
                child: TextFormField(
                  controller: nameController,
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
              const SizedBox(height: 10),
              const Text("Sheets URL",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                )
                ,),
              const SizedBox(height: 10),
              SizedBox(
                width: double.maxFinite,
                child: TextFormField(
                  controller: sheetUrlController,
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
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Icon URL",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    )
                    ,),
                  TextButton(onPressed: (){
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text("Image preview"),
                        content: FadeInImage(
                          image:NetworkImage(iconUrlController.text),
                          placeholder: const AssetImage('assets/placeholder.png'),
                          imageErrorBuilder:(context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                          fit: BoxFit.fitWidth,
                        ),
                      );
                    });
                  }, child: const Text("Preview", style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),)),],

              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.maxFinite,
                child: TextFormField(
                  controller: iconUrlController,
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
              const SizedBox(height: 20),
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
                onPressed: () async {},
                child: const Text('Proceed'),
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
