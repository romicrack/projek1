import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:projek1/model/BrandModel.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'dart:async';

import '../../model/api.dart';
import '../../model/jenisModel.dart';

class TambahBarang extends StatefulWidget {
  final VoidCallback reload;
  TambahBarang(this.reload);

  @override
  State<TambahBarang> createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  // focusnode
  FocusNode myFocusNode = FocusNode();
  String? barang, jenisB, brandB;
  final _key = GlobalKey<FormState>();
  File? _imageFile;
  final image_picker = ImagePicker();
  _pilihGalerry() async {
    final image = await image_picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        print("no Image Selected");
      }
    });
  }

  // metode kamera
  _pilihCamera() async {
    final image = await image_picker.pickImage(
        source: ImageSource.camera, maxHeight: 1920, maxWidth: 1080);
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
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
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
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<BrandModel> listOfBrand = items.map<BrandModel>((json) {
        return BrandModel.fromJson(json);
      }).toList();
      return listOfBrand;
    } else {
      throw Exception('gagal');
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

  // simpan
  Simpan() async {
    try {
      var stream =
          // DelegatingStream.typed tidak bisa digunakan jadi saya ubah ke Stream.castFrom
          http.ByteStream(Stream.castFrom(_imageFile!.openRead()));
      var length = await _imageFile!.length();
      // seharusnya urlTambahBarang tapi saya ubah ke urlInputBarang
      var uri = Uri.parse(BaseUrl.urlInputBarang);
      var request = http.MultipartRequest("POST", uri);

      // request
      request.fields['nama'] = barang!;
      request.fields['brand'] = brandB!;
      request.fields['jenis'] = jenisB!;
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
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // add dialogfilefoto
  dialogFileFoto() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Upload Foto",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Silahkan Pilih Sumber File",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              _pilihCamera();
                            },
                            child: FaIcon(FontAwesomeIcons.camera, size: 50),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          InkWell(
                            onTap: () {
                              _pilihGalerry();
                            },
                            child: FaIcon(
                              FontAwesomeIcons.images,
                              size: 50,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Icon(
        CupertinoIcons.camera_viewfinder,
        size: 100,
      ),
    );
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
                "Tambah Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Form(
          key: _key,
          child: ListView(padding: EdgeInsets.all(16.0), children: <Widget>[
            Text(
              "Foto Barang",
              style: TextStyle(fontSize: 18),
            ),
            Container(
              width: double.infinity,
              height: 150,
              child: InkWell(
                onTap: () {
                  dialogFileFoto();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile!,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan Isi Nama Barang";
                }
              },
              onSaved: (e) => barang = e,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                  labelText: "Nama Barang",
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 32, 54, 70)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 32, 54, 70)))),
            ),
            SizedBox(
              height: 10,
            ),
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
                        jenisB = _currentJenis!.id_jenis;
                      });
                    },
                    isExpanded: true,
                    hint: Text(
                      jenisB == null
                          ? "pilih jenis"
                          : _currentJenis!.nama_jenis.toString(),
                    ),
                  )),
                );
              },
            ),
            SizedBox(
              height: 29,
            ),
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
                          brandB = _currentBrand!.id_brand;
                        });
                      },
                      isExpanded: true,
                      hint: Text(
                        brandB == null
                            ? "pilih brand"
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
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            )
          ])),
    );
  }
}
