import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class TestMap extends StatefulWidget {
  const TestMap({Key? key}) : super(key: key);

  @override
  _TestMapState createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  var mapController;
  var searchAdd;
  var mapWidget;
  var controller;

  Set<Marker> markers = {};

   @override
  void initState() {
    super.initState();
    markers = Set.from([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(width: 500,height: 500,
            child: GoogleMap(
              markers: markers,
              onMapCreated: onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10.0),
              onTap: (pos){
                print(pos);
                Marker m = Marker(markerId: MarkerId('1'),position: pos);
                setState(() {
                  markers.add(m);
                });
              },
            ),
          ),
          Positioned(
            top: 60,
            right: 15,
            left: 15,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 15,
                    top: 15,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: searchnavigate,
                    iconSize: 30,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    searchAdd = val;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  searchnavigate() {
    locationFromAddress(searchAdd).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(result[0].latitude, result[0].longitude),
        zoom: 16,
      )));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
