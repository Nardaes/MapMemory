import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class modalAdd{

  

  Future<void> modalBuild(BuildContext context, theLocToSave) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter L\'adresse'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(

              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Valider'),
              onPressed: () {
                final User? myUser = FirebaseAuth.instance.currentUser;
                if(theLocToSave != []){
                  FirebaseFirestore.instance.collection('lesAdresse').add({
                    'nomAdresse': theLocToSave[0],
                    'latitude' : theLocToSave[1],
                    'longitude' : theLocToSave[2],
                    'uidUser' : myUser?.uid,
                  });
                  
                  
                  print(theLocToSave[0]+"a etait mit en base");
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}