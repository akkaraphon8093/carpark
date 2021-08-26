import 'dart:convert';
import 'package:carpark/utillity/my_constan.dart';
import 'package:carpark/widgets/show_image.dart';
import 'package:carpark/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:carpark/states/authen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CreatAccount extends StatefulWidget {
  const CreatAccount({Key? key}) : super(key: key);

  @override
  _CreatAccountState createState() => _CreatAccountState();
}

class _CreatAccountState extends State<CreatAccount> {
  bool statusRedEye = true; //showpass
  var _name = GlobalKey<FormState>();
  var _email = GlobalKey<FormState>();
  var _phone = GlobalKey<FormState>();
  var _user = GlobalKey<FormState>();
  var _pass = GlobalKey<FormState>();
  var _cpass = GlobalKey<FormState>();
  var _signup = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();

  Future signup() async {
    var res = await http.post(
      Uri.parse(
        "http://192.168.1.107/pj/insertUser.php",
      ),
      body: {
        "name": name.text,
        "email": email.text,
        "phone": phone.text,
        "user": user.text,
        "pass": pass.text,
        "cpass": cpass.text,
        
      },
    );

    var data = json.decode(res.body);

    if(data["code"]=="1"){Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => new Authen()));} else {
            Fluttertoast.showToast(
        msg: "มีชื่อผู้ใช้นี้แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
          }

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
      body: Form(key: _signup,
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
            const SizedBox(height: 10,),
            buildTitle1(),
            buildCreate(size),
          ],
        ),
      ),
    );
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
          title: 'Create an account',
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
            controller: name,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Name :',
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
                            return "กรุณากรอกชื่อผู้ใช้งาน";
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
            controller: email,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Email :',
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
                            return "กรุณากรอก Email";
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
            controller: phone,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'PhonNumber :',
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
            controller: user,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'User :',
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
                            return "กรุณากรอก User";
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
              labelText: 'Password :',
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
            validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณากรอกรหัสผ่าน";
                          } 
                          return null;
                        },
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
              labelText: 'ConfirmPassword :',
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
                          if (value == null || value.isEmpty) {
                            return "กรุณายืนยันรหัสผ่าน";
                          } else if (value != pass.text) {
                            return "รหัสผ่านไม่ตรงกัน";
                          }
                          return null;
                        },
          ),)
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
            onPressed: () { if (_signup.currentState!.validate())  {
                            signup();
                          }},
            child: Text('Create account'),
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
          title: 'Please enter user information.',
          textStlye: MyConstant().h4Style(),
        ),
      ],
    );
  }
}
