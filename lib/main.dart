// ignore_for_file: must_be_immutable, non_constant_identifier_names, library_private_types_in_public_api, annotate_overrides
 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';  
import 'package:splashify/splashify.dart'; 

import 'Cfg/Sess.dart';
import 'View/home.dart';
import 'View/login.dart';

void main() { 
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  initializeDateFormatting('id_ID', null);
  runApp(  const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp>{  

  Sess sess = Sess();
  String? status_app; 

  void initState() { 
    super.initState(); 
    removeNativeSplash();
    sess.getSess('status_app').then((value) => setState(() => status_app = value )  );  
  }
 
  void removeNativeSplash() async {  
    await Future.delayed(const Duration(milliseconds: 300)); 
    FlutterNativeSplash.remove();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(   
      debugShowCheckedModeBanner: false,
      title: 'VIL Presensi',
      theme: ThemeData(  
        primarySwatch: Colors.indigo ,
        useMaterial3: true,
      ), 
      // home: ( status_app == 'login' ) ?     const Login() :     Home()   
      home: Splashify( 
        enableFrame : true,
        title: 'VIL Group - iSMILE',
        titleFadeIn :true, 
        colorizeTitleAnimation : true,
        colorizeTileAnimationColors : const [Colors.red,Colors.green, Colors.blue],
        blurIntroAnimation :true,
        imageFadeIn: true,
        imageSize: 250,
        imagePath: 'imgs/vil-grup-logo.png',
        navigateDuration: 2, // Navigate to the child widget after 3 seconds
        fadeInNavigation :true,
        child: ( status_app == 'login' ) ? const Home() : const Login(), 
      ),
       
    );
  }
} 
 