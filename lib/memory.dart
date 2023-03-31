import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class memory extends StatefulWidget {
  const memory({super.key});
  @override
    Appmemory createState() =>  Appmemory();
}

class  Appmemory extends State<memory> {

  final User? myUser = FirebaseAuth.instance.currentUser;

  
  
  

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> adresseCollection = FirebaseFirestore.instance.collection('lesAdresse').where('uidUser', isEqualTo: myUser?.uid  ).snapshots();
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
              return 
              Column(children: [
                GestureDetector(
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
                      ],
                    )
                  ),
                ),
                IconButton(
                  tooltip: 'supprimer',
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                     document.reference.delete(); 
                  },
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              ]);
              

            }).toList(),
          );
        },
      )
    );
  }
}