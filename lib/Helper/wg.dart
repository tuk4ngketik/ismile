
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../View/home.dart'; 

Widget br(double height ){
  return Container(
    height: height,
  );
}

Widget spasi(double width ){
  return Container(
    width: width,
  );
}

// Text Color
Widget textDef( String t ){
  return Text(t,  );
}

Widget textColor( String t, Color color){
  return Text(t, style: TextStyle(color: color),);
}

// Dialog GetX
 defaultDialogErr(String msg){ 
          Get.defaultDialog(
            title: '',
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(20),
            content: Column(children:   [
              const Icon(Icons.error, color: Colors.red, size: 40,),
              const Divider(color: Colors.amber,),
              Text(msg)
            ],),
            textCancel: 'Tutup',
            cancelTextColor: Colors.black 
          );
 }

 defaultDialogErrToHome(String msg){ 
          Get.defaultDialog(
            title: '',
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(20),
            content: Column(children:   [
              const Icon(Icons.error, color: Colors.red, size: 40,),
              const Divider(color: Colors.amber,),
              Text(msg)
            ],),
            // textCancel: 'Tutup',
            cancelTextColor: Colors.black,
            textConfirm: 'Tutup',
            onConfirm: () => Get.to(const Home()),  
            barrierDismissible : false
          );
 }

 
 defaultDialogMustRoute(String msg, Object page){ 
          Get.defaultDialog(
            title: '',
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(20),
            content: Column(children:   [
              const Icon(Icons.error, color: Colors.red, size: 40,),
              const Divider(color: Colors.amber,),
              Text(msg)
            ],),
            // textCancel: 'Tutup',
            cancelTextColor: Colors.black,
            textConfirm: 'OK',
            onConfirm: () => Get.to( page ),  
            barrierDismissible : false
          );
 }

 defaultDialogRunFunc(String msg, Function  func){ 
          Get.defaultDialog(
            title: '',
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(20),
            content: Column(children:   [
              const Icon(Icons.error, color: Colors.red, size: 40,),
              const Divider(color: Colors.amber,),
              Text(msg)
            ],),
            // textCancel: 'Tutup',
            cancelTextColor: Colors.black,
            textConfirm: 'OK',
            onConfirm: (){ func ; },  
            barrierDismissible : false
          );
 }


  // Appbar

  PreferredSizeWidget appbar0(){
    return AppBar( 
      backgroundColor: Colors.indigo, 
      // title: const Text('VIL Grup Presensi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white  ),), 
      title: const Text('VIL GROUP - iSMILE', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white  ),), 
      // flexibleSpace: Container(
      //   padding: const EdgeInsets.all(20),
      //   width: Get.width,
      //   // color: Colors.yellow,
      //   child: const Text('VIL Grup Presensi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white ),),
      // )
    );
  }

  PreferredSizeWidget appbar1(){
    return  AppBar(  
          backgroundColor: Colors.indigo,
          shadowColor: Colors.yellow,
          elevation: 3,
          toolbarHeight: 100,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              const Text('VIL Grup Presensi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white ),), 
              Container(height: 10,)
            ],
          ), 
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical( 
              bottom:   Radius.elliptical(30,20), 
            ), 
          ),
          flexibleSpace: Container(   
              decoration: const BoxDecoration( 
              ),
          ), 
      );
  }

  
  PreferredSizeWidget appbar2(){
    return AppBar( 
      shadowColor: Colors.amber,
      elevation: 5 ,
      backgroundColor: Colors.indigo,
      title:  const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Presensi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white ),),
          Text('PT. IKIK ( Ini Kaga Itu Kaga )', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white ),),
        ],
      ), 
    );
  }

  // Camera
  Widget overlayFaceCam(Color clr){
    return Align(
            alignment: Alignment.center,
      child: Container(
        width: 225,
        height: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          // border: Border.all(color: Colors.white60, width: 5),
          border: Border.all(color:clr, width: 5)
        ),
      ),
    );
  }


  Widget avatarCrop(File? fCrop){
   return CircleAvatar(
              radius: 30, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),  
                child: (fCrop == null) ? const Icon(Icons.person)
                      : Image.file(fCrop,
                      // Image.network(urlPhoto!, filterQuality: FilterQuality.low, 
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) { 
                                  return const Center(child: Text('😢 Image Not Found  😢'));
                                },   
                      ),  
                // child: Image.file(fCrop!),
              ),
            );
  }