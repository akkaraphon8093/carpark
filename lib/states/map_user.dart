import 'dart:async';

import 'package:carpark/utillity/my_constan.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapUser extends StatefulWidget {
  final name;

  const MapUser({Key? key, this.name}) : super(key: key);

  @override
  _MapUserState createState() => _MapUserState();
}

class _MapUserState extends State<MapUser> {
  Completer<GoogleMapController> _controller = Completer();
  final padding = EdgeInsets.symmetric(horizontal: 20);

  var userLocation;
  var mapController;
  Set<Marker> markmap = {};
  var carparkIcon;
  var searchAdd;

  @override
  void initState() {
    super.initState();
    this.markerIcons();
  }

  void markerIcons() async {
    carparkIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'images/gasstation.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      markmap.add(
        Marker(
            markerId: MarkerId("1"),
            position: LatLng(13.580846073645597, 100.65173088713934),
            icon: carparkIcon,
            infoWindow: InfoWindow(title: 'sdsd', snippet: 'sf')),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("2"),
          position: LatLng(13.582963121318436, 100.64793287930931),
        ),
      );
    });
  }

  Future _getLocation() async {
    try {
      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userLocation = null;
    }
    return userLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('PARKFORU'),
        backgroundColor: MyConstant.dark,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              mapType: MapType.terrain,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: LatLng(userLocation.latitude, userLocation.longitude),
                  zoom: 15),
              markers: markmap,
            );
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
      drawer: Drawer(
        child: Material(
          color: MyConstant.dark,
          child: ListView(
            padding: padding,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              buildSearchField(),
              const SizedBox(height: 20),
              buildMenuItem(
                text: 'Carpark',
                icon: Icons.local_parking,
              ),
              const SizedBox(
                height: 5,
              ),
              buildMenuItem(
                text: 'Gas Station',
                icon: Icons.local_gas_station,
              ),
              const SizedBox(
                height: 5,
              ),
              buildMenuItem(
                text: 'EV Station',
                icon: Icons.ev_station,
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.white70,
              ),
              const SizedBox(
                height: 10,
              ),
              buildMenuItem(
                text: '${widget.name}',
                icon: Icons.face_outlined,
              ),
              const SizedBox(
                height: 5,
              ),
              buildMenuItem(
                text: 'Logout',
                icon: Icons.login_outlined,
                onClicked: () =>
                    Navigator.pushNamed(context, MyConstant.routeAuthen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: color,),
                    onPressed: searchnavigate,
                    iconSize: 30,
                  ),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
      onChanged: (val) {
                  setState(() {
                    searchAdd = val;
                  });
                },
    );
  }
  searchnavigate() {
    locationFromAddress(searchAdd).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(result[0].latitude, result[0].longitude),
        zoom: 15,
      )));
    });
  }
  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
