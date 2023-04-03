import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class pointMemo extends StatefulWidget {
  const pointMemo({super.key});
  @override
    ApppointMemo createState() =>  ApppointMemo();
}

class ApppointMemo extends State<pointMemo>{

  final User? myUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> adresseCollection = FirebaseFirestore.instance.collection('lesAdresse').where('uidUser', isEqualTo: myUser?.uid  ).snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: adresseCollection,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {


          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return MarkerLayer(
            markers: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            
            String oneOfAllLat = data['latitude'].toString();
            double oneOfAllLat2= double.parse(oneOfAllLat);

            String oneOfAllLong = data['longitude'].toString();
            double oneOfAllLong2= double.parse(oneOfAllLong);
            
            LatLng oneOfAllLatLong = LatLng(oneOfAllLat2, oneOfAllLong2);

            

            return 
              Marker(
                point: oneOfAllLatLong,
                width: 8,
                height: 8,
                builder: (ctx) => const Image(image: AssetImage('assets/gpsPointSave.png')),
              );
          }).toList(),
          );
        },
    );
  }
  
  
  
}
