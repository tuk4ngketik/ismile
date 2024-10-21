

// ignore_for_file: non_constant_identifier_names

class Svr{ 
  // Key
  final String targetpath = 'c2lzdGVtZ2FyYW5zaS5jb20vc2l0ZS9hcGlfcHJlc2Vuc2k=';
  final String apikey  = 'dmtvb2xJRHByZXNlbnNp';  
  
  String host = 'https://sistemgaransi.com/site/api_presensi';  
  // String host = 'http://10.0.1.112/vkool-faces-demo'; 
  String getHost() => host;
  // String serviceHost = 'http://192.168.11.87:5000';      // PC lokal
  // String serviceHost = 'http://10.0.1.134:5000';         // linux - dev / lapotop
  // String serviceHost = 'http://192.168.0.210:8005';      // linux - prod / IP Local
  String serviceHost = 'http://203.174.11.166:8005';        // linux - prod / IP Public
  
  // Service
  String postCreateuser() => '$serviceHost/createuser';

  String postDistancebase64() => '$serviceHost/distancebase64';


  // LOGIN    
  String login() => '$host/login.php';
  // Divisi & Dept 
  String getDept(String dept_serial) => '$host/get_dept.php?dept_serial=$dept_serial';

  // Imei    
  // return checkImei : msg = "Ponsel tidak valid | Absen | Insert"
  String checkImei(String acc_serial, String imei) => '$host/get_check_imei.php?account_serial=$acc_serial&imei=$imei';
  String insertImei() => '$host/post_insert_imei.php';

  // Foto Profil    
  String fotoProfil() => '$host/login_cek_profil.php'; 
  
  String postCropProfil() => '$host/post_crop_profil.php';

  String getLokasiKerja() => '$host/get_lokasi_kerja.php'; 
  String getLokasiKerjaDefault(String company_branch_serial) => '$host/get_lokasi_kerja_default.php?cb_serial=$company_branch_serial'; 

  String getStatusAbsen(String nik, String thnblntgl) => '$host/get_status_checkin.php?nik=$nik&date=$thnblntgl'; 

  String postCheckin() => '$host/post_checkin.php'; 
  String postUpdateCheckout() => '$host/post_checkout_update.php'; 

  String getKehadiran(String nik, String month, String ket) => '$host/get_kehadiran.php?nik=$nik&month=$month&ket=$ket'; 
  String getKehadiranSevent(String nik, String month, String ket) => '$host/get_kehadiran_sevent.php?nik=$nik&month=$month&ket=$ket'; 
 

   
  
}