import 'dart:async';

import 'package:carpark/utillity/my_constan.dart';
import 'package:carpark/widgets/show_image.dart';
import 'package:flutter/cupertino.dart';
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
  GlobalKey<ScaffoldState> _drawer = GlobalKey<ScaffoldState>();

  var userLocation;
  var mapController;
  Set<Marker> markmap = {};
  var carparkIcon;
  var gasIcon;
  var evIcon;
  var searchAdd;

  @override
  void initState() {
    super.initState();
    this.markerIcons();
  }

  void markerIcons() async {
    carparkIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'images/carpark.png');
    gasIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'images/gas.png');
    evIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'images/charging.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      //ที่จอดรถ
      markmap.add(
        Marker(
            markerId: MarkerId("P1"),
            position: LatLng(13.578806435552593, 100.65056822381912),
            icon: carparkIcon,
            infoWindow:
                InfoWindow(title: 'Carpark', snippet: 'ซอยพุฒสี8 แพรกษา'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                    
                     title: Text('ที่จอดรถซอยพุฒสี8'),
                     content: Text('ffffffff'),
                    );
                    
                  });
            }),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("P2"),
          position: LatLng(13.673677928287058, 100.60031897355654),
          icon: carparkIcon,
          infoWindow:
              InfoWindow(title: 'Carpark', snippet: 'ลานจอดรถ พรวัฒนาซีแอล'),
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("P3"),
          position: LatLng(13.676693461500971, 100.58804024985879),
          icon: carparkIcon,
          infoWindow:
              InfoWindow(title: 'Carpark', snippet: 'ลานจอดรถ วัดบางนานอก'),
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("P4"),
          position: LatLng(13.67479383466374, 100.60120095938518),
          icon: carparkIcon,
          infoWindow: InfoWindow(title: 'Carpark', snippet: 'อาคารจอดรถ SBC'),
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("P5"),
          position: LatLng(13.671553762345583, 100.61055903771953),
          icon: carparkIcon,
          infoWindow:
              InfoWindow(title: 'Carpark', snippet: 'ลานจอดรถ ไบเทคบางนา'),
        ),
      );
    });
    setState(() {
      //ปั้มน้ำมัน
      markmap.add(
        Marker(
          markerId: MarkerId("G1"),
          position: LatLng(13.675588145334846, 100.59506391645068),
          icon: gasIcon,
          infoWindow:
              InfoWindow(title: 'GasStition', snippet: 'PTT Station สรรพาวุธ'),
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("G2"),
          position: LatLng(13.580862188966835, 100.65592970937084),
          icon: gasIcon,
          infoWindow:
              InfoWindow(title: 'GasStation', snippet: 'PTT Station ซอยมังกร'),
        ),
      );
    });
    setState(() {
      //EV
      markmap.add(
        Marker(
          markerId: MarkerId("E1"),
          position: LatLng(13.64679532518789, 100.64326791409108),
          icon: evIcon,
          infoWindow: InfoWindow(
              title: 'EV Station', snippet: 'EA Anywhere ซอนศรีด่าน22'),
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("E2"),
          position: LatLng(13.686689238666304, 100.60174509022717),
          icon: evIcon,
          infoWindow: InfoWindow(
              title: 'EV Station', snippet: 'PTT Station ทางด่วนบางนา'),
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
    final name = 'PARKFORU';
    final caption = 'Sanpawut Road';
    return Scaffold(
      key: _drawer,
      appBar: AppBar(
        centerTitle: true,
        title: Text('PARKFORU'),
        backgroundColor: MyConstant.dark,
        
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _getLocation(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return GoogleMap(
                  mapType: MapType.terrain,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      target:
                          LatLng(userLocation.latitude, userLocation.longitude),
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
        /*  Positioned(
            top: 30,
            right: 15,
            left: 15,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: MyConstant.dark.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Flexible(
                  child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () => _drawer.currentState!.openDrawer(),
                      icon: Icon(Icons.menu),
                      color: MyConstant.dark,
                      iconSize: 30,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 15,
                          top: 15,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          color: MyConstant.dark,
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
                  )
                ],
              )),
            ),
          ),
          Positioned(
            bottom: 94,
            right: 12,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),

                    offset: Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Flexible(
                  child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        mapController.animateCamera(CameraUpdate.newLatLng(
                            LatLng(userLocation.latitude,
                                userLocation.longitude)));
                        /*   showDialog(context: context, builder: (context){
                          return AlertDialog(
                            content: Text('ffffff'),
                          );
                        }); */
                      },
                      icon: Icon(Icons.my_location),
                      color: Colors.black54,
                      iconSize: 25,
                    ),
                  ),
                ],
              )),
            ),
          ),*/
        ],
      ),
      drawer: Drawer(
        child: Material(
          color: MyConstant.dark,
          child: ListView(
            padding: padding,
            children: <Widget>[
              buildHeader(
                name: name,
                caption: caption,
                onClicked: () => Navigator.of(context).push,
              ),
               buildSearchField(),
              const SizedBox(height: 20),
              Container(
                child: Column(
                  children: [
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader({
    required String name,
    required String caption,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 50)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: MyConstant.dark,
                child: ShowImage(path: MyConstant.logo2),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    caption,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      );

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
          icon: Icon(
            Icons.search,
            color: color,
          ),
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
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop();
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _addMarkerOnCameraCenter() {
    setState(() {
      markmap.add(Marker(
        markerId: MarkerId("${markmap.length + 1}"),
        infoWindow: InfoWindow(title: "Added marker"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(userLocation.latitude, userLocation.longitude),
      ));
    });
  }
}
