// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class Sess{
 
    setSess(String key, String value ) async {
      final prefs =  await SharedPreferences.getInstance(); 
      prefs.setString(key, value); 
    }
 

    Future<String?> getSess(String key) async {
      final prefs =  await SharedPreferences.getInstance(); 
      return prefs.getString(key);
    }

    remove(String key) async {
      final prefs =  await SharedPreferences.getInstance(); 
      prefs.remove(key); 
    }

    destroy() async {
      final prefs =  await SharedPreferences.getInstance(); 
      prefs.clear();
    } 
        
        
      // sess.setSess('nama_depan', '${data!.namaDepan}');
      // sess.setSess('nama_belakang', '${data.namaBelakang}'); 
      // sess.setSess('email', '${data.email}'); 
      // sess.setSess('tgl_lahir', '${data.tglLahir}'); 
      // sess.setSess('_division', '${data.division}'); 
      // sess.setSess('jabatan', '${data.jabatan}'); 
      // sess.setSess('tgl_lahir', '${data.tglLahir}'); 
      // sess.setSess('file_name', '${data.fileName}');   
      // sess.setSess('file_name_ori', '${data.fileNameOri}');   
      // sess.setSess('file_location', '${data.fileLocation}');

}