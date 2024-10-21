// ignore_for_file: avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings



import 'package:http/http.dart' as http;
import 'package:vil_presensi_0/Models/m_all.dart';

import '../Cfg/svr.dart';
import 'eksepsion.dart'; 
class Apicheck{

  Svr svr = Svr();
  
  
  // checkin n checkput
  Future<MAll?> postCheckin(var data, Map<String, String> headers ) async {   
      try{ 
        var res = await http.post( Uri.parse( svr.postCheckin() ), headers: headers, body: data );   
        // print('DON:: svr.postCheckin: ${svr.postCheckin()}'); 
        if(res.statusCode == 200){ 
          // print('DON:: postCheckin ${svr.postCheckin()} res.statusCode : ${ res.statusCode} res.body:${ res.body}'); 
          final mAll = mAllFromJson(res.body);  
          return mAll;
        }else{
          // print('DON:: NULl res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        } 
      } 
      catch   (e){
          print('e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }
  
//  postUpdateCheckout
  Future<MAll?> updateCheckout(var data, Map<String, String> headers ) async {   
      try{ 
        var res = await http.post( Uri.parse( svr.postUpdateCheckout() ), headers: headers, body: data );   
        if(res.statusCode == 200){ 
          // print('DON:: postUpdateCheckout ${svr.postUpdateCheckout()} res.statusCode : ${ res.statusCode} res.body:${ res.body}'); 
          final mAll = mAllFromJson(res.body);  
          return mAll;
        }else{
          // print('DON:: postUpdateCheckout res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
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