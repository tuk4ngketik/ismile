// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'package:vil_presensi_0/Models/m_lokasi_kerja_default.dart';
import 'package:vil_presensi_0/Models/m_status_absen.dart';

import '../Cfg/svr.dart';
import '../Models/m_distance.dart';
import '../Models/m_lokasi_kerja.dart';
import 'eksepsion.dart'; 

class ApiDistance{

  Svr svr = Svr(); 
  
  // Toggle Btn Absen
  Future<MStatusAbsen?> getStatusAbsen(String nik, String date, Map<String, String> headers ) async {   
      String uri = svr.getStatusAbsen(nik, date);
      try{ 
        var res = await http.get( Uri.parse( uri ), headers: headers, );    
        if(res.statusCode == 200){ 
          // print('DON:: MStatusAbsen   $uri res.statusCode ${ res.statusCode}  res.body ${ res.body}');   
          final mStatusAbsen = mStatusAbsenFromJson(res.body);
          return mStatusAbsen;
        }
        else{   
          // print('DON:: NULl res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        }  
      } 
      catch   (e){  
          // print('e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }
  
  // Get Lokasi Kerja Anywhere
  Future<MLokasiKerja?> lokasiKerja(String serial_acc, Map<String, String> headers ) async {   
      String uri = svr.getLokasiKerja();
      try{ 
        var res = await http.get( Uri.parse( '$uri?account_serial=$serial_acc' ), headers: headers, );    
        if(res.statusCode == 200){ 
          // print('DON:: lokasiKerja $uri res.statusCode ${ res.statusCode}  res.body ${ res.body}');   
          final mLokasiKerja = mLokasiKerjaFromJson(res.body);
          return mLokasiKerja;
        }
        else{   
          // print('DON:: NULl res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        }  
      } 
      catch   (e){  
          // print('e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }

  // Get Lokasi Kerja Default
  Future<MLokasiKerjaDefault?> lokasiKerjaDefault(String cb_serial, Map<String, String> headers ) async {   
      String uri = svr.getLokasiKerjaDefault(cb_serial);
      try{ 
        var res = await http.get( Uri.parse(uri), headers: headers) ;    
        if(res.statusCode == 200){ 
          // print('DON:: MLokasiKerjaDefault $uri res.statusCode ${ res.statusCode}  res.body ${ res.body}');   
          final mLokasiKerjaDefault = mLokasiKerjaDefaultFromJson(res.body);
          return mLokasiKerjaDefault;
        }
        else{   
          // print('DON:: NULl res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        }  
      } 
      catch   (e){  
          print('DON:: e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }
 
  // recog
  Future<MDistance?> postDistancebase64(var data, Map<String, String> headers ) async {   
      try{ 
        var res = await http.post( Uri.parse( svr.postDistancebase64() ), headers: headers, body: data );   
        if(res.statusCode == 200){  
          // print('DON:: postDistancebase64 ${svr.postDistancebase64()} - res.statusCode: ${ res.statusCode} - res.body: ${ res.body}');  
          final mDistance = mDistanceFromJson(res.body);
          return mDistance;
        }else{
          // print('don:: postDistancebase64  res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        }
      } 
      catch   (e){
          // print('e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }

}