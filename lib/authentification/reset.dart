import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/authentification/login.dart';
import 'package:flutter_application/map.dart';

import 'auth.dart';


class reset extends StatelessWidget {
  const reset({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyApp();
          } else {
            return const loginScreen();
          }
        },
      ),
    );
  }
}

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool messageForReset = false;
  String messageForResetTexte ="L'email de reccuperation a etait envoyer \n (verifier la boite de spam)";

  funcReset() async {
    if (!_formKey.currentState!.validate()) return;
    final thisEmail = _emailController.value.text;
    String letext = "L'email de reccuperation a etait envoyer \n (verifier la boite de spam)";
    setState(() {
      messageForReset = false;
      messageForResetTexte = letext;
    });

    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: thisEmail);
    }on FirebaseAuthException catch  (e) {
      if(e.code == "invalid-email"){
        letext = "Email invalide";
      }
    }

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        messageForReset = true;
        messageForResetTexte = letext;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 196, 211),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            //Add form to key to the Form Widget
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "réinitialiser le mot de passe",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 20,
                ),
                

                Visibility(
                  visible: messageForReset,
                  child:  Text( messageForResetTexte,
                    textAlign: TextAlign.center,
                  )
                ),


                TextFormField(
                  //Assign controller
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    focusColor: Colors.black,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                     
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => funcReset(),
                  child: const Text('Envoier le mail de recuperation'),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const login())
                    )
                  },
                  child: 
                      const Text('Page de login'),
                ),
              ],
                
            ),
          ),
        ),
      ),
    );
  }
}