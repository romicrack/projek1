import 'dart:convert';

class CountData {
  String? stok;
  String? jm;
  String? jk;

  CountData(this.stok, this.jk, this.jm);
  CountData.fromJson(Map<String, dynamic> json) {
    stok = json['stok'];
    jm = json['jm'];
    jk = json['jk'];
  }
}
