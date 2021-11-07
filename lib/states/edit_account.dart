import 'dart:convert';
import 'package:carpark/states/map_user.dart';
import 'package:carpark/utillity/my_constan.dart';
import 'package:carpark/widgets/show_image.dart';
import 'package:carpark/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:carpark/states/authen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class EditAccount extends StatefulWidget {
  final user;
  const EditAccount({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class UserData {
  String id;
  String name;
  String email;
  String phone;
  String user;

  UserData.arr(
    Map data,
  )   : id = data["id"].toString(),
        name = data["name"].toString(),
        email = data["email"].toString(),
        phone = data["phone"].toString(),
        user = data["user"].toString();
}

class _EditAccountState extends State<EditAccount> {
  bool statusRedEye = true; //showpass
  var _edit = GlobalKey<FormState>();
  List<UserData> _getUserList = [];
  List<UserData> _userList = [];

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();

  Future getUserData() async {
    var res = await http.post(
      Uri.parse(
        "http://192.168.1.107/pj/selectUser.php",
      ),
      body: {
        "user": widget.user,
      },
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      var arr = json.decode(res.body.toString());
      for (var _getUserData in arr) {
        _getUserList.add(
          UserData.arr(_getUserData),
        );
      }
    }
    return _userList = _getUserList;
  }

  Future editUser() async {
    var res = await http.post(
      Uri.parse(
        "http://192.168.1.107/pj/editUser.php",
      ),
      body: {
        "user": user.text,
        "name": name.text,
        "email": email.text,
        "phone": phone.text,
        "pass": pass.text,
        "cpass": cpass.text,
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
          builder: (context) => EditAccount(user: widget.user)));
      Fluttertoast.showToast(
        msg: "บันทึกข้อมูลแล้ว",
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
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyConstant.dark,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: getUserData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && _userList.isNotEmpty) {
                return Form(
                  key: _edit,
                  child: ListView(
                    children: [
                      buildImage(size),
                      buildTitle(),
                      buildName(size),
                      buildEmail(size),
                      buildPhon(size),
                      buildUser(size),
                      buildPassword(size),
                      buildConfirmPassword(size),
                      const SizedBox(
                        height: 10,
                      ),
                     buildCreate(size),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff0D1A26),
                  ),
                );
              }
            }));
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: size * 0.5, child: ShowImage(path: MyConstant.image2)),
      ],
    );
  }

  Row buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'บัญชีผู้ใช้',
          textStlye: MyConstant().h1Style(),
        ),
      ],
    );
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
          /* readOnly: true,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "แก้ไขชื่อ",
                        style: TextStyle(color: MyConstant.dark),
                      ),
                      content: TextFormField(
                        controller: name =
                            TextEditingController(text: _userList[0].name),
                        validator: (value) {
                          return value!.isNotEmpty ? null : "กรุณากรอกข้อมูล";
                        },
                        decoration: InputDecoration(
                          labelText: "ชื่อ :",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'บันทึก',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            editUser();
                            //  Navigator.of(context).pop();
                            
                          },
                        ),
                      ],
                    );
                  });
            },*/
            controller: name=TextEditingController(text: _userList[0].name),
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'ชื่อ :',
              hintText: _userList[0].name,
              prefixIcon: Icon(
                Icons.badge_outlined,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "กรุณากรอกชื่อ";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Row buildEmail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
           /* readOnly: true,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "แก้ไขอีเมล",
                        style: TextStyle(color: MyConstant.dark),
                      ),
                      content: TextFormField(
                        controller: email =
                            TextEditingController(text: _userList[0].email),
                        validator: (value) {
                          return value!.isNotEmpty ? null : "กรุณากรอกข้อมูล";
                        },
                        decoration: InputDecoration(
                          labelText: "อีเมล :",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'บันทึก',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            editUser();
                          //  Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },*/
            controller: email=TextEditingController(text: _userList[0].email),
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'อีเมล :',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "กรุณากรอกอีเมล";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Row buildPhon(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
          /*  readOnly: true,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "แก้ไขเบอร์โทรศัพท์",
                        style: TextStyle(color: MyConstant.dark),
                      ),
                      content: TextFormField(
                        maxLength: 10,
                        controller: phone =
                            TextEditingController(text: _userList[0].phone),
                        validator: (value) {
                          return value!.isNotEmpty ? null : "กรุณากรอกข้อมูล";
                        },
                        decoration: InputDecoration(
                          labelText: "เบอร์โทรศัพท์ :",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'บันทึก',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            editUser();
                           // Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },*/
            controller: phone=TextEditingController(text: _userList[0].phone),
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'เบอร์โทรศัพท์ :',
              prefixIcon: Icon(
                Icons.call_outlined,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "กรุณากรอกเบอร์โทรศัพท์";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            readOnly: true,
            controller: user = TextEditingController(text: _userList[0].user),
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'ชื่อผู้ใช้ :',
              prefixIcon: Icon(
                Icons.face_outlined,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "กรุณากรอกชื่อผู้";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
           /* readOnly: true,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: Text(
                          'แก้ไขรหัสผ่าน',
                          style:
                              TextStyle(color: MyConstant.dark, fontSize: 24),
                        ),
                        content: Form(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: TextFormField(
                                controller: pass,
                                obscureText: statusRedEye, //Password**
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        statusRedEye = !statusRedEye;
                                      });
                                    },
                                    icon: statusRedEye
                                        ? Icon(
                                            Icons.remove_red_eye,
                                            color: MyConstant.dark,
                                          )
                                        : Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: MyConstant.dark,
                                          ),
                                  ),
                                  labelStyle: MyConstant().h3Style(),
                                  labelText: 'รหัสผ่าน :',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              margin: EdgeInsets.all(5),
                            ),
                            Container(
                              child: TextFormField(
                                controller: cpass,
                                obscureText: statusRedEye,
                                decoration: InputDecoration(
                                  labelStyle: MyConstant().h3Style(),
                                  labelText: 'ยืนยันรหัสผ่าน :',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value != pass.text) {
                                    return "รหัสผ่านไม่ตรงกัน";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        )),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'บันทึก',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              editUser();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
                  });
            }, */
            controller: pass,
            obscureText: statusRedEye, //Password**
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'รหัสผ่าน :',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildConfirmPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: cpass,
            obscureText: statusRedEye,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'ยืนยันรหัสผ่าน :',
              prefixIcon: Icon(
                Icons.lock,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            validator: (value) {
              if (value != pass.text) {
                return "รหัสผ่านไม่ตรงกัน";
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Row buildCreate(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            //onPressed: () {},
            onPressed: () {
              if (_edit.currentState!.validate()) {
                editUser();
              }
            },
            child: Text('บันทึกข้อมูล'),
          ),
        ),
      ],
    );
  }

  Row buildTitle1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'กรุณาระบุข้อมูลให้ครบถ้วน.',
          textStlye: MyConstant().h4Style(),
        ),
      ],
    );
  }
}
