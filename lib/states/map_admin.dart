import 'dart:async';

import 'package:carpark/utillity/my_constan.dart';
import 'package:carpark/widgets/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:carpark/states/map_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class MapAdmin extends StatefulWidget {
  final user;
  final name;
  final status;
  const MapAdmin({Key? key, this.user, this.name, this.status}) : super(key: key);

  @override
  _MapAdminState createState() => _MapAdminState();
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

class _MapAdminState extends State<MapAdmin> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameLocation = TextEditingController();
  final TextEditingController _dataLocation = TextEditingController();
  String? _typeLocation = "";
  GlobalKey<ScaffoldState> _drawer = GlobalKey<ScaffoldState>();

  var userLocation;
  var inmapmark;
  var mapController;
  var searchAdd;
  var carparkIcon;
  var gasIcon;
  var evIcon;
  var mycarIcon;
  var m;
  var _idlocation;
  Set<Marker> markmap = {};
  List<MarkerLocation> _showMarkerLocation = [];

  Future insertLocation(inmapmark) async {
    var res = await http.post(
      Uri.parse(
        "http://toom3737.thddns.net:5753/pj/insertLocation.php",
      ),
      body: {
        "typelocation": _typeLocation,
        "namelocation": _nameLocation.text,
        "datalocation": _dataLocation.text,
        "latitude": inmapmark.latitude.toString(),
        "longitude": inmapmark.longitude.toString(),
      },
    );
    var data = json.decode(res.body);
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapAdmin(
                    user: widget.user,
                    name: widget.name,
                  )));
      Fluttertoast.showToast(
        msg: "เพิ่มสถานที่แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
    }
  }

  Future _refresh() async{       
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
                    markers: markmap,);
  }

  Future deleteLocation(_idlocation) async {
    print(_idlocation);
    var res = await http.post(
      Uri.parse(
        "http://toom3737.thddns.net:5753/pj/deleteLocation.php",
      ),
      body: {
        "idlocation": _idlocation,
      },
    );

    var data = json.decode(res.body);
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapAdmin(
                    user: widget.user,
                    name: widget.name,
                  )));
      Fluttertoast.showToast(
        msg: "ลบสถานที่แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
    }
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
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'ลบข้อมูล',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              deleteLocation(_idlocation =
                                  _showMarkerLocation[num].idlocation);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
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
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'ลบข้อมูล',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              deleteLocation(_idlocation =
                                  _showMarkerLocation[num].idlocation);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
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
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'ลบข้อมูล',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              deleteLocation(_idlocation =
                                  _showMarkerLocation[num].idlocation);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
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
  void initState() {
    super.initState();
    this.markerIcons();
    markmap = Set.from([]);
    markerLocation().then((value) {
      _showMarkerLocation.addAll(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = 'CarparkForU';
    final caption = 'เพิ่มสถานที่';
    return Scaffold(
      key: _drawer,
      appBar: AppBar(
        centerTitle: true,
        title: Text('เพิ่มสถานที่'),
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
                    onTap: (inmapmark) {
                      Fluttertoast.showToast(
                        msg: "แตะที่มาร์คเกอร์เพื่อเพิ่มข้อมูล",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                      );
                
                      print(inmapmark);
                      Marker m = Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(inmapmark.latitude, inmapmark.longitude),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text(
                                      'เพิ่มสถานที่',
                                      style: TextStyle(
                                          color: MyConstant.dark, fontSize: 24),
                                    ),
                                    content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              child:
                                                  DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: "Mitr",
                                                  ),
                                                  border: OutlineInputBorder(),
                                                  labelText: "สถานที่",
                                                  labelStyle: TextStyle(
                                                    fontFamily: "Mitr",
                                                  ),
                                                  isDense: true,
                                                ),
                                                items: [
                                                  "ที่จอดรถ",
                                                  "ปั้มน้ำมัน",
                                                  "อีวีชาร์จ",
                                                ]
                                                    .map(
                                                      (label) => DropdownMenuItem<
                                                          String>(
                                                        child: Text(
                                                          label,
                                                          style: TextStyle(
                                                            fontFamily: "Mitr",
                                                          ),
                                                        ),
                                                        value: label,
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _typeLocation = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "กรุณาเลือกสถานที่";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              margin: EdgeInsets.all(5),
                                            ),
                                            Container(
                                              child: TextFormField(
                                                controller: _nameLocation,
                                                validator: (value) {
                                                  return value!.isNotEmpty
                                                      ? null
                                                      : "กรุณากรอกข้อมูล";
                                                },
                                                decoration: InputDecoration(
                                                  labelText: "ชื่อสถานที่",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              margin: EdgeInsets.all(5),
                                            ),
                                            Container(
                                              child: TextFormField(
                                                controller: _dataLocation,
                                                maxLines: 4,
                                                validator: (value) {
                                                  return value!.isNotEmpty
                                                      ? null
                                                      : "กรุณากรอกข้อมูล";
                                                },
                                                decoration: InputDecoration(
                                                  labelText: "รายละเอียดสถานที่",
                                                  border: OutlineInputBorder(),
                                                ),
                                                keyboardType:
                                                    TextInputType.multiline,
                                              ),
                                              margin: EdgeInsets.all(5),
                                            ),
                                          ],
                                        )),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('บันทึก'),
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            // Do something like updating SharedPreferences or User Settings etc.
                                            Navigator.of(context).pop();
                                            insertLocation(inmapmark);
                                            
                                            
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: Text('ยกเลิก'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                              });
                        },
                      );
                      setState(() {
                        markmap.add(m);
                      });
                    },
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
      /*  floatingActionButton: new Visibility(
        visible: true,
        child: new FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ),
      ),*/
      drawer: Drawer(
        child: Material(
          color: MyConstant.dark,
          child: ListView(
            padding: padding,
            children: <Widget>[
              buildHeader(
                name: name,
                caption: caption,
                onClicked: () =>
                    Navigator.pushNamed(context, MyConstant.routeMapAdmin),
              ),
              buildSearchField(),
              const SizedBox(height: 20),
              Container(
                child: Column(
                  children: [
                    buildMenuItem(
                      text: 'ที่จอดรถ',
                      icon: Icons.local_parking,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    buildMenuItem(
                      text: 'ปั้มน้ำมัน',
                      icon: Icons.local_gas_station,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    buildMenuItem(
                      text: 'อีวีชาร์จ',
                      icon: Icons.ev_station,
                    ),
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
                    const SizedBox(
                      height: 5,
                    ),
                    buildMenuItem(
                        text: 'กลับหน้าหลัก',
                        icon: Icons.keyboard_arrow_left_outlined,
                        onClicked: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapUser(
                                      user: widget.user,
                                      name: widget.name,
                                    )))),
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
