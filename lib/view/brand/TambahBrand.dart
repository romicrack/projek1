import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projek1/model/api.dart';

class TambahBrand extends StatefulWidget {
  final VoidCallback reload;
  TambahBrand(this.reload);

  @override
  State<TambahBrand> createState() => _TambahBrandState();
}

class _TambahBrandState extends State<TambahBrand> {
  FocusNode myFocusNode = new FocusNode();
  String? brand;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpanBrand();
    }
  }

  simpanBrand() async {
    try {
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahBrand.toString()),
          body: {"brand": brand});
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
              child: const Text(
                "Tambah Brand Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      // body
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan isi Brand";
                }
              },
              onSaved: (e) => brand = e,
              decoration: InputDecoration(
                labelText: 'Brand Barang',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 32, 54, 70),
                  ),
                ),
              ),
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
        ),
      ),
    );
  }
}
