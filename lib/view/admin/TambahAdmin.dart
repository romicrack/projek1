import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:async/async.dart';
import 'package:projek1/model/api.dart';
import '../../model/LevelModel.dart';

class TambahAdmin extends StatefulWidget {
  // const TambahAdmin({super.key});
  final VoidCallback reload;
  TambahAdmin(this.reload);

  @override
  State<TambahAdmin> createState() => _TambahAdminState();
}

class _TambahAdminState extends State<TambahAdmin> {
  // focusnode
  FocusNode myFocusNode = new FocusNode();
  String? nama, username, password, level;
  final _key = new GlobalKey<FormState>();
  LevelModel? _currentLevel;
  final String? linkLevel = BaseUrl.UrlDataLevel;
  Future<List<LevelModel>> _fetchLevel() async {
    var response = await http.get(Uri.parse(linkLevel.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = jsonDecode(response.body).cast<Map<String, dynamic>>();
      List<LevelModel> listOfLevel = items.map<LevelModel>((json) {
        return LevelModel.fromJson(json);
      }).toList();
      return listOfLevel;
    } else {
      throw Exception('gagal');
    }
  }

  // check
  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      Simpan();
    }
  }

  // simpan
  Simpan() async {
    try {
      final response = await http
          .post(Uri.parse(BaseUrl.UrlTambahAdmin.toString()), body: {
        "nama": nama,
        "username": username,
        "password": password,
        "level": level
      });
      final data = jsonDecode(response.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);

      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.reload();
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Tambah Admin",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan Isi Nama";
                }
              },
              onSaved: (e) => nama = e,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 32, 54, 70),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan Isi Username";
                }
              },
              onSaved: (e) => username = e,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 32, 54, 70),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan Isi Password";
                }
              },
              onSaved: (e) => password = e,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 32, 54, 70),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            FutureBuilder<List<LevelModel>>(
                future: _fetchLevel(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<LevelModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: Color.fromARGB(255, 32, 54, 70),
                          width: 0.80),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      items: snapshot.data!
                          .map((listLevel) => DropdownMenuItem(
                                child: Text(listLevel.lvl.toString()),
                                value: listLevel,
                              ))
                          .toList(),
                      onChanged: (LevelModel? value) {
                        setState(() {
                          _currentLevel = value;
                          level = _currentLevel!.id_level;
                        });
                      },
                      isExpanded: true,
                      hint: Text(level == null
                          ? "Pilih Level"
                          : _currentLevel!.lvl.toString()),
                    )),
                  );
                }),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
              child: Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            )
          ],
        ),
      ),
    );
  }
}
