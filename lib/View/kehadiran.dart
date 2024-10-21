// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, annotate_overrides, non_constant_identifier_names, unused_element, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vil_presensi_0/Apis/a_kehadiran.dart';
import 'package:vil_presensi_0/Cfg/Sess.dart';
import 'package:vil_presensi_0/Helper/func.dart';
import 'package:vil_presensi_0/Helper/myapp-attr.dart';
import 'package:vil_presensi_0/Helper/wg.dart';
import 'package:vil_presensi_0/View/avatar_header.dart';
 

class Kehadiran extends StatefulWidget{ 
  _Kehadiran  createState() => _Kehadiran();
}

class _Kehadiran extends State<Kehadiran>{ 
  
  final month = getCurrMonth();
  
  ApiKehadiran apiKehadiran = ApiKehadiran();
  MyappAttr myappAttr = MyappAttr();
  Sess sess = Sess();

  Map<String, String> headers = {};
  String? nik, nama_depan, nama_belakang, dept, division;
  File? fCrop;  
  late List<Map<String, dynamic>> newList = []; 
  late List<MapEntry<dynamic, List<Map<String, dynamic>>>> myList = [];  
  bool isLoad =  true;

  _getKehadiran() async {
    headers = await myappAttr.retHeader();
    nik = await sess.getSess('nik'); 
    // print('DON:: _getKehadiranIn() $nik $headers');
    // IN
    // await apiKehadiran.getKehadiran(nik!, month, '', headers)                // Curent Month 
    final v = await apiKehadiran.getKehadiranSevent(nik!, month, '', headers)  // 7 hari kebelakang 
                      .catchError((onError){  
                          defaultDialogErr('${onError.message}');   
                          // print('DON:: ${onError.message }');
                      });    
      bool? status = v!.status;
      String? msg =  v.message;
      if(status ==  false){
        defaultDialogErr(msg!);
        return;
      } 

      var d = v.data; 
      if(d.isEmpty ){
        if (!mounted) { return;  } 
        setState(() =>  isLoad = false );
        return;
      }
       
      for (var el in d) {   
        final tgl = convertTbt( el.signDate! );
        final hari = convertHari( el.signDate! );
        final jam = convertJmd(el.signDate!); 
        final m = {  'hari' : hari, 'tgl' : tgl, 'jam' : jam, 'ket' : el.keterangan, 'foto' : el.fileFoto }; 
        if (!mounted) { continue;  } 
        setState(() => newList.add(m) );
        // newList.add(m);
      } 

      // print('DON:: newList $newList');s
       
      final groupedMap = groupBy(newList, (map) => map['tgl']);  
      myList = groupedMap.entries.toList() ;
      myList.reversed; 
      if (!mounted) { return;  } 
      setState(() =>  isLoad = false );
      // print('DON:: myList $myList');
    // },); 
  } 

 Map<K, List<Map<String, dynamic>>> groupBy<K>(
    List<Map<String, dynamic>> list,
    K Function(Map<String, dynamic>) keyFunction,
  ) {
    var map = <K, List<Map<String, dynamic>>>{};
    for (var element in list) {
      var key = keyFunction(element);
      if (!map.containsKey(key)) {
        map[key] = <Map<String, dynamic>>[];
      }
      map[key]!.add(element);
    }
    return map;
 }

  initState(){
    super.initState();  
    _getKehadiran();
    if (!mounted) { return;  } 
    sess.getSess('nama_depan').then((value) {  setState(() => nama_depan = value); } );
    sess.getSess('nama_belakang').then((value) {  setState(() => nama_belakang = value); } );
    sess.getSess('division').then((value) {  setState(() => division = value); } );
    sess.getSess('dept').then((value) {  setState(() => dept = value); } );
  }

  Widget build(BuildContext context) {
    // return const Center(child: Text("Kehadiran"),);
    return Container( 
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [ 
          br(20),
          AvatarHeader(namaDepan: nama_depan, namaBelakang: nama_belakang, dept: dept, division: division,),
          br(20),   
          // Center(child: Text( bulanTahun(), style: const TextStyle(fontSize: 20),),),
          const Center(child: Text( 'Data kehadiran', style: TextStyle(fontSize: 20),),),
          br(20),   
          Expanded(
            child: ( isLoad == true ) ? const Center(child: CircularProgressIndicator(),) 
            : (myList.isEmpty) ? const Center(child:Text('Belum ada data') ,)
            : ListView.builder(     
              // reverse: true,
              shrinkWrap: true,  
              itemCount: myList.length ,
              itemBuilder: (context, i) {
                final item = myList[i].key;
                final val = myList[i].value;
                return Card( 
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                       Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Column(
                          children: [
                            Text( '${val[0]['hari'] }', style: const TextStyle(fontSize: 15),),
                            Text( '$item', style: const TextStyle(fontSize: 17),),
                            // Text(  convertTbt(DateTime.parse('$item 00')), style: const TextStyle(fontSize: 20),),
                          ],
                        )
                       ),

                      // IN
                       Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child:  Column(children: [ 
                          Center(child: Text( '${val[0]['ket'] }', style: const TextStyle(fontSize: 15),),),
                           TextButton(
                              onPressed: (){
                                // print('DON:: ${val[0]['foto']}'); 
                                _openFoto(val[0]['foto'], item,  val[0]['hari'], val[0]['jam']);
                              }, 
                            child: Text( '${val[0]['jam'] }', style: const TextStyle(fontSize: 17),),
                            )
                        ],)
                       ),

                      // OUT
                       Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: (val.length < 2) ? const Text('')  
                        : Column(children: [ 
                          Center(child: Text( '${val[1]['ket'] }', style: const TextStyle(fontSize: 15),),),  
                          Center(
                            child: TextButton(
                              onPressed: (){
                                _openFoto1(val[1]['foto'], item,  val[1]['hari'], val[1]['jam']);
                              }, 
                            child: Text( '${val[1]['jam'] }', style: const TextStyle(fontSize: 17),),
                            )
                          ),
                        ],)
                       ),
                      
                    
                    ],),
                  ),
                  
                ); 
            },),
          )
        ],
      ),
    );
  }
   
  _openFoto(String str, String tgl, String hari, String jam){ 
  
     final uint8List = base64Decode(str);  
      Get.defaultDialog(  
        title: '$hari, $tgl $jam',
        titleStyle: const TextStyle(fontSize: 15),
        titlePadding: const EdgeInsets.all(5),
        content : Image.memory(uint8List), 
    );
 
  }
  
  _openFoto1(String str, String tgl, String hari, String jam){ 
  
     final uint8List = base64Decode(str);  
      Get.defaultDialog(  
        title: '$hari, $tgl $jam',
        titleStyle: const TextStyle(fontSize: 15),
        titlePadding: const EdgeInsets.all(5),
        content : Image.memory(uint8List), 
    );
 
  }

}//end