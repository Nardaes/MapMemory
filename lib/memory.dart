import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/map.dart';

class memory extends StatefulWidget {
  const memory({super.key});
  @override
    Appmemory createState() =>  Appmemory();
}

class  Appmemory extends State<memory> {
  
  final Stream<QuerySnapshot> adresseCollection = FirebaseFirestore.instance.collection('lesAdresse').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 210, 215),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 196, 211),
        title: const Text('Mymemory List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: adresseCollection,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text(data['nomAdresse']),
                  subtitle : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latitude : ${data['latitude']}'),
                      Text('Longitude : ${data['longitude']}'),
                      const Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                      ),
                    ],
                  )
                ),
              );
              

            }).toList(),
          );
        },
      )
    );
  }
}