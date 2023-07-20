import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek1/Loading.dart';
import 'package:projek1/model/BrandModel.dart';
import 'package:projek1/model/api.dart';
import 'package:projek1/model/jenisModel.dart';
import 'package:projek1/view/brand/EditBrand.dart';
import 'package:projek1/view/brand/TambahBrand.dart';
import 'package:projek1/view/jenis/EditJenis.dart';
import 'package:projek1/view/jenis/TambahJenis.dart';
// import 'package:cupertino_icons/cupertino_icons.dart';
import 'dart:convert';

class DataBrand extends StatefulWidget {
  const DataBrand({Key? key}) : super(key: key);

  @override
  State<DataBrand> createState() => _DataBrandState();
}

class _DataBrandState extends State<DataBrand> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  // metode pengambilan data dan menampilkan di dasboard
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlDataBrand));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new BrandModel(api['id_brand'], api['nama_brand']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  // Metode hapus
  ProsesHapus(String id) async {
    final response = await http.post(
      Uri.parse(BaseUrl.urlHapusBrand),
      body: {"id_brand": id},
    );

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

  dialogHapus(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
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

  // finish metode hapus

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
                "Data Brand Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  print(tambah Jenis);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => TambahBrand(_lihatData))));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
      ),
// body
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
                            title: Text(x.nama_brand.toString()),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    //edit
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditBrand(x, _lihatData),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    // Delete
                                    onPressed: () {
                                      ProsesHapus(x.id_brand);
                                    },
                                    icon: const Icon(Icons.delete))
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
