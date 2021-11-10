import 'dart:async';

import 'package:carpark/states/edit_account.dart';
import 'package:carpark/states/map_admin.dart';
import 'package:carpark/utillity/my_constan.dart';
import 'package:carpark/widgets/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class MapUser extends StatefulWidget {
  final name;
  final user;

  const MapUser({
    Key? key,
    this.name,
    this.user,
  }) : super(key: key);

  @override
  _MapUserState createState() => _MapUserState();
}

class MarkerLocation {
  String idlocation;
  String typelocation;
  String namelocation;
  String datalocation;
  double latitude;
  double longitude;

  MarkerLocation.arr(
    Map data,
  )   : idlocation = data["idlocation"].toString(),
        typelocation = data["typelocation"].toString(),
        namelocation = data["namelocation"].toString(),
        datalocation = data["datalocation"].toString(),
        latitude = double.parse(data["latitude"]),
        longitude = double.parse(data["longitude"]);
}

class Mycar {
  double latitude;
  double longitude;

  Mycar.arr(
    Map data,
  )   : latitude = double.parse(data["latitude"]),
        longitude = double.parse(data["longitude"]);
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
  var mycarIcon;
  var searchAdd;
  List<Mycar> _mycar = [];
  List<MarkerLocation> _showMarkerLocation = [];

  Future<List<Mycar>> mycar() async {
    var res = await http.post(
      Uri.parse(
        "http://toom3737.thddns.net:5753/pj/selectMycar.php",
      ),
      body: {
        "user": widget.user,
      },
    );
    List<Mycar> _mycar = [];

    if (res.statusCode == 200) {
      var arr = json.decode(res.body.toString());
      for (var getMycar in arr) {
        _mycar.add(
          Mycar.arr(getMycar),
        );
      }
    }
    return _mycar;
  }

  Future<List<MarkerLocation>> markerLocation() async {
    var res = await http.post(
      Uri.parse(
        "http://toom3737.thddns.net:5753/pj/selectLocation.php",
      ),
    );

    List<MarkerLocation> _showMarkerLocation = [];

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      var arr = json.decode(res.body.toString());
      print(res.body);
      for (var _getMarkerLocation in arr) {
        _showMarkerLocation.add(
          MarkerLocation.arr(_getMarkerLocation),
        );
      }
    }
    return _showMarkerLocation;
  }

  Future insertMycar() async {
    var res = await http.post(
      Uri.parse(
        "http://toom3737.thddns.net:5753/pj/insertMycar.php",
      ),
      body: {
        "user": widget.user,
        "latitude": userLocation.latitude.toString(),
        "longitude": userLocation.longitude.toString(),
      },
    );

    var data = json.decode(res.body.toString());

    if (data["code"] == "0") {
      Fluttertoast.showToast(
        msg: "เกิดข้อผิดพลาด",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
    } else if (data["code"] == "1") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new MapUser(
                name: widget.name,
                user: widget.user,
              )));
      Fluttertoast.showToast(
        msg: "เพิ่มตำแหน่งรถแล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
    }
  }

  Future deleteMycar() async {
    var res = await http.post(
      Uri.parse(
        "http://toom3737.thddns.net:5753/pj/deleteMycar.php",
      ),
      body: {
        "user": widget.user,
      },
    );

    var data = json.decode(res.body.toString());

    if (data["code"] == "0") {
      Fluttertoast.showToast(
        msg: "เกิดข้อผิดพลาด",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
    } else if (data["code"] == "1") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => new MapUser(
                name: widget.name,
                user: widget.user,
              )));
      Fluttertoast.showToast(
        msg: "ลบตำแหน่งรถแล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    mycar().then((value) {
      setState(() {
        _mycar.addAll(value);
      });
    });
    super.initState();
    this.markerIcons();
    markerLocation().then((value) {
      _showMarkerLocation.addAll(value);
    });
  }

  void markerIcons() async {
    carparkIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'images/carpark.png');
    gasIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'images/gas.png');
    evIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'images/charging.png');
    mycarIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'images/mycar.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      for (var num = 0; num < _mycar.length; num++) {
        markmap.add(
          Marker(
            markerId: MarkerId("mycar"),
            position: LatLng(_mycar[num].latitude, _mycar[num].longitude),
            icon: mycarIcon,
            infoWindow: InfoWindow(title: 'รถของฉัน'),
          ),
        );
      }
    });
    setState(() {
      for (var num = 0; num < _showMarkerLocation.length; num++) {
        if (_showMarkerLocation[num].typelocation == "ที่จอดรถ") {
          markmap.add(
            Marker(
              markerId: MarkerId(_showMarkerLocation[num].idlocation),
              position: LatLng(_showMarkerLocation[num].latitude,
                  _showMarkerLocation[num].longitude),
              icon: carparkIcon,
              infoWindow: InfoWindow(
                  title: _showMarkerLocation[num].typelocation,
                  snippet: _showMarkerLocation[num].namelocation),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          _showMarkerLocation[num].namelocation,
                          style: TextStyle(color: MyConstant.dark),
                        ),
                        content: Text(_showMarkerLocation[num].datalocation),
                      );
                    });
              },
            ),
          );
        } else if (_showMarkerLocation[num].typelocation == "ปั้มน้ำมัน") {
          markmap.add(
            Marker(
              markerId: MarkerId(_showMarkerLocation[num].idlocation),
              position: LatLng(_showMarkerLocation[num].latitude,
                  _showMarkerLocation[num].longitude),
              icon: gasIcon,
              infoWindow: InfoWindow(
                  title: _showMarkerLocation[num].typelocation,
                  snippet: _showMarkerLocation[num].namelocation),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          _showMarkerLocation[num].namelocation,
                          style: TextStyle(color: MyConstant.dark),
                        ),
                        content: Text(_showMarkerLocation[num].datalocation),
                      );
                    });
              },
            ),
          );
        } else if (_showMarkerLocation[num].typelocation == "อีวีชาร์จ") {
          markmap.add(
            Marker(
              markerId: MarkerId(_showMarkerLocation[num].idlocation),
              position: LatLng(_showMarkerLocation[num].latitude,
                  _showMarkerLocation[num].longitude),
              icon: evIcon,
              infoWindow: InfoWindow(
                  title: _showMarkerLocation[num].typelocation,
                  snippet: _showMarkerLocation[num].namelocation),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          _showMarkerLocation[num].namelocation,
                          style: TextStyle(color: MyConstant.dark),
                        ),
                        content: Text(_showMarkerLocation[num].datalocation),
                      );
                    });
              },
            ),
          );
        }
      }
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
    final name = 'CarparkForU';
    final caption = 'จอดที่ไหนดี?';
    return Scaffold(
      key: _drawer,
      appBar: AppBar(
        centerTitle: true,
        title: Text('CarparkForU'),
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
                  trafficEnabled: true,
                  zoomControlsEnabled: false,
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
                  onClicked: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapAdmin(
                                user: widget.user,
                                name: widget.name,
                              )))),
              buildSearchField(),
              const SizedBox(height: 20),
              Container(
                child: Column(
                  children: [
                    buildMenuItem(
                      text: '${widget.user}',
                      icon: Icons.face_outlined,
                      onClicked: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAccount(
                                user: widget.user
                              )))
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (_mycar.isEmpty) ...{
                      buildMenuItem(
                        text: 'เพิ่มตำแหน่งรถของฉัน',
                        icon: Icons.directions_car,
                        onClicked: () {
                          insertMycar();
                        },
                      ),
                    } else ...{
                      buildMenuItem(
                        text: 'ลบตำแหน่งรถของฉัน',
                        icon: Icons.directions_car,
                        onClicked: () {
                          deleteMycar();
                        },
                      ),
                    },
                    buildMenuItem(
                        text: 'เพิ่มสถานที่',
                        icon: Icons.add_location_alt_outlined,
                        onClicked: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapAdmin(
                                        user: widget.user,
                                        name: widget.name,
                                        
                                      )));
                          Fluttertoast.showToast(
                            msg: "แตะที่แผนที่เพื่อเพิ่มตำแหน่งสถานที่",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildMenuItem(
                      text: 'ออกจากระบบ',
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
        hintText: 'ค้นหา',
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
}
