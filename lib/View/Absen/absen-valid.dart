// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, avoid_print, must_be_immutable, file_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:vil_presensi_0/Cfg/css.dart';
import 'package:vil_presensi_0/Helper/func.dart'; 
import 'package:vil_presensi_0/Helper/wg.dart';
import 'package:vil_presensi_0/View/absen.dart';
import 'package:vil_presensi_0/View/home.dart'; 

import '../../Apis/a_checkin.dart'; 

class AbsenValid extends StatefulWidget{
  final headers;
  final postData;
  final double hasilKalikulasiFace;
  final Uint8List imageCaptured;
  final Uint8List imageCapturedCrop;
  
  const AbsenValid({super.key,required this.headers,required this.postData, required this.hasilKalikulasiFace ,required this.imageCaptured, required this.imageCapturedCrop});
  
  @override
  _AbsenValid createState() => _AbsenValid();
}

class _AbsenValid extends State<AbsenValid>{ 
  Apicheck apicheck = Apicheck();
  bool isLoad = false;
  
  String jamAbsen(){
    // final datetime = DateTime.parse('${widget.postData['ponsel_time']}');
    final datetime = DateTime.now();
    String tbt = convertTbt(datetime);
    String jmd = convertJmd(datetime);
    return '$tbt  $jmd';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( 
      //   title: const Text('Absen Berhasil'),
      // ), 
      appBar:  appbar0(), 
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Column( 
                  // padding: const EdgeInsets.all(10),
                  children: [
                    br(20),
                    const Icon(Icons.check_box, size: 40, color: Colors.indigo,),  
                    // br(20),
                  // Text('${widget.postData['ponsel_time']}', style: Css.jamInOut ),   
                  Text('Terverifikasi', style: Css.jamInOut ),   
                  Text( jamAbsen(), style: Css.jamInOut ),   
                  Expanded(
                    child:  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo), 
                        borderRadius: const BorderRadius.all(Radius.circular(5)), 
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.memory(widget.imageCaptured,fit: BoxFit.cover,  )
                    ), 
                  ),
                  br(20),   
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon( 
                        onPressed: ()  {    
                          Get.offAll( Absen(resolution: 'Low', headers: widget.headers, postData: widget.postData)); 
                        },  
                        label: const Text('Batal', style: TextStyle(fontSize: 18),), 
                        icon:  const Icon(Icons.replay_outlined),   
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.indigo),
                          // padding: EdgeInsets.all(5)
                        )
                      ),
                      spasi(20),
                      OutlinedButton.icon( 
                        onPressed: () async { 
                          if( isLoad == true ){
                            // print('DON:: isload = $isLoad');
                            return  ;
                          }
                          bool? status;
                          final  serialCheckout =  '${widget.postData['serialCheckout']}'; 
                          status = (serialCheckout == '') ?  await _postcheckin() : await _updateCheckout(); 
                          (status == true ) 
                            ?  Get.offAll(()=> const Home())
                            : defaultDialogErrToHome('Terjadi Kesalahan');
                        },  
                        label: ( isLoad == true ) ? const Text('Load..', style: TextStyle(fontSize: 18),) : const Text('Kirim', style: TextStyle(fontSize: 18),), 
                        icon: ( isLoad == true ) 
                          ? const SizedBox(height: 20, width: 20 ,child: CircularProgressIndicator(strokeWidth: 1,)) 
                          : const Icon(Icons.arrow_right_alt_rounded),   
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.indigo),
                          // padding: EdgeInsets.all(5)
                        )
                      ),
                    ],
                  ),
                  br(10), 
              
                ],),
        ),
      ),
    ); 
  }
  
  Future<bool?> _postcheckin()async {     
    setState((){  isLoad = true; });
    bool? status;
    //  postData['file_foto'] = '$imageCaptured';  
     widget.postData['file_foto'] = _base64img(  widget.imageCaptured );  
    //  print("DON:: _postcheckin ${widget.postData}"); 
     await apicheck.postCheckin( jsonEncode(widget.postData), widget.headers).then((v){ 
      status =  v!.status;  
     }) 
     .catchError((onError){  
        defaultDialogErrToHome('${onError.message}');  
        setState((){  isLoad = false; });
        print('${onError.message }');
    });
     return status;
  }
  
  Future<bool?> _updateCheckout()async {    
    setState((){  isLoad = true; });
    bool? status;
    //  postData['file_foto'] = '$imageCaptured';  
     widget.postData['file_foto'] = _base64img(  widget.imageCaptured );  
    //  print("DON:: _updateCheckout ${widget.postData}"); 
     await apicheck.updateCheckout( jsonEncode(widget.postData), widget.headers).then((v){ 
      status =  v!.status;  
     }) 
     .catchError((onError){  
        defaultDialogErrToHome('${onError.message}');  
        setState((){  isLoad = false; });
        print('${onError.message }');
    });
     return status;
  }
 
  String _base64img(Uint8List uint8List){ 
    String base64String = base64Encode(Uint16List.fromList(uint8List));
    return   base64String;
    // String header = "data:image/png;base64,";
    // return header + base64String;
  }

}

 