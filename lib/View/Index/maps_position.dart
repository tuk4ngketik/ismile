// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, annotate_overrides, avoid_print, unused_field, no_leading_underscores_for_local_identifiers, override_on_non_overriding_member, unused_element, must_be_immutable, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:vil_presensi_0/Helper/wg.dart'; 

class Mapsposition extends StatefulWidget{  
   final lokasiKerja; 
   final namaLengkap; 
   final currentLatlong;
   const Mapsposition({super.key, required this.lokasiKerja, required this.currentLatlong,  this.namaLengkap,  });
  _Mapsposition  createState() => _Mapsposition();
}

class _Mapsposition extends State<Mapsposition>{ 

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final customInfoWindowController = CustomInfoWindowController();

  static const CameraPosition _indonesia = CameraPosition( 
    target: LatLng(-0.789275,113.921326), 
    zoom: 4.0
  );
 
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance; 
  late List<Marker> listMarkers = [];
  late Marker userMarker;
  late AssetMapBitmap personMarker;
  late AssetMapBitmap officeAsset;
  List<Map<String, String>>? lokasiKerja;
  LatLng? _currentLatlong; // posisi uptodate
  bool isMapReady = false;
  late CreateBounds createBounds;
 
 
  void initState() {   
    super.initState();    
    _createUserMarker(); 
    _depoloyMarkers(); 
    createBounds = CreateBounds(lokasikerja: widget.lokasiKerja, lokasiuser: widget.currentLatlong);
  } 
  void dispose(){
    super.dispose();
    customInfoWindowController.dispose();  
  }
  @override
  Widget build(BuildContext context) {   
     return (widget.lokasiKerja == null && widget.currentLatlong == null)  ? const Center(child: CircularProgressIndicator(),) 
       : Stack(
       children: [ 
         GoogleMap(
          onTap: (argument){ 
            customInfoWindowController.hideInfoWindow!();
            _updateCurrPosition();
          },
          // liteModeEnabled : true,
          myLocationButtonEnabled: true,
          // myLocationEnabled: true,
          // zoomControlsEnabled: true,
            // mapType: MapType.hybrid,
            // mapType: MapType.satellite,
            // mapType: MapType.terrain, 
            // mapType: MapType.normal, 
            initialCameraPosition: _indonesia,
            onCameraIdle : () async { 
              await Future.delayed(const Duration(milliseconds: 500));
              if (!mounted) { return;  } 
              setState(() { isMapReady = true; });
              // _determinePosition(); 
            },
            onMapCreated: (GoogleMapController controller) async { 
              customInfoWindowController.googleMapController = controller;
              _controller.complete(controller); 
              await Future.delayed(const Duration(seconds: 1));
              if (!mounted) { return;  } 
              setState(() { isMapReady = true; }); 
              await controller.animateCamera(CameraUpdate.newLatLngBounds( createBounds.mapbounds(), 80)); 
            },
            onCameraMove: (position) {
              customInfoWindowController.onCameraMove!();
            }, 
            markers: Set.of(   listMarkers ),
          ),
          Align(
            alignment: Alignment.center,
            child: (isMapReady == false ) ? const CircularProgressIndicator() : const Text(''),
         ),  
         CustomInfoWindow(
          controller: customInfoWindowController,
          width: 200,
          height: 80,
          offset: 70,
         )
       ],
     );
  }
 
  // Future<void> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission; 
  //   LocationPermission.always;  
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) { 
  //     //  print('Location services are disabled.'); 
  //      await Geolocator.openLocationSettings().then((v)  {
  //        print( 'DON:: Geolocator.openLocationSettings() $v');
  //      } );
  //   }  
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale 
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now. 
  //       // defaultDialogErr('Aktifkan GPS anda'); 
  //       LocationPermission.always;
  //       // await Future.delayed(const Duration(milliseconds: 500));
  //       // print('Location permissions are denied');
  //       // exit(0); // colse apps
  //       // return Future.error('Location permissions are denied');
  //     } 
  //   }   
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately. 
  //     defaultDialogErr('Aktifkan GPS anda'); 
  //     LocationPermission.always; 
  //      await _geolocatorPlatform.openAppSettings();
  //     // await Future.delayed(const Duration(milliseconds: 500));
  //     // exit(0);
  //     // return Future.error( 'Location permissions are permanently denied, we cannot request permissions.');
  //   }  
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   // return await Geolocator.getCurrentPosition();
  //    Position position =  await Geolocator.getCurrentPosition();
  //    double lat = position.latitude;
  //    double lgt = position.longitude; 
  //     _currentLatlong = LatLng(lat, lgt);  
  //     await Future.delayed(const Duration(seconds: 1));   
  //   userMarker = Marker(
  //                   markerId: const MarkerId('_currentPosition'), 
  //                   position : _currentLatlong!,
  //                   icon:  await customMarker('person-marker.png'),
  //                   onTap :()=> customInfoWindowController.addInfoWindow!(
  //                     wInfowindow('${widget.namaLengkap}', ''), _currentLatlong!
  //                   ),
  //                 );
  //   listMarkers.add(userMarker); 
  //     // final GoogleMapController controller = await _controller.future;
  //     // await controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));  
  // } 

  _createUserMarker() async { 
    // LatLng latLng = LatLng(double.parse( currentLatlong!['lat']!),  double.parse( currentLatlong!['lgt']! ),);
    userMarker = Marker(
                    markerId: const MarkerId('_currentPosition'), 
                    // position :  latLng,
                    // position :  _currentLatlong!,
                    position :  widget.currentLatlong,
                    icon:  await customMarker('person-marker.png'),
                    onTap :()=> customInfoWindowController.addInfoWindow!(
                      // wInfowindow('${widget.namaLengkap}', ''), latLng
                      wInfowindow('${widget.namaLengkap}', ''), _currentLatlong!
                    ),
                  );
    listMarkers.add(userMarker); 
  }
      
  Future<AssetMapBitmap> customMarker(String assetName) async {
    //  personMarker  = await AssetMapBitmap.create(
    return await AssetMapBitmap.create(
      ImageConfiguration.empty,
      'imgs/$assetName'
    ); 
  }
    
    
  _depoloyMarkers() async {     
    for (var element in widget.lokasiKerja) { 
      final lat = double.parse('${element['lat']}');
      final lgt = double.parse('${element['lgt']}');
      final lok = '${element['lok']}';
      final latLng = LatLng(lat, lgt); 
      Marker marker = Marker(
                      markerId: MarkerId(lok), position: latLng, 
                      icon:  await customMarker('pin-marker.png'), 
                      onTap:() => customInfoWindowController.addInfoWindow!(
                        wInfowindow(lok, ''),
                        latLng
                      ),
                    );
      listMarkers.add(marker);   
    }   
     
  }   
 
  _updateCurrPosition(){
        
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) async { 
        if(position != null){ 
          _currentLatlong = LatLng(position.latitude, position.longitude); 
          // print('Don:: StreamSubscription _currentLatlong : $_currentLatlong');  
          // userMarker.position = _currentLatlong;   
          listMarkers.remove(userMarker);
                  
            userMarker = Marker(
                            markerId: const MarkerId('_currentPosition'), 
                            position : _currentLatlong!,
                            icon:  await customMarker('person-marker.png'),
                    onTap :()=> customInfoWindowController.addInfoWindow!(
                      wInfowindow('${widget.namaLengkap}', ''), _currentLatlong!
                    ),
                  );
           listMarkers.add(userMarker);  
        }
        else{
          // print('Don:: StreamSubscription _currentLatlong : position = null'); 
        }
    });
  } 
  
  Widget wInfowindow(String title, String snipet){
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            // Text(snipet, style: const TextStyle(fontSize: 17),),     
        ],), 
      ),
    );
  }  

}// 
   

class CreateBounds{

  final  lokasikerja;
  final  lokasiuser;
  CreateBounds({required this.lokasikerja, required this.lokasiuser}); 

  LatLngBounds mapbounds(){ 
    final List<LatLng> newbounds = [];
    for (var element in lokasikerja ) {
      newbounds.add(LatLng(double.parse('${element['lat']}'), double.parse('${element['lgt']}')));
    }  
    newbounds.add(lokasiuser); 
    double? x0, x1, y0, y1; 
    for (var element in newbounds ) {  
      final lat = element.latitude;
      final lgt =  element.longitude;
        if (x0 == null) {
          x0 = x1 = lat;
          y0 = y1 = lgt;
        } else { 
          if (lat > x1!) x1 =  lat;
          if (lat < x0) x0 = lat;
          if (lgt > y1!) y1 = lgt;
          if (lgt < y0!) y0 = lgt;
        } 
     } // for 
     return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));   
  }
}