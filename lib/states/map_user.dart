import 'dart:async';

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

  Future<List<Mycar>> mycar() async {
    var res = await http.post(
      Uri.parse(
        "http://192.168.1.107/pj/selectMycar.php",
      ),
      body: {
        "user": widget.user,
      },
    );
    List<Mycar> _mycar = [];

    if (res.statusCode == 200) {
      var arr = json.decode(res.body.toString());
      for (var getMiniBusData in arr) {
        _mycar.add(
          Mycar.arr(getMiniBusData),
        );
      }
    }
    return _mycar;
  }

  Future insertMycar() async {
    var res = await http.post(
      Uri.parse(
        "http://192.168.1.107/pj/insertMycar.php",
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

  @override
  void initState() {
    mycar().then((value) {
      setState(() {
        _mycar.addAll(value);
      });
    });
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
      //ที่จอดรถ
      markmap.add(
        Marker(
          markerId: MarkerId("P1"),
          position: LatLng(13.578806435552593, 100.65056822381912),
          icon: carparkIcon,
          infoWindow: InfoWindow(title: 'Carpark', snippet: 'ซอยพุฒสี8 แพรกษา'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'ที่จอดรถซอยพุฒสี8',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        'ซอยพุฒสี 8 แพรกษา อ.เมืองจังหวัดสมุทรปราการ 10280\n Time : -'),
                  );
                });
          },
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("P2"),
          position: LatLng(13.673677928287058, 100.60031897355654),
          icon: carparkIcon,
          infoWindow:
              InfoWindow(title: 'Carpark', snippet: 'ลานจอดรถ พรวัฒนาซีแอล'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'ลานจอดรถ พรวัฒนาซีแอล',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        '163 33 ซ. นภาลัย 12 แขวง บางนา เขตบางนา กรุงเทพมหานคร 10260\n Time : -'),
                  );
                });
          },
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("P3"),
          position: LatLng(13.676693461500971, 100.58804024985879),
          icon: carparkIcon,
          infoWindow:
              InfoWindow(title: 'Carpark', snippet: 'ลานจอดรถ วัดบางนานอก'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'ลานจอดรถ วัดบางนานอก',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        'ถนนสรรพาวุธ แขวง บางนา เขตบางนา กรุงเทพมหานคร 10260\n Time : 08:00 - 18:00'),
                  );
                });
          },
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("P4"),
          position: LatLng(13.67479383466374, 100.60120095938518),
          icon: carparkIcon,
          infoWindow: InfoWindow(title: 'Carpark', snippet: 'อาคารจอดรถ SBC'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'อาคารจอดรถ SBC',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        '298 ซ. นภาลัย 12 แขวง บางนา เขตบางนา กรุงเทพมหานคร 10260\n Time : 08:00 - 17:00'),
                  );
                });
          },
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("P5"),
          position: LatLng(13.671553762345583, 100.61055903771953),
          icon: carparkIcon,
          infoWindow:
              InfoWindow(title: 'Carpark', snippet: 'ลานจอดรถ ไบเทคบางนา'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'ลานจอดรถ ไบเทคบางนา',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        '88 ถ. เทพรัตน แขวง บางนา เขตบางนา กรุงเทพมหานคร 10260\n Time : 08:00 - 17:00'),
                  );
                });
          },
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
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'PTT Station สรรพาวุธ',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        '119 121 ซ. นภาลัย 12 แขวง บางนา เขตบางนา กรุงเทพมหานคร 10260'),
                  );
                });
          },
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("G2"),
          position: LatLng(13.580862188966835, 100.65592970937084),
          icon: gasIcon,
          infoWindow:
              InfoWindow(title: 'GasStation', snippet: 'PTT Station ซอยมังกร'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'PTT Station ซอยมังกร',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        'ซอย แพรกษา 11 ตำบล แพรกษา อำเภอเมืองสมุทรปราการ สมุทรปราการ 10280'),
                  );
                });
          },
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
              title: 'EV Station', snippet: 'EA Anywhere ซอยศรีด่าน22'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'EA Anywhere ซอยศรีด่าน22',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        'ซอยศรีด่าน 22 ตำบล บางแก้ว อำเภอบางพลี สมุทรปราการ 10540 \n Time : Open 24 hours'),
                  );
                });
          },
        ),
      );
      markmap.add(
        Marker(
          markerId: MarkerId("E2"),
          position: LatLng(13.686689238666304, 100.60174509022717),
          icon: evIcon,
          infoWindow: InfoWindow(
              title: 'EV Station', snippet: 'PTT Station ทางด่วนบางนา'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'PTT Station ทางด่วนบางนา',
                      style: TextStyle(color: MyConstant.dark),
                    ),
                    content: Text(
                        '359 ซอย พงษ์เวชอนุสรณ์ แขวง บางจาก เขตพระโขนง กรุงเทพมหานคร 10260'),
                  );
                });
          },
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
                  trafficEnabled: true,
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
                onClicked: () => Navigator.of(context).push,
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
                        onClicked: () {},
                      ),
                    },
                    const SizedBox(
                      height: 5,
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
