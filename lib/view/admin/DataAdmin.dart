import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek1/model/AdminModel.dart';
import 'dart:convert';

import 'package:projek1/model/api.dart';
import 'package:projek1/view/admin/EditAdmin.dart';
import 'package:projek1/view/admin/TambahAdmin.dart';

import '../../Loading.dart';
// import '../../model/jenisModel.dart';
// import '../jenis/EditJenis.dart';

class DataAdmin extends StatefulWidget {
  const DataAdmin({super.key});

  @override
  State<DataAdmin> createState() => _DataAdminState();
}

class _DataAdminState extends State<DataAdmin> {
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
    final response = await http.get(Uri.parse(BaseUrl.UrlDataAdmin));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = AdminModel(
            api['id_admin'], api['nama'], api['username'], api['lvl']);
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
      Uri.parse(BaseUrl.UrlHapusAdmin),
      body: {"id_admin": id},
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
                "Data Admin",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  masuk ke tambah admin
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => TambahAdmin(_lihatData))));
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
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Card(
                      color: Color.fromARGB(255, 250, 248, 246),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(x.nama.toString()),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    //edit
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditAdmin(x, _lihatData),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    // Delete
                                    onPressed: () {
                                      ProsesHapus(x.id_admin);
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
