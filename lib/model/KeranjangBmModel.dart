class KeranjangBModel {
  String? id_tmp;
  String? id_barang;
  String? foto;
  String? nama_barang;
  String? nama_brand;
  String? jumlah;

  KeranjangBModel(this.foto, this.id_barang, this.id_tmp, this.jumlah,
      this.nama_barang, this.nama_brand);

  KeranjangBModel.fromJson(Map<String, dynamic> json) {
    id_tmp = json['id_tmp'];
    id_barang = json['id_barang'];
    foto = json['foto'];
    nama_barang = json['nama_barang'];
    nama_brand = json['nama_brand'];
    jumlah = json['jumlah'];
  }
}
