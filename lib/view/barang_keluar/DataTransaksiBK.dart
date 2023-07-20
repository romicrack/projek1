import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projek1/model/TransaksiMasukModel.dart';
import 'package:projek1/model/api.dart';
import 'package:projek1/view/barang_keluar/DetailTbk.dart';
import 'package:projek1/view/barang_keluar/KeranjangBk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek1/Loading.dart';

class DataTransaksiBk extends StatefulWidget {
  @override
  State<DataTransaksiBk> createState() => _DataTransaksiBkState();
}

class _DataTransaksiBkState extends State<DataTransaksiBk> {
  var loading = false;
  String? LvlUsr;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  // getpref
  getPref() async {
    _lihatData();
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      LvlUsr = pref.getString("level");
    });
  }

  // fungsi lihat data
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(BaseUrl.urlTransaksiBK));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = TransaksiMasukModel(api['id_transaksi'], api['keterangan'],
            api['tgl_transaksi'], api['total_item'], api['tujuan']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  // proseshapus
  _proseshapus(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.urlHapusBK), body: {"id": id});

    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    if (value == 1) {
      setState(() {
        _lihatData();
      });
    } else {
      print(pesan);
      dialogHapus(pesan);
    }
  }

  // alerthapus
  alertHapus(String id) {
    AwesomeDialog(
        context: context,
        dismissOnTouchOutside: false,
        dialogType: DialogType.WARNING,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        showCloseIcon: true,
        closeIcon: Icon(Icons.close_fullscreen_outlined),
        title: "WARNING!",
        desc:
            "Menghapus data ini akan mengembalikan stok seperi sebelum barang ini di input, Yakin Hapus?",
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          _proseshapus(id);
        });
  }

  // dialog hapus
  dialogHapus(String pesan) {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dialogType: DialogType.ERROR,
      headerAnimationLoop: false,
      animType: AnimType.RIGHSLIDE,
      title: "ERROR",
      desc: pesan,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
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
                "Data Transaksi Barang Keluar",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KeranjangBK(),
              ));
        },
        child: FaIcon(FontAwesomeIcons.cartPlus),
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Loading()
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Card(
                      color: Color.fromARGB(255, 250, 248, 246),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              x.id_transaksi.toString(),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total " + x.total_item.toString(),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("(" + x.tgl_transaksi.toString() + ")")
                              ],
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            DetailTbk(x, _lihatData),
                                      ));
                                    },
                                    icon: FaIcon(FontAwesomeIcons.eye)),
                                if (LvlUsr == "1") ...[
                                  IconButton(
                                      onPressed: () {
                                        alertHapus(x.id_transaksi);
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 20,
                                      ))
                                ]
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
