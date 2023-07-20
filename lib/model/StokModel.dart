class StokModel {
  String? no;
  String? id_barang;
  String? nama_barang;
  String? nama_jenis;
  String? nama_brand;
  String? stok;

  StokModel(
    this.no,
    this.id_barang,
    this.nama_barang,
    this.nama_brand,
    this.nama_jenis,
    this.stok,
  );

  StokModel.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    id_barang = json['id_barang'];
    nama_barang = json['nama_barang'];
    nama_brand = json['nama_brand'];
    nama_jenis = json['nama_jenis'];
    stok = json['stok'];
  }
}
