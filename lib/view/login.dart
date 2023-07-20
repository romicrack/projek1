import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:projek1/model/api.dart';
import 'package:projek1/view/menuPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

// metod status login logout
enum LoginStatus { SignOut, SignIn }

class _LoginState extends State<Login> {
  // focunode
  FocusNode myFocusNode = FocusNode();
  LoginStatus _loginStatus = LoginStatus.SignOut;
  String? username, password;
  final _key = GlobalKey<FormState>();
  bool _secureText = true;

  // menampilkan
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  // cek
  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  // metod login
  login() async {
    final response = await http.post(Uri.parse(BaseUrl.urlLogin),
        body: {"username": username, "pass": password});

    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    // logik
    if (value == 1) {
      String idAPI = data['id'];
      String namaAPI = data['nama'];
      String userLevel = data['level'];
      setState(() {
        _loginStatus = LoginStatus.SignIn;
        savePref(value, idAPI, namaAPI, userLevel);
      });
      print(pesan);
    } else {
      print(pesan);
      dialogGagal(pesan);
    }
  }

  // savepref
  savePref(int val, String idAPI, String namaAPI, userLevel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", val);
      preferences.setString("id", idAPI);
      preferences.setString("nama", namaAPI);
      preferences.setString("level", userLevel);
    });
  }

  // identifi variabel
  var value;
  var level;
  var nama;
  var id;

  // getpref
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      level = preferences.getString("level");
      nama = preferences.getString("nama");
      id = preferences.getString("id");

      // logik
      if (value == 1) {
        _loginStatus = LoginStatus.SignIn;
      } else {
        _loginStatus = LoginStatus.SignOut;
      }
    });
  }

  // moted logout
  LogOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.setString("id", null.toString());
      preferences.setString("nama", null.toString());
      preferences.setString("level", null.toString());
      preferences.commit();
      _loginStatus = LoginStatus.SignOut;
    });
  }

  // dialog gagal
  dialogGagal(String pesan) {
    AwesomeDialog(
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: false,
            title: "ERROR",
            desc: pesan,
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
        .show();
  }

  // tadi ada yang salah ketik disini
  void disopse() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.SignOut:
        return Scaffold(
          body: Form(
            key: _key,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: EdgeInsets.only(top: 90.0, left: 20.0, right: 20.0),
              children: <Widget>[
                Icon(
                  CupertinoIcons.cube_box,
                  size: 50.0,
                ),
                Text(
                  "INVENTORY",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Silahkan Masukkan Username";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(
                          color: myFocusNode.hasFocus
                              ? Colors.blue
                              : Color.fromARGB(255, 32, 54, 70)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 32, 54, 70)))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: _secureText,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Silahkan Masukkan Password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? Colors.blue
                            : Color.fromARGB(255, 32, 54, 70),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 32, 54, 70),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _secureText ? Icons.visibility_off : Icons.visibility,
                          color: myFocusNode.hasFocus
                              ? Colors.blue
                              : Color.fromARGB(255, 32, 54, 70),
                        ),
                        onPressed: showHide,
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  color: Color.fromARGB(255, 41, 69, 91),
                  onPressed: () {
                    check();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case LoginStatus.SignIn:
        return MenuPage(LogOut);
        break;
    }
  }
}
