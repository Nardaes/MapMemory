import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class memory extends StatefulWidget {
  const memory({super.key});
  @override
    _memory createState() =>  _memory();
}

class  _memory extends State<memory> {
  
  final Stream<QuerySnapshot> adresseCollection = FirebaseFirestore.instance.collection('lesAdresse').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
            return Text(data['nomAdresse']);
          }).toList(),
        );
      },
    );
  }
}