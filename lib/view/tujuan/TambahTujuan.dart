import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../model/api.dart';

const List<String> list = <String>['Masuk', 'Keluar'];

class TambahTujuan extends StatefulWidget {
  final VoidCallback realod;
  TambahTujuan(this.realod);

  @override
  State<TambahTujuan> createState() => _TambahTujuanState();
}

class _TambahTujuanState extends State<TambahTujuan> {
  // focusnode
  FocusNode myFocusNode = FocusNode();
  String? Tujuan, Tipe;
  final _key = GlobalKey<FormState>();

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
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahTujuan.toString()),
          body: {"tujuan": Tujuan, "tipe": Tipe});
      final data = jsonDecode(response.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.realod();
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
                "Data Jenis Barang",
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
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan Isi Jenis";
                  }
                },
                onSaved: (e) => Tujuan = e,
                decoration: InputDecoration(
                    labelText: "Tujuan Transaksi",
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
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      Tipe = value!;
                    });
                  },
                  isExpanded: true,
                  hint: Text(
                      Tipe == null ? "pilih tipe transaksi" : Tipe.toString()),
                )),
              ),
              SizedBox(
                height: 25,
              ),
              MaterialButton(
                onPressed: () {
                  check();
                },
                color: Color.fromARGB(255, 41, 69, 91),
                child: Text(
                  "Simpan",
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
