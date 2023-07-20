import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek1/model/BrandModel.dart';
import 'package:projek1/model/api.dart';

class EditBrand extends StatefulWidget {
  final VoidCallback reload;
  final BrandModel model;
  EditBrand(this.model, this.reload);
  @override
  State<EditBrand> createState() => _EditBrandState();
}

class _EditBrandState extends State<EditBrand> {
  FocusNode myFocusNode = FocusNode();
  String? id_brand, brand;
  final _key = GlobalKey<FormState>();
  TextEditingController? txtidBrand, txtBrand;
  setup() async {
    txtBrand = TextEditingController(text: widget.model.nama_brand);
    id_brand = widget.model.id_brand;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      ProsUp();
    }
  }

  ProsUp() async {
    try {
      final respon = await http.post(Uri.parse(BaseUrl.urlEditBrand.toString()),
          body: {"id_brand": id_brand, "brand": brand});
      final data = jsonDecode(respon.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
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
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Edit Brand Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      // body
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtBrand,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Brand";
                } else {
                  return null;
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
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 32, 54, 70)),
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
                "Edit",
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
