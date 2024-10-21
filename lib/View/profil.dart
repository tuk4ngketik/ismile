// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, annotate_overrides, non_constant_identifier_names, sized_box_for_whitespace, avoid_print, unused_local_variable
 
 
 

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vil_presensi_0/Helper/myapp-attr.dart';
import 'package:vil_presensi_0/Helper/wg.dart';

import '../Cfg/Sess.dart';
import 'login.dart'; 

class Profil extends StatefulWidget{ 
  _Profil  createState() => _Profil();
}

class _Profil extends State<Profil>{ 
  
  Sess sess = Sess();
  String? email, nama_depan, nama_belakang, urlPhoto, division, dept ;
  late String ver  ;
  bool isLoad = false; 
  String? filePic, filePicCrop;
  MyappAttr myappAttr = MyappAttr();
  
  _getVer() async {
    final appinfo = await  myappAttr.appinfo();
    ver = appinfo['appVer'];
    print ('DON::realVersion $ver'); 
  }

  @override
  void initState() { 
    super.initState();
    sess.getSess('email').then((value) => setState(() => email = value,) );
    sess.getSess('nama_depan').then((value) => setState(() => nama_depan = value,) );
    sess.getSess('nama_belakang').then((value) => setState(() => nama_belakang = value,) );
    sess.getSess('urlPhoto').then((value) { print('urlPhoto $value'); setState(() => urlPhoto = value); } );  
    sess.getSess('division').then((value) {  setState(() => division = value); } );
    sess.getSess('dept').then((value) {  setState(() => dept = value); } );
    _getFilePic(); 
    _getVer();
  }

  Widget build(BuildContext context) {   
    return  (nama_depan == null)  ? const Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView( 
          children: [ 
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 100, 
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(100),
                borderRadius: BorderRadius.circular(50),  
                child: (urlPhoto == null) ? const Icon(Icons.person, size: 100,) 
                      :  Image.network(urlPhoto!, filterQuality: FilterQuality.low, 
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) { 
                                  return const Center(child: Text('😢 Image Not Found  😢'));
                                },   
                      ),   
              ),
            ),
            Container(height: 20,),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.indigo,),
              title: (nama_depan  == null ) ? const Text(''): Text("$nama_depan $nama_belakang"),
              // title: (nama_depan  == null ) ? const Text(''): Text("Agus Riadi"),
            ),
            
            // const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.indigo,),
              title: (email  == null) ? const Text(''):Text("$email") ,
            ),  
            
            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Colors.indigo,),
              // title: (userPostionTitle  == null ) ? const Text(''): Text("$userPostionTitle"),
              title: (dept  == null) ? const Text('') : Text("$dept") ,
            ),
            ListTile(
              leading: const Icon(Icons.star_half_sharp, color: Colors.indigo,),
              // title: (userPostionTitle  == null ) ? const Text(''): Text("$userPostionTitle"),
              title: (division  == null) ? const Text('') : Text("$division") ,
            ),
            Container(height: 20,), 
            _btnLogout(), 
            br(10),
            Center(
              child:   Text( 'Ver. $ver' ) ,
            ), 
          ],
        ),
      );
     
  }

  _getFilePic() async { 
     final dir = await  getTemporaryDirectory(); 
     setState(() {
      filePic = '${dir.path}/profil_vkool.jpg'; 
      filePicCrop = '${dir.path}/profil_crop.jpg';  
     });
  }
  
  Widget _btnLogout(){  
    return ElevatedButton(
            style: ElevatedButton.styleFrom(  
              shape: RoundedRectangleBorder(
                    borderRadius:   BorderRadius.circular(16.0),
                  ) , 
                  backgroundColor: Colors.indigo[900],   
            ), 
            onPressed: () async { 
              setState(() { isLoad = true;  }); 
              
              final dir = await getTemporaryDirectory(); 
              final f = File('${dir.path}/profil_crop.jpg'); 
              f.delete(); 
              // dir.deleteSync(recursive: true); 
              sess.destroy();      
              await Future.delayed(const Duration(milliseconds: 300));
              Get.offAll(const Login()); 
            },
            child: (isLoad == true) ? Container(height: 18,width: 18, child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)) 
                        : const Text('Logout', style: TextStyle(fontSize: 18, color: Colors.white),),
          );
  }

}