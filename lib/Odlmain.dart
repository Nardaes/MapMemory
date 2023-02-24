import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Widget'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
        ),


        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 216, 67, 230),
                ),
                child: Text(
                  'menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('OUI'),
              ),
              ListTile(
                title: Text('NON'),
              ),
              ListTile(
                title: Text('PEUT-ETRE'),
              ),
            ],
          ),
        ),





        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("It's cloudy here"),
            ),
            Center(
              child: CupertinoSwitchExample(),
            ),
            Center(
              child: RandomWords(),
            ),
          ],
        ),


        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.navigation),
        ),


      ),
    );
  }
}



  class _RandomWordsState extends State<RandomWords> {            
    final _suggestions = <WordPair>[];            
    final _biggerFont = const TextStyle(fontSize: 18);            
    @override            
    Widget build(BuildContext context) {            
      return ListView.builder(            
        padding: const EdgeInsets.all(100.0),            
        itemBuilder: /*1*/ (context, i) {            
          if (i.isOdd) return const Divider(); /*2*/            
  
          final index = i ~/ 2; /*3*/            
          if (index >= _suggestions.length) {            
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/            
          }            
          return ListTile(            
            title: Text(            
              _suggestions[index].asPascalCase,            
              style: _biggerFont,            
            ),            
          );            
        },            
      );            
    }            
  }            
   
  class RandomWords extends StatefulWidget {            
    const RandomWords({super.key});            
    
    @override            
    State<RandomWords> createState() => _RandomWordsState();
  
  }
  




class CupertinoSwitchExample extends StatefulWidget {
  const CupertinoSwitchExample({super.key});

  @override
  State<CupertinoSwitchExample> createState() => _CupertinoSwitchExampleState();
}


class _CupertinoSwitchExampleState extends State<CupertinoSwitchExample> {
  bool wifi = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        // CupertinoFormRow's main axis is set to max by default.
        // Set the intrinsic height widget to center the CupertinoFormRow.
        child: IntrinsicHeight(
          child: Container(
            color: Color.fromARGB(255, 136, 148, 132),
            child: CupertinoFormRow(
              prefix: Row(
                children: <Widget>[
                  Icon(
                    // Wifi icon is updated based on switch value.
                    wifi ? CupertinoIcons.wifi : CupertinoIcons.wifi_slash,
                    color: wifi
                        ? CupertinoColors.systemBlue
                        : Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                  ),
                  const SizedBox(width: 10),
                  const Text('Wi-Fi')
                ],
              ),
              child: CupertinoSwitch(
                // This bool value toggles the switch.
                value: wifi,
                thumbColor: CupertinoColors.systemBlue,
                trackColor: Color.fromARGB(255, 33, 116, 0).withOpacity(0.14),
                activeColor: CupertinoColors.systemRed.withOpacity(0.64),
                onChanged: (bool? value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    wifi = value!;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
