import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/authentification/login.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/memory.dart';
import 'package:flutter_application/modalAdd.dart';
import 'package:flutter_application/pointMemo.dart';
import 'package:firebase_auth/firebase_auth.dart';
// firebase import
// import 'package:firedart/firedart.dart';

import 'package:geolocator/geolocator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}


class MyAppState extends State<MyApp> {
  final champControlleur = TextEditingController();
  MapController mapController = MapController();
  LatLng lepoint = LatLng(0,0);
  List<List<dynamic>> suggestions = [];
  double sizeOfSearch = 0;
  bool isButtonVisible = false;


  List<dynamic> theLocToSave=[];

  modalAdd maModal = modalAdd();

  pointMemo mesPoints = pointMemo();

  
  LatLng _currentLocation = LatLng(0,0);
  LatLng tapLocation = LatLng(0,0);


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
            tapLocation = LatLng(0,0);
            _currentLocation = LatLng(0,0);
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
        title: const Text('MapMemory'),
      ),
      body:  
        Center(
          child: 
          Column(
            children: [
              
              TextField(
                controller: champControlleur,
                decoration: const InputDecoration(
                  labelText: 'Recherche et ajout d\'adresses',
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
                    enableMultiFingerGestureRace: true,
                    maxBounds: LatLngBounds(
                      LatLng(-90, -180.0),
                      LatLng(90.0, 180.0),
                    ),
                    onTap:(tapPosition, thepointhere) {
                      tapLocationMove(thepointhere);
                    },
                    maxZoom: 18

                  ),
                  mapController: mapController,
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    mesPoints,
                    if (lepoint != LatLng(0,0))
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: lepoint,
                            width: 35,
                            height: 70,
                            builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
                          ),
                        ],
                      ),
                    if (tapLocation != LatLng(0,0))
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: tapLocation,
                            width: 35,
                            height: 70,
                            builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
                          ),
                        ],
                      ),
                    if (_currentLocation != LatLng(0,0))
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation,
                            width: 35,
                            height: 70,
                            builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
                          ),
                        ],
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
                    final User? myUser = FirebaseAuth.instance.currentUser;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const memory()),
                    );
                  },
                ),

                IconButton(
                  tooltip: 'Localisation',
                  icon: const Icon(Icons.zoom_in),
                  onPressed: () {
                      _getCurrentLocation();
                  },
                ),

                IconButton(
                  tooltip: 'Déconnexion',
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const login()),
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
              setState(() {

                    champControlleur.text = "";
                    isButtonVisible = false;
                    sizeOfSearch = 0;
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



  Future<void> tapLocationMove(LatLng clicLatLong) async {
    String theNameLoc = await searchLatlong(clicLatLong);


    setState(() {
      isButtonVisible = true;
      lepoint = LatLng(0,0);
      _currentLocation = LatLng(0,0);
      tapLocation = clicLatLong;
      theLocToSave = [theNameLoc, clicLatLong.latitude, clicLatLong.longitude];
    });

    print(theLocToSave);
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
  
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }




    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

    String theNameLoc = await searchLatlong(_currentLocation);
    setState(() {
      isButtonVisible = true;
      tapLocation = LatLng(0,0);
      lepoint = LatLng(0,0);
      _currentLocation = LatLng(position.latitude, position.longitude);
      mapController.move(_currentLocation, 13.0);
      
      theLocToSave = [theNameLoc, _currentLocation.latitude, _currentLocation.longitude];
    });
  }



  Future<String> searchLatlong(LatLng laLatEtLaLong) async {



    if(laLatEtLaLong != null){

      double theLat = laLatEtLaLong.latitude;
      double theLong = laLatEtLaLong.longitude;

      String apiUrl ='https://nominatim.openstreetmap.org/reverse?lat=$theLat&lon=$theLong&accept-language=fr-FR&format=json&limit=1';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          print(data["display_name"]);
          return data["display_name"];
        }

        
      }

      
    }

    return "Inconnue";
  }

}