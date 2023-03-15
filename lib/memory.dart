import 'package:flutter/material.dart';


class memory extends StatefulWidget {

  @override
  State<memory> createState() => _memory();
}

// ignore: camel_case_types
class _memory extends State<memory> {
  
  List testList = [3,3,3];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de memory'),
      ),
      body: 
        SizedBox(
          height: 1000,
          child : ListView.builder(
            itemCount : testList.length,
            itemBuilder: (BuildContext context, int index) {
              if(testList != []){
                return const Text("Je test ma list view");
              }
              return const Text('En charge');
            },
                  
          ), 
        ),
    );
  }
}