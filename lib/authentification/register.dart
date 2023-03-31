import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/authentification/login.dart';
import 'package:flutter_application/map.dart';

import 'auth.dart';


class register extends StatelessWidget {
  const register({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyApp();
          } else {
            return const registerScreen();
          }
        },
      ),
    );
  }
}

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  bool isMessageErreur = false;
  String messageErreur = "";


  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passwordController.value.text;
    final password2 = _password2Controller.value.text;
    
    if(password == password2){
      isMessageErreur = false;
       messageErreur ="";

      await Auth().registerWithEmailAndPassword(email, password);

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    }
    else{
      setState(() {
        isMessageErreur = true;
        messageErreur = "Les mot de passes ne correspondent pas";
      });
      
    }

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
                  "Enregistrez vous",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 20,
                ),

                Visibility(
                  visible: isMessageErreur,
                  child: Text(
                    messageErreur
                    
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
                
                TextFormField(
                  //Assign controller
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un mot de passe';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Mot de passe',
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
                TextFormField(
                  //Assign controller
                  controller: _password2Controller,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmez le mot de passe';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Confirmez le mot de passe',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),



                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => handleSubmit(),
                  child: const Text('S\'enregistrer'),
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
                      const Text('Page de connexion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
