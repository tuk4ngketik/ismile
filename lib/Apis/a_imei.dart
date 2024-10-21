// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:http/http.dart' as http;

import '../Cfg/svr.dart';
import '../Models/m_check_imei.dart';
// import '../Models/m_distance.dart';
// import '../Models/m_lokasi_kerja.dart';
import 'eksepsion.dart'; 

class ApiImei{

  Svr svr = Svr(); 
  
  // Check Registered Imei
  Future<MCheckImei?> checkImei(String serial_acc, String imei, Map<String, String> headers ) async {   
      String uri = svr.checkImei( serial_acc, imei );
      try{ 
        var res = await http.get( Uri.parse( uri ), headers: headers, );    
        if(res.statusCode == 200){ 
          print('DON:: api $uri res.statusCode ${ res.statusCode}  res.body ${ res.body}');   
          final mCheckImei = mCheckImeiFromJson(res.body);
          return mCheckImei;
        }
        else{   
          print('NULl res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        }  
      } 
      catch   (e){  
          print('e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }

  
  // Future<bool> insertImei(var data, Map<String, String> headers ) async {   
  //     try{ 
  //       var res = await http.post( Uri.parse( svr.insertImei() ), headers: headers, body: data );   
  //       // print('svr.logn: ${svr.postDistancebase64()}'); 
  //       if(res.statusCode == 200){ 
  //         print('DON:: ${svr.insertImei()}\n res.statusCode: ${ res.statusCode}\n res.body: ${ res.body}'); 
  //         print(object)

  //       }else{
  //         print('NULl res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
  //         throw  Exception('Error Page ${ res.statusCode} ');
  //       }
  //     } 
  //     catch   (e){
  //         print('e =>  $e');
  //         Ekseption(e: e).trow(); 
  //     }
  //     return null;  
  // }

}