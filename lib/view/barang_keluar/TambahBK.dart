import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projek1/model/TujuanModel.dart';
import 'package:projek1/model/api.dart';
import 'package:projek1/view/barang_keluar/DataTransaksiBK.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class TambahBK extends StatefulWidget {
  // void call
  final VoidCallback reload;
  TambahBK(this.reload);

  @override
  State<TambahBK> createState() => _TambahBKState();
}

class _TambahBKState extends State<TambahBK> {
  // focusnode
  FocusNode KtFocusNode = FocusNode();
  String? IdAdm, Tjuan, Ket;

  // getpref
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      IdAdm = pref.getString("id");
    });
  }

  final _key = GlobalKey<FormState>();
  TujuanModel? _currentT;
  final String? linkT = BaseUrl.urlDataTBK;
  Future<List<TujuanModel>> _fetchBR() async {
    var response = await http.get(Uri.parse(linkT.toString()));
    print("Hasil: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<TujuanModel> listOfT = items.map<TujuanModel>((json) {
        return TujuanModel.fromJson(json);
      });
      return listOfT;
    } else {
      throw Exception("gagal");
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

  // dialog sukses
  dialogSukses(String pesan) {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        showCloseIcon: true,
        title: "Success",
        desc: pesan,
        btnOkOnPress: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DataTransaksiBk(),
              ));
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint("Dialog Dismiss from callback $type");
        }).show();
  }

  // simpan
  Simpan() async {
    try {
      final response =
          await http.post(Uri.parse(BaseUrl.urlTambahBK.toString()), body: {
        "tujuan": Tjuan,
        "ket": Ket,
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
      backgroundColor: Color.fromARGB(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text(
                "Tambah Barang Keluar",
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
            FutureBuilder<List<TujuanModel>>(
              future: _fetchBR(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TujuanModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Container(
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
                      items: snapshot.data!
                          .map((listT) => DropdownMenuItem(
                                child: Text(listT.tujuan.toString()),
                                value: listT,
                              ))
                          .toList(),
                      onChanged: (TujuanModel? value) {
                        setState(() {
                          _currentT = value;
                          Tjuan = _currentT!.id_tujuan;
                        });
                      },
                      isExpanded: true,
                      hint: Text(Tjuan == null
                          ? "pilih tujuan transaksi"
                          : _currentT!.tujuan.toString()),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty()) {
                  return "Silahkan isi keterangan";
                }
              },
              onSaved: (e) => Ket = e,
              focusNode: KtFocusNode,
              decoration: InputDecoration(
                  labelText: "keterangan",
                  labelStyle: TextStyle(
                      color: KtFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 32, 54, 70)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 32, 54, 70)))),
            ),
            SizedBox(
              height: 20,
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
