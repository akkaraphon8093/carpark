import 'dart:async';

import 'package:carpark/utillity/my_constan.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class MapUser extends StatefulWidget {
  const MapUser({Key? key}) : super(key: key);

  @override
  _MapUserState createState() => _MapUserState();
}

class _MapUserState extends State<MapUser> {
  Completer<GoogleMapController> _controller = Completer();
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('PARKFORU'),
        backgroundColor: MyConstant.dark,
        elevation: 0,
        
      ),
      body: Center(
        child: GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: LatLng(13.674479, 100.600733),
            zoom: 15,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      drawer: Drawer(
        child: Material(
          color: MyConstant.dark,
          child: ListView(
          padding: padding,
            children: <Widget>[
              const SizedBox(
                height: 50,),
                buildSearchField(),
                  const SizedBox(height: 20),
                buildMenuItem(
                  text: 'Carpark',
                  icon: Icons.local_parking,
                ),
                const SizedBox(height: 5,),
                buildMenuItem(
                  text: 'Gas Station',
                  icon: Icons.local_gas_station,
                ),
                const SizedBox(height: 5,),
                buildMenuItem(
                  text: 'EV Station',
                  icon: Icons.ev_station,
                ),
                const SizedBox(height: 10,),
                Divider(color: Colors.white70,),
                const SizedBox(height: 10,),
                buildMenuItem(
                  text: 'Login',
                  icon: Icons.login_outlined,
                  onClicked:() => Navigator.pushNamed(context, MyConstant.routeAuthen),
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
    }){
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
        prefixIcon: Icon(Icons.search, color: color),
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
    );
  } 
}
