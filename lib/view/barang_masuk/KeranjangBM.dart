import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:projek1/model/KeranjangBmModel.dart';
import 'package:projek1/view/barang_masuk/TambahBm.dart';
import 'package:projek1/view/barang_masuk/TambahKbm.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import '../../model/api.dart';

class KeranjangBm extends StatefulWidget {
  @override
  State<KeranjangBm> createState() => _KeranjangBmState();
}

class _KeranjangBmState extends State<KeranjangBm> {
  // validasi id
  String? IdUsr;
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  // getpref
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      IdUsr = pref.getString("id");
    });
    _lihatData();
  }

  // lihat data
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response =
        await http.get(Uri.parse(BaseUrl.urlCartBM + IdUsr.toString()));

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = KeranjangBModel(api['foto'], api['id_barang'], api['id_tmp'],
            api['jumlah'], api['nama_barang'], api['nama_brand']);
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
                "Keranjang Barang Masuk",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            width: double.infinity,
            child: MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                Navigator.pop(context);

                // jangan lupa di aktifkan
                Navigator.push(
                    // belum import
                    context,
                    MaterialPageRoute(builder: (context) => TambahKbm()));
              },
              child: Text(
                "Tambah",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: RefreshIndicator(
              child: loading
                  ? Center(
                      child: Text(
                        "Data Kosong",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: Card(
                            color: Color.fromARGB(255, 250, 248, 286),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: 64,
                                        minHeight: 64,
                                        maxWidth: 84,
                                        maxHeight: 84),
                                    child: Image.network(
                                      BaseUrl.path + x.foto.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ID " + x.id_barang.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                      ),
                                      Text(
                                        x.nama_barang.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                      ),
                                      Text(
                                        "Brand " + x.nama_brand.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                      ),
                                      Text(
                                        "Jumlah " + x.jumlah.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _prosesHapus(x.id_tmp);
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 20,
                                        color: Colors.red,
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: list.length,
                    ),
              onRefresh: _lihatData,
              key: _refresh,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(5),
            width: double.infinity,
            child: loading == true
                ? Text("")
                : MaterialButton(
                    onPressed: () {
                      // jangan lupa di aktifkan
                      Navigator.push(
                          // belum import
                          context,
                          MaterialPageRoute(
                              builder: (context) => TambahBm(_lihatData)));
                    },
                    color: Color.fromARGB(255, 41, 69, 91),
                    child: Text(
                      "Proses Data",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
          )
        ],
      ),
    );
  }
}
