import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';


class pointMemo{

  @override
  List<Marker> build(BuildContext context) {
    var markers = <Marker>[
      
       Marker(
        point: LatLng(20, 21),
        width: 30,
        height: 30,
        builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
      ),
      Marker(
        point: LatLng(21, 20),
        width: 30,
        height: 30,
        builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
      ),
  
    
    ];
    
    return markers;
  }
  
  
}