import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';


// class MaClasse {
//   Widget monWidget() {
//     final User? myUser = FirebaseAuth.instance.currentUser;
//     final Stream<QuerySnapshot> adresseCollection = FirebaseFirestore.instance.collection('lesAdresse').where('uidUser', isEqualTo: myUser?.uid  ).snapshots();

//     return StreamBuilder<QuerySnapshot>(
//         stream: adresseCollection,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

//           List<Marker> allMarker =[];

//           if (snapshot.hasError) {
//             return const Text('Something went wrong');
//           }

//           // return allMarker;

          
//         },
//       );
//   }
// }