// ignore_for_file: avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings



import 'package:http/http.dart' as http; 
import 'package:vil_presensi_0/Models/m_kehadiran.dart';

import '../Cfg/svr.dart';
import 'eksepsion.dart'; 
class ApiKehadiran{

  Svr svr = Svr();
  
  
  // Kehadiran curr month 
  Future<MKehadiran?> getKehadiranSevent(String nik, String month, String ket, Map<String, String> headers ) async {  
      try{ 
      String uri = svr.getKehadiranSevent(nik, month, ket);
        var res = await http.get( Uri.parse( uri ), headers: headers, );     
        if(res.statusCode == 200){ 
          // print('DON:: $uri res.statusCode : ${ res.statusCode} res.body:${ res.body}'); 
          final r = mKehadiranFromJson(res.body);  
          return r;
        }else{
          print('DON:: NULL res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        } 
      } 
      catch   (e){
          print('e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }
  // Kehadiran curr month 
  Future<MKehadiran?> getKehadiran(String nik, String month, String ket, Map<String, String> headers ) async {  
      try{ 
      String uri = svr.getKehadiran(nik, month, ket);
        var res = await http.get( Uri.parse( uri ), headers: headers, );     
        if(res.statusCode == 200){ 
          // print('DON:: $uri res.statusCode : ${ res.statusCode} res.body:${ res.body}'); 
          final r = mKehadiranFromJson(res.body);  
          return r;
        }else{
          print('DON:: NULL res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        } 
      } 
      catch   (e){
          print('e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }
  
 

}// End