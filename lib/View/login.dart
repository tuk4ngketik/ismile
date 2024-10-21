// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, annotate_overrides, avoid_print, no_leading_underscores_for_local_identifiers, unused_local_variable, unused_element, body_might_complete_normally_nullable, non_constant_identifier_names
 

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vil_presensi_0/Apis/a_imei.dart'; 

import '../Apis/a_login.dart';
import '../Cfg/Sess.dart';
import '../Cfg/css.dart';
import '../Helper/myapp-attr.dart';
import '../Helper/wg.dart';
import '../Service/crop_profil.dart';
import 'home.dart';

class Login extends StatefulWidget{
  const Login({super.key}); 
  _Login createState() => _Login();
}

class _Login extends State<Login>{ 

  ApiLogin apiLogin = ApiLogin();
  Sess sess = Sess();
  bool isLoad = false;
  final _formKey = GlobalKey<FormState>();
  String? _nik, _passwd; 
  late Directory dir;
  MyappAttr myappAttr = MyappAttr();  
  Map<String, String> headers = {};
  String? imei;
  ApiImei apiImei = ApiImei();
  bool visiblePass = false;

  initState(){
    _getHeaders (); 
    _prepareDir(); 
    _getImei(); 
    super.initState();
  }

  _prepareDir  () async =>  dir = await getApplicationCacheDirectory();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(),
      body: Center(
        
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(10),
          // height: 250,
          child: SingleChildScrollView(
              child: Form(
                key : _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [  
                    Container(
                      height: 200, 
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 0.1)
                      ),
                      // child: const Center(child: Text('Logo', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),))
                      child: Image.asset('imgs/vil-grup-logo.png'),
                    ),                
                    br(20),
              
                    //Email  
                    TextFormField(    
                      style: const TextStyle(  fontWeight: FontWeight.normal, fontSize: 19    ),
                      // initialValue: '234333',
                         onSaved:(newValue) => _nik = newValue, 
                        decoration:  InputDecoration(   
                          enabledBorder:   Css.formInputEnable,
                          border: Css.formInputBorder, 
                          focusedBorder: Css.formInputFocus, 
                          errorBorder: Css.formInputError, 
                          prefixIcon: const Icon(Icons.email, color: Colors.black), 
                          label: textColor('Nik', Colors.black), 
                          hintText: 'NIK anda', 
                          filled: true,
                          fillColor: Colors.white54,
                        ), 
                        validator: (value) {
                          if(value!.isEmpty){ 
                            return 'Lengkapi NIK';
                          }
                          if (GetUtils.isNum( value ) == false ){         
                            return 'NIK tidak valid';
                          }
                          return null;
                        }, 
                    ),
                    br(15),
                    
                    //Password 
                    TextFormField(   
                      obscureText: (visiblePass ==  false) ? true : false,
                      // initialValue: '130780',
                      style: const TextStyle(  fontWeight: FontWeight.normal, fontSize: 19    ),
                      onSaved:(newValue) => _passwd = newValue, 
                        decoration:  InputDecoration(   
                          enabledBorder:   Css.formInputEnable,
                          border: Css.formInputBorder, 
                          focusedBorder: Css.formInputFocus, 
                          errorBorder: Css.formInputError, 
                          prefixIcon: const Icon(Icons.password_sharp, color: Colors.black), 
                          label: textColor('Kata sandi', Colors.black),
                          hintText: 'Masukkan kata sandi', 
                          filled: true,
                          fillColor: Colors.white54,
                            suffixIcon: IconButton(
                              onPressed: (){ 
                                setState(() {
                                  visiblePass =  !visiblePass;
                                  print('visiblePass $visiblePass' );
                                });
                              }, 
                              icon: (visiblePass ==  true) ? const Icon(Icons.visibility_off_sharp, color: Colors.black) : const Icon(Icons.visibility, color: Colors.black,)
                            )
                        ), 
                        validator: (value) {
                          if(value!.isEmpty){ 
                            return 'Lengkapi kata sandi';
                          } 
                          return null;
                        }, 
                    ),br(15), 
                                  
                    Container(
                      // color: Colors.yellow,
                        decoration: const BoxDecoration(
                          color: Colors.indigo, 
                          // color: Colors.black, 
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        height: 55,
                        child:  Center(
                          child: TextButton( 
                              onPressed: (){    
                                if (_formKey.currentState!.validate() == false) { return; }
                                _formKey.currentState!.save();
                                _login();
                              },
                              child:  Center(
                                child: ( isLoad == true ) 
                                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2, ) 
                                  : const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white),)
                                  // : const Icon(Icons.send)
                              ),
                            ),
                        )
                      ),
                          
                ],),
              ),
            ),
        ),
      ),
    );
  } 
 
  _getHeaders ()   { 
     myappAttr.retHeader().then((v){
      setState(() => headers = v );  
     });
  }
  
  _login()   { 
    setState(() =>  isLoad = true ); 
    var  data = {
      'nik' : _nik,
      'passwd' : _passwd
    };
    
    apiLogin.login( jsonEncode(data),  headers).then((v) async {
      if(v!.status ==  false){
        defaultDialogErr('${v.message}');
        setState(() =>  isLoad = false );
        return;
      } 
      
      var data = v.data;
      if( data ==  null){
        defaultDialogErr('Akun belum terdaftar');
        setState(() =>  isLoad = false );
        return;
      }  

      bool? checkImei = await _checkRegisteredImei('${data.serial}'); 
      if(checkImei == false){
        return;
      }
      
      // String? nik = data.nik;
      sess.setSess('status_app', 'login');
      sess.setSess('nik', '${data.nik}');
      sess.setSess('serial', '${data.serial}');
      sess.setSess('nama_depan', '${data.namaDepan}');
      sess.setSess('nama_belakang', '${data.namaBelakang}'); 
      sess.setSess('email', '${data.email}'); 
      sess.setSess('tgl_lahir', '${data.tglLahir}'); 
      sess.setSess('_division', '${data.division}'); 
      sess.setSess('jabatan', '${data.jabatan}'); 
      sess.setSess('tgl_lahir', '${data.tglLahir}');  
      sess.setSess('imei', '$imei');     
            sess.setSess('company_serial', '${data.companySerial}');  
            sess.setSess('company_branch_serial', '${data.companyBranchSerial}'); 
            
      var _split = data.fileLocation!.split('/');

      // Get Dept
      var dept = await apiLogin.getDept('${data.deptSerial}', headers);
      var dataDept = dept!.data;  
      sess.setSess('division', '${dataDept!.divisionName}'); 
      sess.setSess('dept', '${dataDept.deptName}'); 
      // print("DON:: Dept ${dataDept!.divisionName}");
      // print("DON:: Dept ${dataDept.deptName}");

      String urlPhoto = 'https://${_split[3]}/${_split[4]}/${_split[5]}/${_split[6]}/${_split[7]}/${data.fileName}' ; 
      sess.setSess('urlPhoto', urlPhoto);    
      
      final cropProfil = CropProfil(urlFoto: urlPhoto); 
      cropProfil.getPicture();
      await cropProfil.deteksi();  
      String? img_crop = cropProfil.getbase64ImageCrop;


        // upload img_crop to Py-Service 
        var bytes = utf8.encode('$_nik'); // data being hashed 
        var _sha1 = sha1.convert(bytes);
        print("DON:: as bytes: ${_sha1.bytes}\n sha1 as hex string: $_sha1");
        var dataToPy = {'nik' :  '$_sha1', 'img_crop' : img_crop };     
        await apiLogin.postCreateuser(dataToPy, headers).then((v){

          bool? status = v!.status;
          String? msg  = v.message;

          if(status == false && msg != 'success' ){
            defaultDialogErr(msg!);
            setState(() =>  isLoad = false );
            return;
          }

            // Login Sukses
            Get.off( const Home() );
            // setState(() =>  isLoad = false );

        }) 
        .catchError((onError){
          setState(() =>  isLoad = false );
          defaultDialogErr('${onError.message}');
          // print('DON:: ${onError.message }');
          // print('DON:: apiLogin.postCreateuser(data) ');
        }); 
 
    })
    .catchError((onError){
      setState(() =>  isLoad = false );
      defaultDialogErr('${onError.message}');
      // print('DON:: ${onError.message }');
    });
  } 

  Future<void> _getImei() async {
    String platformVersion= '';
    try {
      platformVersion = await FlutterDeviceImei.instance.getIMEI() ??
          'Unknown platform version';
          print('DON:: imei $platformVersion');
          setState(() {
            imei = platformVersion;
          }); 
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    } 
    // if (!mounted) return ;   
  }
 
  Future<bool?> _checkRegisteredImei(String account_serial) async {
     var data = await apiImei.checkImei(account_serial, imei!, headers);
     bool? status = data!.status;
     if(status == false ){
      setState(() =>  isLoad = false );
      defaultDialogErr('${data.message}'); 
      return false;
     }
     String? msg = data.message;
     if(msg != 'Valid'){
      setState(() =>  isLoad = false );
      defaultDialogErr('Device tidak valid'); 
      return false;
     }
     return true;
  }

}