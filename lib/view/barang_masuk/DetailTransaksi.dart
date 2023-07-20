import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projek1/model/BarangMasukModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:projek1/Loading.dart';
import 'package:projek1/model/api.dart';

import '../../model/TransaksiMasukModel.dart';

class DetailTransaksi extends StatefulWidget {
  final VoidCallback reload;
  final TransaksiMasukModel model;
  DetailTransaksi(this.model, this.reload);

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  // identifi variable
  var loading = false;
  final list = [];
  Future<void>? _launched;
  late Uri _urlpdf =
      Uri.parse(BaseUrl.urlBaBm + widget.model.id_transaksi.toString());

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  // getpref
  getPref() async {
    _lihatData();
  }

  // lihatdata
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse(BaseUrl.urlDetailTBM + widget.model.id_transaksi.toString()));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = BarangMasukModel(api['foto'], api['jumlah_masuk'],
            api['nama_barang'], api['nama_brand']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  // louncbrowser
  Future<void> _lauchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
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
              child: Text(
                "Transaksi #" + widget.model.id_transaksi.toString(),
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: RefreshIndicator(
                  child: loading
                      ? Loading()
                      : ListView.builder(
                          itemBuilder: (context, i) {
                            final x = list[i];
                            return Container(
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
                                          x.nama_barang.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                        Text(
                                          "Barand " + x.nama_brand.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                        Text(
                                          "Jumlah " + x.jumlah_masuk.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              margin: EdgeInsets.all(5),
                            );
                          },
                          itemCount: list.length,
                        ),
                  onRefresh: _lihatData)),
          Flexible(
              child: loading == true
                  ? Text("data")
                  : Column(
                      children: [
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(children: <Widget>[
                              ListTile(
                                title: Text("Keterangan"),
                              ),
                              ListTile(
                                title: Text(
                                  widget.model.keterangan.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ]),
                            TableRow(children: <Widget>[
                              ListTile(
                                title: Text("Tujuan Transaksi"),
                              ),
                              ListTile(
                                title: Text(
                                  widget.model.tujuan.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ]),
                            TableRow(children: <Widget>[
                              ListTile(
                                title: Text("Total Barang Masuk"),
                              ),
                              ListTile(
                                title: Text(
                                  widget.model.total_item.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          onPressed: () {
                            _launched = _lauchInBrowser(_urlpdf);
                          },
                          color: Color.fromARGB(255, 41, 69, 91),
                          child: Text(
                            "Buat BA",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ))
        ],
      ),
    );
  }
}
