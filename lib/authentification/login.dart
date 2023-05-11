import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/authentification/register.dart';
import 'package:flutter_application/authentification/reset.dart';
import 'package:flutter_application/map.dart';

import 'auth.dart';


class login extends StatelessWidget {
  const login({super.key});

  

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
  final TextEditingController _passwordController = TextEditingController();

  bool errorConnect = false;

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    setState(() {
      errorConnect = false;
    });
    
    bool result = await Auth().signInWithEmailAndPassword(email, password);

    print(result);
    // ignore: use_build_context_synchronously
    if(result == true){
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    }
    else{
      
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          errorConnect = true;
        });
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
                  "Connectez vous",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 20,
                ),

                Visibility(
                  visible: errorConnect,
                  child: const Text("Email ou mot de passe invalide",
                    style: TextStyle(
                      color: Colors.red, 
                      decoration: TextDecoration.underline
                    ),
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
                const SizedBox(height: 20),
               

                  
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => handleSubmit(),
                  child: const Text('Se connecter'),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const register())
                    )
                  },
                  child: 
                      const Text('Page d\'enregistrement'),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const reset())
                    )
                  },
                  child: 
                      const Text('Mot de passe oublié'),
                ),
              ],
                
            ),
          ),
        ),
      ),
    );
  }
}