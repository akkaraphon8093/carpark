import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TestMap extends StatefulWidget {
  const TestMap({Key? key}) : super(key: key);

  @override
  _TestMapState createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  static const LatLng centerMap = const LatLng(13.674590456490531, 100.60070188315436);
  CameraPosition cameraPosition = CameraPosition(
    target: centerMap,
    zoom: 16,
  
  );

  Widget myMap(){
    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: cameraPosition,
      onMapCreated: (GoogleMapController googleMapController) {},
      markers: testMarker(),
    );
  }

  Set<Marker> testMarker(){
    return <Marker>[
      Marker(
        position: centerMap,
        markerId: MarkerId('idTestmarker'),
        
      ),
    ].toSet();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Map Test"),
        backgroundColor: Colors.redAccent,
      ),
      body: myMap(),
    );
  }
}
