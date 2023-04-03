import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
//Creating new instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> registerWithEmailAndPassword(String email, String password) async {
    try{
        final user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
    }on FirebaseAuthException catch (e) {
      if(e.code == 'invalid-email'){
        return 101;
      }else if(e.code == 'weak-password'){
        return 102;
      }
      else if(e.code != ""){
        print('Error: $e');
        return 103;
      }
      
    }
    return 100;
    // you can also store the user in Database
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {

    if(email != "" && password != ""){
      if(isEmail(email) == false){
        print('ce n\'est pas un email');
        return false;
      }


      print("je passe par la 1");
      try{
        print("je passe par la 2");

        final user = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("je passe par la 3");


      } on FirebaseAuthException catch (e) {
        
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          print('No user found for that email or password.');

          return false;

        } 
        else if(e.code !=""){
          print("an other exception for login");
          print('Error: $e');
          return false;
        }
      }
    
      print('good');
      return true;
    }
    return false;
  }
  


  final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );

  bool isEmail(String input) {
    return emailRegex.hasMatch(input);
  }
}