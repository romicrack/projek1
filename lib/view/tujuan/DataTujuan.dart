import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projek1/Loading.dart';
import 'package:projek1/model/TujuanModel.dart';
import 'package:projek1/view/tujuan/TambahTujuan.dart';

import '../../model/api.dart';

class DataTujuan extends StatefulWidget {
  @override
  State<DataTujuan> createState() => _DataTujuanState();
}

class _DataTujuanState extends State<DataTujuan> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  getPref() {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(BaseUrl.urlDataT));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = TujuanModel(api['id_tujuan'], api['tipe'], api['tujuan']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  // proses hapus
  _prosesHapus(String id) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusTujuan), body: {"id_tujuan": id});
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

  // dialoghapus
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
              child: Text(
                "Data Tujuan",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahTujuan(_lihatData),
              ));
        },
        child: Icon(Icons.add),
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
                    margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: Card(
                      color: Color.fromARGB(255, 250, 248, 246),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(x.tujuan.toString()),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      // edit
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      // hapus
                                      _prosesHapus(x.id_tujuan);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
