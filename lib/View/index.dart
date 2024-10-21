// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, annotate_overrides, unused_element, non_constant_identifier_names, avoid_// // print, no_leading_underscores_for_local_identifiers, unused_field, void_checks, avoid_print
 
import 'dart:async';
import 'dart:io';
    
// import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter/material.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:safe_device/safe_device.dart';  
import 'package:vil_presensi_0/View/avatar_header.dart';
import 'package:vil_presensi_0/View/Index/maps_position.dart'; 

import '../Apis/a_distance.dart'; 
import '../Cfg/Sess.dart';
import '../Cfg/css.dart';
import '../Helper/func.dart';
import '../Helper/myapp-attr.dart';
import '../Helper/wg.dart';
import 'absen.dart'; 
 

class Index extends StatefulWidget{   
  const Index({super.key  });
  _Index  createState() => _Index();
}

class _Index extends State<Index>{ 

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final Sess sess = Sess();
  final MyappAttr myappAttr = MyappAttr(); 
  late Map<String, String> headers = {};
  final apiDistance = ApiDistance(); 
  
  String? imei, account_serial, company_serial, company_branch_serial, nik, nama_depan, nama_belakang, division, dept;
  // urlPhoto, filePicCrop; 
  String resolution = 'Low';
  File? fCrop;  
  Map<String, String>? latlong; // Posisi device
  double max_radius = 20;
  double? jarak;
  bool checkStatusAbsen = false, disableIn = false, disableOut = false, isLoadcheckin = false, isLoadcheckout = false;
  DateTime? strCheckin,  strCheckOut;
  String serialCheckout = '';
   
  List<Map<String, String>>? listLatlong; // list lokasi kerja
  LatLng? currentLatlong; // posisi DEvice
  
  @override
  void initState() {     
    if (!mounted) { return;  } 
    sess.getSess('company_serial').then((value) {  setState(() => company_serial = value); } );
    sess.getSess('company_branch_serial').then((value) {  setState(() => company_branch_serial = value); } );
    sess.getSess('imei').then((value) {  setState(() => imei = value); } );
    sess.getSess('serial').then((value) {  setState(() => account_serial = value); } );  
    sess.getSess('serial').then((value) {  setState(() => account_serial = value); } );
    sess.getSess('nik').then((value) => setState(() => nik = value)  );
    sess.getSess('nama_depan').then((value) {  setState(() => nama_depan = value); } );
    sess.getSess('nama_belakang').then((value) {  setState(() => nama_belakang = value); } );
    sess.getSess('division').then((value) {  setState(() => division = value); } );
    sess.getSess('dept').then((value) {  setState(() => dept = value); } );
    _determinePosition();  
    _getHeaders();  
    _startTimer();
    super.initState();    
  } 
   
  _getHeaders ()   async {  
     headers = await myappAttr.retHeader(); 
        _ambilLokasiKerja(headers); // anywhere n defaut
        _getStatusAbsen(headers);  
  }

  Widget build(BuildContext context) {
    return (account_serial == null) ? const Center(child: CircularProgressIndicator(),) 
    : Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          br(10),
          
          AvatarHeader(namaDepan: nama_depan, namaBelakang: nama_belakang, dept: dept, division: division),
          
          br(20), 
          Container(    
            padding: const EdgeInsets.all(20), 
            decoration:     BoxDecoration(  
              borderRadius: const BorderRadius.all(Radius.circular(30) ),   
              border: Border.all(width: 0.4, color: Colors.green)
            ),
            child: (checkStatusAbsen == false) 
              ? Container(
                  padding: const EdgeInsets.all(30), height: 100,  
                  child: const Center( child: LinearProgressIndicator(color: Colors.indigoAccent, backgroundColor: Colors.grey,),)
                )
              : Column( 
              children: [   
                Center(child: Text(  (jamNow == null ) ? '' : jamNow!, 
                 style: const TextStyle(fontSize:25, fontWeight: FontWeight.bold, color: Colors.indigoAccent ),),), 
                
                jamInOut(),
                br(10), 

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [  
                    Flexible(  
                      fit: FlexFit.tight,
                      // flex: 4,
                      child: (isLoadcheckin == true) ? loadBtn() : _btnAbsen(Icons.login, 'Masuk', 'in', disableIn), 
                    ), 
                    spasi(5),
                    Flexible(  
                      fit: FlexFit.tight,
                      // flex: 4,
                      child :  (isLoadcheckout == true) ? loadBtn() : _btnAbsen(Icons.logout, 'Pulang', 'out', disableOut)
                    ),  
                ],
              ),
          
              ],
            ),
          ),
          
          br(20),  // Map     
          Expanded(  
              child: ( listLatlong == null || currentLatlong == null )  
                      ? const Center(child: CircularProgressIndicator(color: Colors.yellow,),) 
                      : (listLatlong!.isEmpty) ? const Center(child: Text('Tidak Ada Lokasi Kerja'),)  
                       : Mapsposition(lokasiKerja: listLatlong!,  namaLengkap: '$nama_depan $nama_belakang', currentLatlong: currentLatlong!,)
          ), 
      
      ],),
    );
  } 
  
  // Loading button
  Widget loadBtn(){
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10,bottom: 10),
      decoration:  const BoxDecoration(
        color:    Colors.indigoAccent,  
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      height: 55, 
      child: const Column(
              children: [
              Text('Load ...', style: TextStyle(color: Colors.white),), LinearProgressIndicator(color: Colors.white,)
            ],)
    );
  }
  
  // Button Absen masuk n Pulang
  Widget _btnAbsen( IconData icn, String txtAbsen, String txtFunction, bool disableButton){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration:  const BoxDecoration(
        color:    Colors.indigoAccent,  
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      height: 55,
      child:TextButton.icon( 
        // onPressed: ()=> print('DON::TextButton.icon $listLatlong ' ),
        onPressed: ()=>  (disableButton == false) ?  _absen( txtFunction ) : null,  
        icon: Icon(icn, color:  Colors.white,),  
        label : Text(txtAbsen, style:   const TextStyle(color:   Colors.white),), 
      ),
    );
  }
  
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission; 
    LocationPermission.always; 

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {  
       await Geolocator.openLocationSettings().then((v){   });
    } 
    
    
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now. 
        // defaultDialogErr('Aktifkan GPS anda'); 
        LocationPermission.always;
        // await Future.delayed(const Duration(milliseconds: 500));
        // // // print('Location permissions are denied');
        // exit(0); // colse apps
        // return Future.error('Location permissions are denied');
      } 
    } 
      // aktifkanGps(){ // // print('Ayo Aktifkan');}
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      defaultDialogErr('Aktifkan GPS anda'); 
      LocationPermission.always; 
       await _geolocatorPlatform.openAppSettings();
      // await Future.delayed(const Duration(milliseconds: 500));
      // exit(0);
      // return Future.error( 'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
     Position position =  await Geolocator.getCurrentPosition();
    //  double lat = position.latitude;
    //  double lgt = position.longitude;  
     
     if (!mounted) { return;  } 
     setState(()  {
      // latlong = { 'lat': lat.toStringAsFixed(5) , 'lgt':   lgt.toStringAsFixed(5), };
      currentLatlong = LatLng(position.latitude, position.longitude);
      // currentLatlong = LatLng(lat, lgt);
     });
 
     if(position.isMocked == true ){
       defaultDialogErr('Anda menggunakan lokasi palsu');
     }
      
  }
   
  Future<void> _ambilLokasiKerja(Map<String, String> headers) async {
    final List<Map<String, String>>  _listLatlong = []; 
    // Lokasi anywhere
    final data = await  apiDistance.lokasiKerja(account_serial! , headers ) 
                               .catchError((onError) =>  defaultDialogErr('${onError.message}') );
    bool? status = data!.status;  
    if(status == false) {
      defaultDialogErr('${data.message}');
      return;
    }  
    final row = data.data;
    if(row!.isNotEmpty) {  
      for (var element in row)  {  
          Map<String, String> map = { 'lat' :  '${element.mesinLocLat}', 'lgt': '${element.mesinLocLog}' , 'lok':'${element.mesinName}'};   
          _listLatlong.add(map);
      }   
      if (!mounted) { return;  } 
      setState(() => listLatlong = _listLatlong );  
    }   

    // Lokasi krja default
    final data2 = await  apiDistance.lokasiKerjaDefault(company_branch_serial!, headers)
                               .catchError((onError) =>  defaultDialogErr('${onError.message}') );
      bool? status2 = data2!.status;
      if(status2 == false) {
        defaultDialogErr('${data2.message}');
        return;
      } 
      final row2 = data2.data;  
      if(row2 != null){ 
        final Map<String, String> map = { 'lat' :  '${row2.mesinLocLat}', 'lgt': '${row2.mesinLocLog}' , 'lok':'${row2.mesinName}'};
        _listLatlong.add(map);
        // print('DON:: Map $map');
        if (!mounted) { return;  }   
        setState(() => listLatlong = _listLatlong ); 
      }
      if(listLatlong == null){
        defaultDialogErr('Belum ada lokasi kerja'); 
      }
  } 

  Future<void> _getStatusAbsen(Map<String, String> headers) async {
    String date = getDateEng(); // Prod  
    // apiDistance.getStatusAbsen(nik!, '2024-09-20', headers).then((v) {
    final v = await apiDistance.getStatusAbsen(nik!, date, headers) 
                               .catchError((onError) =>  defaultDialogErr('${onError.message}') );
      bool? status = v!.status; 
      if(status == false) {
        defaultDialogErr('${v.message}');
        return;
      }  
      var data = v.data;
      if(data!.isNotEmpty){ 
        if (!mounted) { return;  } 
        setState((){ 
          disableIn = true; 
          strCheckin = data[0].signDate;
        });
      }  
      if(data.length > 1){ 
        if (!mounted) { return;  } 
        setState(() {
          // disableOut = true;
          strCheckOut = data[1].signDate;
          serialCheckout = data[1].serial!;
        });
      }  
      if (!mounted) { return;  } 
      setState(() =>checkStatusAbsen = true );
      // // print('DON:: strCheckin: $strCheckin strCheckOut: $strCheckOut checkStatusAbsen: $checkStatusAbsen serialCheckout: $serialCheckout ');
 
  }

  bool _countDeviceToLokasikerja(double endLatitude, double endLongitude){
    if (!mounted) { return false;  } 
    setState(() {
       jarak = Geolocator.distanceBetween( currentLatlong!.latitude , currentLatlong!.longitude, endLatitude, endLongitude);
    });  
    // print('DON:: _countDeviceToLokasikerja()    $jarak M'); 
    if(jarak! > max_radius){ 
      return false;
    }
    return true;
  } 

  bool _check_radius(){ // Check Radieus anywhere    
      List<bool> list_radius = [];    
      for (var element in listLatlong!) {  
        bool cek_radius = _countDeviceToLokasikerja( double.parse('${element['lat']}'),  double.parse('${element['lgt']}')); 
        // print('DON:: cek_radius $cek_radius ${element['lat']}');
        list_radius.add(cek_radius);  
      }  
    // cek apakah ada yg masuk radius  
    // print('DON:: list_radius: $list_radius ');
    return list_radius.any((element) => element == true ); 
  } 

  Future<void> _absen(String checkinCheckout)   async {  
    
    // print('DON:: _absen $listLatlong'); 
    
    if(checkinCheckout == 'out'){ // Jika blm checkin
      if(disableIn == false) { 
        defaultDialogErr('Anda belum Checkin');
        return;
      }  
      setState(()  =>  isLoadcheckout = true );
    }
    if(checkinCheckout == 'in'){   
      setState(()  =>  isLoadcheckin = true );
    }

    // bool isMockLocation = await DetectFakeLocation().detectFakeLocation(); //detect_fake_location: ^2.0.0
    
    // bool isMockLocation = await SafeDevice.isMockLocation;  // by safe_device: ^1.1.9
    // // // print('DON:: isMockLocation $isMockLocation ');

    bool isMockLocation = await  _isMockGeolocator(); // Geolocator 

    if( isMockLocation  == true){
        // // print('DON:: _isFakegps  $isMockLocation');
        defaultDialogErr('Anda menggunakan lokasi palsu');
        setState(() {
          isLoadcheckin = false; 
          isLoadcheckout = false;
        } );
        return; 
    }
    // print('DON:: lokasi device $latlong ;  lokasi kerja: $listLatlong');
 

    if(listLatlong!.isNotEmpty){ 
      // print('DON:: loc Anywhere');
      bool result =   _check_radius();
      // String _jarak = '${jarak!.toStringAsFixed(2)} M';
      // print('DON:: _check_radius() $_jarak');
      if(result == false){ 
        setState(() {
          isLoadcheckin = false; 
          isLoadcheckout = false;
        } );
        return defaultDialogErr('Anda diluar lokasi kerja');
      } 
    }    
    final  postData = {    
      'nik' : '$nik', 
      'lat' : '${currentLatlong!.latitude}',
      'lgt' : '${currentLatlong!.longitude}',  
      'account_serial' : '$account_serial', 
      'imei' : '$imei',
      'checkinCheckout' : checkinCheckout, 
      'serialCheckout' : serialCheckout, 
    };
    // // print('DON:: postData index : $postData'); 
    Get.off( Absen( resolution: resolution, headers: headers, postData: postData, ) );
  }
 
  Widget jamInOut(){  
             return  Row( 
              children: [  
                Flexible( 
                  fit: FlexFit.tight,
                  flex: 4,
                  child : Center(
                    // child: Text( getJmd(strCheckOut), style: Css.jamInOut,)
                    child: Text( (strCheckin==null) ? '__ : __ : __':  convertJmd(strCheckin!), style: Css.jamInOut,)
                  )
                ),  
                const Spacer(flex: 2, ), 
                Flexible( 
                  fit: FlexFit.tight,
                  flex: 4,
                  child : Center(
                  child: Text( (strCheckOut == null) ? '__ : __ : __' : convertJmd(strCheckOut!), style: Css.jamInOut,) 
                  )
                ),  
            ],);
  }


  Future<bool> _isMockGeolocator() async {
    Position position =  await Geolocator.getCurrentPosition();
    return position.isMocked;
  }   
  
  late Timer _timer; 
  String? jamNow;  
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds:   1), 
      (Timer t) {
            final _dateTime = DateTime.now(); 
            if (!mounted) { return;  } 
            setState(() { 
              final menit = _dateTime.minute.toString().padLeft(2, '0');
              final detik = _dateTime.second.toString().padLeft(2, '0');
              final jam = _dateTime.hour.toString().padLeft(2, '0');
              jamNow =  '$jam : $menit : $detik';
            }); 
             
            // // // print('DON:: _timer $jamNow thick: ${_timer.tick} }');
            // // // print('thick: ${_timer.tick} }');
             
          });
  }

  @override
  void dispose() { 
    super.dispose(); 
    _timer.cancel(); 
  }

}// ENd