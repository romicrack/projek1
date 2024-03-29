import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../../model/BarangModel.dart';
import '../../model/BrandModel.dart';
import '../../model/api.dart';
import '../../model/jenisModel.dart';
import 'package:flutter/services.dart';

class EditBarang extends StatefulWidget {
  // callback reload
  final VoidCallback reload;
  final BarangModel model;
  EditBarang(this.model, this.reload);

  @override
  State<EditBarang> createState() => _EditBarangState();
}

class _EditBarangState extends State<EditBarang> {
  // focusnode
  FocusNode myFocusNode = FocusNode();
  String? id_barang, nama, brand, jenis;
  final _key = GlobalKey<FormState>();
  File? _imageFile;
  final image_picker = ImagePicker();
  TextEditingController? txtBarang;
  setup() async {
    txtBarang = TextEditingController(text: widget.model.nama_barang);
    id_barang = widget.model.id_barang;
  }

  // pilih galeri
  _pilihGalery() async {
    final image = await image_picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);

    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        print("No Image Selected");
      }
    });
  }

  // pilih camera
  _pilihCamera() async {
    final image = await image_picker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        print("No Image Selected");
      }
    });
  }

  // jenis model
  JenisModel? _currentJenis;
  final String? linkJenis = BaseUrl.urlDataJenis;
  Future<List<JenisModel>> _fetchJenis() async {
    var response = await http.get(Uri.parse(linkJenis.toString()));
    print("hasil" + response.statusCode.toString());
    if (response.statusCode == 200) {
      // kemungkinan salah ada di jsonDecode karena sebelumnya menggunakan json.decode
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<JenisModel> listOfJenis = items.map<JenisModel>((json) {
        return JenisModel.fromJson(json);
      }).toList();
      return listOfJenis;
    } else {
      throw Exception('gagal');
    }
  }

  // brand model
  BrandModel? _currentBrand;
  final String? linkBrand = BaseUrl.urlDataBrand;
  Future<List<BrandModel>> _fetchBrand() async {
    var response = await http.get(Uri.parse(linkBrand.toString()));
    print("hasil" + response.statusCode.toString());
    if (response.statusCode == 200) {
      // kemungkinan salah ada di jsonDecode karena sebelumnya menggunakan json.decode
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<BrandModel> listOfBrand = items.map<BrandModel>((json) {
        return BrandModel.fromJson(json);
      }).toList();
      return listOfBrand;
    } else {
      throw Exception('gagal');
    }
  }

  // metode cek
  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      prosesUp();
    }
  }

  // prosesUp
  prosesUp() async {
    try {
      // saya ganti DelegatingStream.typed dengan Stream.castFrom
      var stream = http.ByteStream(Stream.castFrom(_imageFile!.openRead()));
      var length = await _imageFile!.length();
      var uri = Uri.parse(BaseUrl.urlEditBrand);
      var request = http.MultipartRequest("POST", uri);

      // request
      request.fields['id_barang'] = id_barang.toString();
      request.fields['nama'] = nama.toString();
      request.fields['jenis'] = jenis == null ? widget.model.id_jenis! : jenis!;
      request.fields['brand'] = brand == null ? widget.model.id_brand! : brand!;
      request.files.add(http.MultipartFile("foto", stream, length,
          filename: path.basename(_imageFile!.path)));

      // respon
      var respon = await request.send();
      if (respon.statusCode > 2) {
        print("berhasil upload");
        if (this.mounted) {
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
        }
      } else {
        print("gagal");
      }
    } catch (e) {
      if (noImgUp()) {
      } else {
        debugPrint(e.toString());
      }
    }
  }

  // noImgUp
  noImgUp() async {
    try {
      final respon =
          await http.post(Uri.parse(BaseUrl.urlEditBrand.toString()), body: {
        "id_barang": id_barang,
        "nama": nama,
        "brand": brand == null ? widget.model.id_brand! : brand!,
        "jenis": jenis == null ? widget.model.id_jenis! : jenis!,
      });

      final data = jsonDecode(respon.body);
      print(data);
      int code = data["success"];
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

  // doalog file foto
  dialogFileFoto() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Silahkan Pilih Sumber File",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _pilihCamera();
                      },
                      child: Text(
                        "Kamera",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    InkWell(
                      onTap: () {
                        _pilihGalery();
                      },
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
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
                "Edit Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Text("Foto Produk"),
            Container(
              width: double.infinity,
              height: 150,
              child: InkWell(
                  onTap: () {
                    dialogFileFoto();
                  },
                  child: _imageFile == null
                      ? Image.network(
                          BaseUrl.path + widget.model.foto.toString())
                      : Image.file(
                          _imageFile!,
                          fit: BoxFit.contain,
                        )),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtBarang,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan Isi Nama";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
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
              height: 20,
            ),

            // builder jenis
            FutureBuilder<List<JenisModel>>(
              future: _fetchJenis(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<JenisModel>> snapshot) {
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
                        .map((listJenis) => DropdownMenuItem(
                              child: Text(listJenis.nama_jenis.toString()),
                              value: listJenis,
                            ))
                        .toList(),
                    onChanged: (JenisModel? value) {
                      setState(() {
                        _currentJenis = value;
                        jenis = _currentJenis!.id_jenis;
                      });
                    },
                    isExpanded: true,
                    hint: Text(
                      jenis == null || jenis == widget.model.nama_jenis
                          ? widget.model.nama_jenis.toString()
                          : _currentJenis!.nama_jenis.toString(),
                    ),
                  )),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),

            // builder brand
            FutureBuilder<List<BrandModel>>(
                future: _fetchBrand(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<BrandModel>> snapshot) {
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
                          .map((listBrand) => DropdownMenuItem(
                                child: Text(listBrand.nama_brand.toString()),
                                value: listBrand,
                              ))
                          .toList(),
                      onChanged: (BrandModel? value) {
                        setState(() {
                          _currentBrand = value;
                          brand = _currentBrand!.id_brand;
                        });
                      },
                      isExpanded: true,
                      hint: Text(
                        brand == null || brand == widget.model.nama_brand
                            ? widget.model.nama_brand.toString()
                            : _currentBrand!.nama_brand.toString(),
                      ),
                    )),
                  );
                }),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
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
