import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:geocoding/geocoding.dart';

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
  @override

  var searchValue;
  var laloq = "";

  
  Future<List<String?>> getLocation() async {
    var lesplaces;
    List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");

    List<Placemark> placemarks = await placemarkFromCoordinates(locations[1].latitude, locations[1].longitude);
    lesplaces = [placemarks[1].country,placemarks[1].name];
    print(lesplaces);
    return lesplaces;
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: Text('Value: $laloq'),
        onSearch: (value) => setState(() => laloq = value),
        suggestions: ["oui"]

      ),
      body:  
      Center(
        child: 
        Column(
          children: [
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
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(48, 2.2),
                        width: 30,
                        height: 30,
                        builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(48.1, 2.2),
                        width: 30,
                        height: 30,
                        builder: (ctx) => const Image(image: AssetImage('assets/gpsPoint.png')),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(70, 2.2),
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