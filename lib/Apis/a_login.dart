// ignore_for_file: avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings, non_constant_identifier_names



import 'package:http/http.dart' as http;
import 'package:vil_presensi_0/Models/m_dept.dart';

import '../Cfg/svr.dart';
import '../Models/m_create_user.dart';
import '../Models/m_login.dart';
import 'eksepsion.dart'; 


class ApiLogin{

  Svr svr = Svr();
  
  // Login
  Future<MLogin?> login(var data, Map<String, String> headers ) async {   
      try{
      print('headers: $headers');
        var res = await http.post( Uri.parse( svr.login() ), headers: headers, body: data );   
        // print('svr.logn: ${svr.login()}'); 
        if(res.statusCode == 200){ 
          print('DON:: ${svr.login()} res.statusCode ${ res.statusCode}  res.body ${ res.body}');  
          final mLogin = mLoginFromJson(  res.body ); 
          return mLogin;
        }else{
          print('DON:: NULl res.statusCode ${ res.statusCode}  res.body ${ res.body}'); 
          throw  Exception('Error Page ${ res.statusCode} ');
        }
      } 
      catch   (e){
          print('e =>  $e');
          Ekseption(e: e).trow(); 
      }
      return null;  
  }
 

  // Check Registered Imei
  Future<MDept?> getDept(String dept_serial, Map<String, String> headers ) async {   
      String uri = svr.getDept( dept_serial  );
      try{ 
        var res = await http.get( Uri.parse( uri ), headers: headers, );    
        if(res.statusCode == 200){ 
          print('DON:: api $uri res.statusCode ${ res.statusCode}  res.body ${ res.body}');   
          final mDept = mDeptFromJson(res.body);
          return mDept;
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

  // Foto Profil
  // Future<MFotoProfil?> fotoProfil(String serial) async {  

  //     try{ 

  //       String url = svr.fotoProfil() + '?account_serial=$serial';
  //       var res = await http.get(Uri.parse( url ), headers: svr.headers() );

  //       print('svr.logn: ${svr.fotoProfil()}'); 
  //       if(res.statusCode == 200){ 
  //         print(' res.statusCode ${ res.statusCode}  res.body ${ res.body}');  
  //         final mFotoProfil = mFotoProfilFromJson(res.body); 
  //         return mFotoProfil;
  //       }else{
  //         return null;
  //       }
  //     } 
  //     catch   (e){
  //         // print('e =>  ${e}');
  //         throw  Exception(e.toString());
  //     }  
  // }


  // Post Crop Profil
  Future<String?> postCropProfil(var data, var headers ) async {   

      try{
        var res = await http.post( Uri.parse( svr.postCropProfil() ), headers: headers, body: data );   
        print('svr.postCropProfil : ${ res.statusCode} :  ${svr.postCropProfil()}');
        if(res.statusCode == 200){ 
          print(' res.statusCode ${ res.statusCode}  res.body ${ res.body}');  
          return  res.body;
        }else{
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

  //  Post Tensor Profil
  Future<CreaUser?> postCreateuser(var data,  Map<String, String>  headers ) async { 
      try{
        // var res = await http.post( Uri.parse( svr.postCreateuser() ), headers: svr.headers(), body: data );  
        var res = await http.post( Uri.parse( svr.postCreateuser() ), headers: headers, body: data );   
        print('DON:: svr.postCreateuser : ${svr.postCreateuser()}');
        if(res.statusCode == 200){ 
          print('DON:: res.statusCode ${ res.statusCode}  res.body ${ res.body}');  
          final creaUser = creaUserFromJson(res.body);
          return creaUser;
        }else{
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


}// End