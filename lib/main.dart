import 'dart:async';
import 'dart:convert';
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
  TextEditingController _textController = TextEditingController();
  MapController mapController = MapController();
  LatLng lepoint = LatLng(48, 2.2);
  var suggestions;


  void searchAddress(String address) async {
    String apiUrl ='https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=3';
    List<dynamic> lessuggestion = [];
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        double lat = double.parse(data[0]['lat']);
        double lon = double.parse(data[0]['lon']);

        print(data.length);

        int nbr = 0;
        for(var ladata in data){
          print(ladata["display_name"]);
          lessuggestion.add(ladata["display_name"]);
          lessuggestion.add(ladata["lat"]);
          lessuggestion.add(ladata["lon"]);
        }
        
         print(lessuggestion);

        setState(() {
          mapController.move(LatLng(lat, lon), 13.0);
          lepoint = LatLng(lat, lon);
          suggestions = lessuggestion;
        });
        

      }
    }

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body:  
      Center(
        child: 
        Column(
          children: [
            
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Recherche d\'adresse',
              ),
              onChanged: (value) {
                searchAddress(value);
              },
            ),
            
            // ListView.builder(
            //   itemCount : suggestions,
            //   itemBuilder: (BuildContext context, int index) { 
            //      if(suggestions != null){
            //        for(var suggestion in suggestions){
            //          return Text(suggestion);
            //        }
            //      }
            //      else{
            //        return const Text('suggestion');
            //      }
                 
            //   },
              
            // ),
            
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
          ],
        ),
      ),
    );
  }

}