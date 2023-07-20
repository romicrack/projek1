class BarangKeluarModel {
  String? foto;
  String? nama_barang;
  String? nama_brand;
  String? jumlah_keluar;

  BarangKeluarModel(
      this.foto, this.jumlah_keluar, this.nama_barang, this.nama_brand);

  BarangKeluarModel.fromJson(Map<String, dynamic> json) {
    foto = json['foto'];
    nama_barang = json['nama_barang'];
    nama_brand = json['nama_brand'];
    jumlah_keluar = json['jumlah_keluar'];
  }
}
