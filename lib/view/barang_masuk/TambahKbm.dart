import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projek1/Loading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:projek1/model/TransaksiMasukModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import '../../model/BarangModel.dart';
import '../../model/api.dart';
import 'KeranjangBM.dart';

class TambahKbm extends StatefulWidget {
  @override
  State<TambahKbm> createState() => _TambahKbmState();
}

class _TambahKbmState extends State<TambahKbm> {
  // focusnode
  FocusNode jmFocusNode = FocusNode();
  String? IdAdm, Barang, Jumlah;

  // getpref
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      IdAdm = pref.getString("id");
    });
  }

  final _key = GlobalKey<FormState>();
  BarangModel? _currentBR;
  final String? inkBR = BaseUrl.urlDataBarang;

  // buat metode
  Future<List<BarangModel>> _fetchBR() async {
    var response = await http.get(Uri.parse(inkBR.toString()));
    print('hasil: ' + response.statusCode.toString());

    // logic
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<BarangModel> listOfBR = items.map<BarangModel>((json) {
        return BarangModel.fromJson(json);
      }).toList();
      return listOfBR;
    } else {
      throw Exception('gagal');
    }
  }

  // dialogsukses
  dialogSukses(String pesan) {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        showCloseIcon: true,
        title: "SUCCESS",
        desc: pesan,
        btnOkOnPress: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => KeranjangBm()));
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        }).show();
  }

  // metod check
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
      final response =
          await http.post(Uri.parse(BaseUrl.urlInputCBM.toString()), body: {
        "barang": Barang,
        "jumlah": Jumlah,
        "id": IdAdm,
      });

      final data = jsonDecode(response.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];

      print(data);
      if (code == 1) {
        setState(() {
          dialogSukses(pesan);
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
    getPref();
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
              child: const Text(
                "Tambah Barang Masuk",
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
            FutureBuilder<List<BarangModel>>(
                future: _fetchBR(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<BarangModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: Color.fromARGB(255, 32, 54, 70),
                            width: 0.80)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      items: snapshot.data!
                          .map((listBR) => DropdownMenuItem(
                                child: Text(listBR.nama_barang.toString() +
                                    "(" +
                                    listBR.nama_brand.toString() +
                                    ")"),
                                value: listBR,
                              ))
                          .toList(),
                      onChanged: (BarangModel? value) {
                        setState(() {
                          _currentBR = value;
                          Barang = _currentBR!.id_barang;
                        });
                      },
                      isExpanded: true,
                      hint: Text(Barang == null
                          ? "Pilih Barang"
                          : _currentBR!.nama_barang.toString() +
                              "(" +
                              _currentBR!.nama_brand.toString() +
                              ")"),
                    )),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty()) {
                  return "Silahkan isi Jumlah";
                }
              },
              onSaved: (e) => Jumlah = e,
              focusNode: jmFocusNode,
              decoration: InputDecoration(
                  labelText: "Jumlah Barang",
                  labelStyle: TextStyle(
                      color: jmFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 32, 54, 70)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 32, 54, 70)))),
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
