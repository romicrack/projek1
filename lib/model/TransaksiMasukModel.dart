class TransaksiMasukModel {
  String? id_transaksi;
  String? tujuan;
  String? total_item;
  String? tgl_transaksi;
  String? keterangan;

  TransaksiMasukModel(this.id_transaksi, this.keterangan, this.tgl_transaksi,
      this.total_item, this.tujuan);

  TransaksiMasukModel.fromJson(Map<String, dynamic> json) {
    id_transaksi = json['id_transaksi'];
    tujuan = json['tujuan'];
    total_item = json['total_item'];
    tgl_transaksi = json['tgl_transaksi'];
    keterangan = json['keterangan'];
  }
}
