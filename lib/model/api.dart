class BaseUrl {
  static String url = "https://dataromi.my.id/flutter_inven/api/";
  static String path = "https://dataromi.my.id/flutter_inven/images/";

  // jenis
  static String urlDataJenis = url + "jenis/data_jenis.php";
  static String urlTambahJenis = url + "jenis/tambah_jenis.php";
  static String urlEditJenis = url + "jenis/edit_jenis.php";
  static String urlHapusJenis = url + "jenis/delete_jenis.php";

  // tujuan
  static String urlDataT = url + "tujuan/data_tujuan.php";
  static String urlTambahTujuan = url + "tujuan/input_tujuan.php";
  static String urlEditTujuan = url + "tujuan/edit_tujuan.php";
  static String urlHapusTujuan = url + "tujuan/delete_tujuan.php";
  static String urlTujuanBM = url + "tujuan/tujuan_bm.php";

  // percobaan harus melihat hasil
  static String urlDataTBM = url + "tujuan/data_tujuan.php";
  static String urlDataTBK = url + "tujuan/data_tujuan.php";

  // brand
  static String urlDataBrand = url + "brand/data_brand.php";
  static String urlTambahBrand = url + "brand/tambah_brand.php";
  static String urlEditBrand = url + "brand/edit_brand.php";
  static String urlHapusBrand = url + "brand/delete_brand.php";

  // admin
  static String UrlDataAdmin = url + "admin/data_admin.php";
  static String UrlTambahAdmin = url + "admin/input_admin.php";
  static String UrlEditAdmin = url + "admin/update_admin.php";
  static String UrlHapusAdmin = url + "admin/delete_admin.php";

  // databarang
  static String urlDataBarang = url + "barang/data_barang.php";
  static String urlInputBarang = url + "barang/input_barang.php";
  static String urlUpdateBarang = url + "barang/update_barang.php";
  static String urlHapusBarang = url + "barang/delete_barang.php";

  // level
  static String UrlDataLevel = url + "level/data_level.php";

  // login
  static String urlLogin = url + "auth/login.php";

  // statistik
  static String urlCount = url + "statistik/count.php";

  // barang masuk
  static String urlTransaksiBM = url + "barang_masuk/transaksi_bm.php";
  static String urlHapusBM = url + "barang_masuk/delete_bm.php";
  static String urlBaBm = url + "laporan/ba_bm.php?i=";
  static String urlDetailTBM = url + "barang_masuk/data_barang_masuk.php?id=";
  static String urlCartBM = url + "barang_masuk/cart_bm.php?id=";
  static String urlDeleteCBM = url + "barang_masuk/delete_cartbm.php";
  static String urlInputCBM = url + "barang_masuk/input_cartbm.php";
  static String urlTambahBM = url + "barang_masuk/input_bm.php";

  // barang masuk
  static String urlTransaksiBK = url + "barang_keluar/transaksi_bk.php";
  static String urlHapusBK = url + "barang_keluar/delete_bk.php";
  static String urlBaBk = url + "laporan/ba_bk.php?i=";
  static String urlDetailTBK = url + "barang_keluar/data_barang_keluar.php?id=";
  static String urlCartBK = url + "barang_keluar/cart_bk.php?id=";
  static String urlDeleteCBK = url + "barang_keluar/delete_cartbk.php";
  static String urlTambahBK = url + "barang_keluar/input_bk.php";
  static String urlDataBr = url + "barang_keluar/data_br.php";
  static String urlInputCBK = url + "barang_keluar/input_cartbk.php";

  // laporan API

  static String urlBmPdf = url + "laporan/report_bm.php?t1=";
  static String urlBmCsv = url + "laporan/bm_csv.php?t1=";
  static String urlLaporanBm = url + "laporan/laporan_bm.php?tgl1=";
  static String urlBkPdf = url + "laporan/report_bk.php?t1=";
  static String urlBkCsv = url + "laporan/bk_csv.php?t1=";
  static String urlLaporanBk = url + "laporan/laporan_bk.php?tgl1=";
  static String urlStokPdf = url + "laporan/report_stok.php";
  static String urlStokCsv = url + "stok/stokcsv.php";
  static String urlDataStok = url + "stok/data_stok.php";
}
