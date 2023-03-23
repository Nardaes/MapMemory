
import 'package:flutter/material.dart';

import 'package:flutter_application/map.dart';
import 'package:flutter_application/login.dart';
// firebase import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/firebase_options.dart';
// import 'package:firedart/firedart.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: login(),
    // home: MyApp(),
  ));
}






