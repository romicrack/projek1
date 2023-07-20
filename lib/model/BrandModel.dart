class BrandModel {
  String? id_brand;
  String? nama_brand;
  BrandModel(this.id_brand, this.nama_brand);
  BrandModel.fromJson(Map<String, dynamic> json) {
    id_brand = json['id_brand'];
    nama_brand = json['nama_brand'];
  }
}
