import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek1/view/tujuan/DataTujuan.dart';
import 'dart:async';
import 'dart:io';

import '../../model/TujuanModel.dart';
import '../../model/api.dart';

// variabel
const List<String> list = <String>['Masuk', 'Keluar'];

class EditTujuan extends StatefulWidget {
  // memanggil fungsi dan variabel
  final VoidCallback reload;
  final TujuanModel model;
  EditTujuan(this.model, this.reload);

  @override
  State<EditTujuan> createState() => _EditTujuanState();
}

class _EditTujuanState extends State<EditTujuan> {
  // focusnode
  FocusNode myFocusNode = FocusNode();
  String? id_tujuan, Tujuan, Tipe, T7an;
  final _key = GlobalKey<FormState>();
  TextEditingController? txtTujuan;

  // setup
  setup() async {
    T7an = widget.model.tipe;
    if (T7an == "M") {
      T7an = "Masuk";
    } else if (T7an == "K") {
      T7an = "Keluar";
    }
  }

  // check
  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      UpdateTujuan();
    }
  }

  // Updatetujuan
  UpdateTujuan() async {
    try {
      final respon =
          await http.post(Uri.parse(BaseUrl.urlEditTujuan.toString()), body: {
        "id_tujuan": id_tujuan,
        "tujuan": Tujuan,
        "tipe": Tipe == null ? widget.model.tipe! : Tipe
      });
      final data = jsonDecode(respon.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);

      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DataTujuan()));
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
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Edit Tujuan Transaksi",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: txtTujuan,
                validator: (e) {
                  if (e!.isEmpty) {
                    return "silahkan isi Tujuan";
                  } else {
                    return null;
                  }
                },
                onSaved: (e) => Tujuan = e,
                decoration: InputDecoration(
                    labelText: "Tujuan Transaksi",
                    labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 32, 54, 70),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 32, 54, 70)))),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Color.fromARGB(255, 32, 54, 70),
                      width: 0.80,
                    )),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: Tipe,
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      Tipe = value!;
                    });
                  },
                  isExpanded: true,
                  hint: Text(Tipe == null ? T7an.toString() : Tipe.toString()),
                )),
              ),
              SizedBox(
                height: 25,
              ),
              MaterialButton(
                color: Color.fromARGB(255, 41, 69, 91),
                onPressed: () {
                  check();
                },
                child: Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              )
            ],
          )),
    );
  }
}
