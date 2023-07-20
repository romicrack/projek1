import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projek1/Loading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:projek1/model/TransaksiMasukModel.dart';
import 'package:projek1/view/barang_masuk/DetailTransaksi.dart';
import 'package:projek1/view/barang_masuk/KeranjangBM.dart';
import 'package:projek1/view/barang_masuk/TambahBm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import '../../model/api.dart';

class DataTransaksi extends StatefulWidget {
  @override
  State<DataTransaksi> createState() => _DataTransaksiState();
}

class _DataTransaksiState extends State<DataTransaksi> {
  // set loading
  var loading = false;
  String? LvlUsr;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  // get pref
  getPref() async {
    _lihatData();
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      LvlUsr = pref.getString("level");
    });
  }

  // lihatdata
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlTransaksiBM));
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

  // proses hapus
  _prosesHapus(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.urlHapusBM), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    // logic
    if (value == 2) {
      setState(() {
        _lihatData();
      });
    } else {
      print(pesan);
      dialogHapus(pesan);
    }
  }

  // dialogHapus
  dialogHapus(String pesan) {
    AwesomeDialog(
            context: context,
            dismissOnTouchOutside: false,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: false,
            title: 'ERROR',
            desc: pesan,
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
        .show();
  }

  //alert hapus
  alertHapus(String id) {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dialogType: DialogType.WARNING,
      headerAnimationLoop: false,
      animType: AnimType.TOPSLIDE,
      showCloseIcon: true,
      closeIcon: Icon(Icons.close_fullscreen_outlined),
      title: "WARNING",
      desc:
          "Menghapus data ini akan mengembalikan stok seperti sebelum barang ini diinput, Yakin Hapus?",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        _prosesHapus(id);
      },
    );
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
                  "Data Transaksi Barang Masuk",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);

            // jangan lupa di aktifkan, dan belum ada funsi metodnya

            Navigator.push(
                // belum import
                context,
                MaterialPageRoute(builder: (context) => KeranjangBm()));
          },
          child: FaIcon(FontAwesomeIcons.cartPlus),
          backgroundColor: Color.fromARGB(255, 41, 69, 91),
        ),
        body: RefreshIndicator(
          child: loading
              ? Loading()
              : ListView.builder(itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(x.id_transaksi.toString()),
                          subtitle: Row(
                            children: [
                              Text("Total " + x.total_item.toString()),
                              SizedBox(
                                width: 5,
                              ),
                              Text("(" + x.tgl_transaksi.toString() + ")")
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // jangan lupa di aktifkan
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailTransaksi(
                                          x,
                                          _lihatData() as VoidCallback,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.eye,
                                    size: 20,
                                  )),
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
                      mainAxisSize: MainAxisSize.min,
                    ),
                  );
                }),
          onRefresh: _lihatData,
          key: _refresh,
        ));
  }
}
