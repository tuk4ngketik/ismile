// ignore_for_file: prefer_final_fields, slash_for_doc_comments, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';

import 'package:package_info_plus/package_info_plus.dart';

import '../Cfg/svr.dart'; 

/**  
 *    CARA PENGGUNAAN 
 *    myappAttr.retHeader().then((value) => print ('myappAttr.retHeader $value') );
 *    myappAttr.appinfo().then((value) => print ('myappAttr.appinfo $value') ); * 
 */

class MyappAttr  {

  Svr svr = Svr();
  final now = DateTime.now();  
  var myinfo;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
   
    String pckName () => base64.encode(utf8.encode( _packageInfo.packageName));    
    String version () => base64.encode(utf8.encode( _packageInfo.version));    
    String buildNumber () => base64.encode(utf8.encode( _packageInfo.buildNumber));    

    String realApppName () =>  _packageInfo.appName;
    String realPckName () =>   _packageInfo.packageName;
    String realVersion () =>   _packageInfo.version;
    String realBuildNumber () =>   _packageInfo.buildNumber;
    
   // return headers
   Future< Map<String, String> > retHeader() async {
     
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info; 
    
    return {
        'apikey':  svr.apikey,
        'pckname':  pckName(),
        'targetpath': svr.targetpath, 
        'appversion': _packageInfo.version, 
        // 'Content-Type': 'application/json'
    }; 
  }

 
  Future<dynamic> appinfo()   async {
      final info = await PackageInfo.fromPlatform();
      _packageInfo = info;  
      myinfo  = { 
        'appName' : _packageInfo.appName,
        'appVer' : _packageInfo.version,
        'pckName' : _packageInfo.packageName,
        'buildNumber': _packageInfo.buildNumber,
      };
      return myinfo;
  }


}