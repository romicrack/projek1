class TujuanModel {
  String? id_tujuan;
  String? tujuan;
  String? tipe;

  TujuanModel(this.id_tujuan, this.tipe, this.tujuan);
  TujuanModel.fromJson(Map<String, dynamic> json) {
    id_tujuan = json['id_tujuan'];
    tujuan = json['tujuan'];
    tipe = json['tipe'];
  }
}
