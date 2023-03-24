import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/memory.dart';
import 'package:flutter_application/modalAdd.dart';
// firebase import
// import 'package:firedart/firedart.dart';



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}


class MyAppState extends State<MyApp> {
  final champControlleur = TextEditingController();
  MapController mapController = MapController();
  LatLng lepoint = LatLng(48, 2.2);
  List<List<dynamic>> suggestions = [];
  double sizeOfSearch = 0;
  bool isButtonVisible = false;
  List<dynamic> theLocToSave=[];

  modalAdd maModal = modalAdd();


  void searchAddress(String address) async {

    if(champControlleur.text != ""){

      String apiUrl ='https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=10&accept-language=fr-FR';
      
      List<List<dynamic>> lessuggestion = [];
      var response = await http.get(Uri.parse(apiUrl));
      double sizeSearch = 170;

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

          if(data.length <= 4){
            sizeSearch = 0;
            for(var ladata in data){
              sizeSearch = sizeSearch + 35;
            }
          }

          setState(() {
            suggestions = lessuggestion;
            sizeOfSearch = sizeSearch;
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
            champControlleur.text = theLoc[0];
            mapController.move(lal, 13.0);
            lepoint = lal;
            sizeOfSearch = 0;
            isButtonVisible = true;
            theLocToSave = theLoc;
          });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      backgroundColor: const Color.fromARGB(255, 156, 210, 215),
      appBar: AppBar(
        
        backgroundColor: const Color.fromARGB(255, 31, 196, 211),
        title: const Text('MymemoryApp'),
      ),
      body:  
        Center(
          child: 
          Column(
            children: [
              
              TextField(
                controller: champControlleur,
                decoration: const InputDecoration(
                  labelText: 'Recherche d\'adresse',
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255)
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
                        child: 
                        Container(
                          color : const Color.fromARGB(255, 156, 210, 215),
                          child :Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                                height: 0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                      child: Text(
                                        suggestions[index][0],
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                            ],
                            
                          ),
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
                    enableMultiFingerGestureRace: false,
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
                    Visibility(
                      visible: isButtonVisible,
                      child: MarkerLayer(
                        markers: [
                          Marker(
                            point: lepoint,
                            width: 30,
                            height: 30,
                            builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomAppBar(
          color : const Color.fromARGB(255, 31, 196, 211),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  tooltip: 'Liste des adresses',
                  icon: const Icon(Icons.checklist_rtl),
                  onPressed: () {
                    
                    Navigator.push(
                    context,
                     MaterialPageRoute(builder: (context) => const memory()),
                    );
                  },
                ),
              ],
          ),
        ),

        floatingActionButton : Visibility(
          visible: isButtonVisible,
          child: FloatingActionButton(
            onPressed: () async {
              maModal.modalBuild(context, theLocToSave);
              LatLng lal = LatLng(48, 2.2);
              setState(() {
                    isButtonVisible = false;
              });
            },
            backgroundColor: Colors.amber,
            tooltip: 'Ajouter une adresse',
            child: const Icon(Icons.add),
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        
    );
  }


  


}