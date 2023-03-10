import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  MapController mapController = MapController();
  LatLng lepoint = LatLng(48, 2.2);
  List<List<dynamic>> suggestions = [];
  double sizeOfSearch = 0;
  bool isButtonVisible = false;
  List<dynamic> theLocToSave=[];

  void searchAddress(String address) async {

    if(address != ""){

      String apiUrl ='https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=5';
      
      List<List<dynamic>> lessuggestion = [];
      var response = await http.get(Uri.parse(apiUrl));


      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          for(var ladata in data){
            List<dynamic> info = [];
            info.add(ladata["display_name"]);
            info.add(ladata["lat"]);
            info.add(ladata["lon"]); 
            lessuggestion.add(info);
            
          }

          setState(() {
            suggestions = lessuggestion;
            sizeOfSearch = 100;
          });
          

        }
      }
    }
    else{
      setState(() {
            suggestions = [];
            sizeOfSearch = 0;
          });
    }
  }

  void moveTo(List<dynamic> theLoc) async {

    LatLng lal = LatLng(double.parse(theLoc[1]), double.parse(theLoc[2])) ;
    setState(() {
            mapController.move(lal, 13.0);
            lepoint = lal;
            sizeOfSearch = 0;
            isButtonVisible = true;
            theLocToSave = theLoc;
          });
  }

  void saveTheLoc() async{
    if(theLocToSave != []){
      
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body:  
        Center(
          child: 
          Column(
            children: [
              
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Recherche d\'adresse',
                ),
                onChanged: (value) {
                  searchAddress(value);
                },
              ),
              
              SizedBox(
                height: sizeOfSearch,
                child : ListView.builder(
                  itemCount : suggestions.length,
                  itemBuilder: (BuildContext context, int index) { 
                    if(suggestions != null){
                      return GestureDetector(
                        onTap: () {
                          print(suggestions[index]);
                          moveTo(suggestions[index]);
                        },
                        child: Text(
                          suggestions[index][0],
                        ),
                      );
                      
                    }
                    return const Text('');
                  },
                  
                ), 
              ),
              
              
              Flexible(
                child: FlutterMap(

                  options: MapOptions(
                    center: LatLng(45.835300, 1.262500),
                    zoom:5,
                    maxBounds: LatLngBounds(
                      LatLng(-90, -180.0),
                      LatLng(90.0, 180.0),
                    ),

                  ),
                  mapController: mapController,
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: lepoint,
                          width: 30,
                          height: 30,
                          builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
                        ),
                      ],
                    ),

                  ],
                  
                ),
              ),
              Visibility(
                visible: isButtonVisible,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.amber,
                  child: const Icon(Icons.add),
                  
                )
              )
              
            ],
          ),
        ),
    );
  }

}