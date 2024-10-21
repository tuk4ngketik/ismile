// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, annotate_overrides, unused_element, non_constant_identifier_names, avoid_print, no_leading_underscores_for_local_identifiers, unused_field, prefer_typing_uninitialized_variables
 
import 'dart:io'; 
import 'package:flutter/material.dart';  
import 'package:path_provider/path_provider.dart';  
import '../Helper/func.dart'; 
import '../Helper/wg.dart'; 
 

class AvatarHeader extends StatefulWidget{   
  final namaDepan, namaBelakang, dept, division;
  const AvatarHeader({super.key, required this.namaDepan, required this.namaBelakang, required this.dept, required this.division,});
  _AvatarHeader  createState() => _AvatarHeader();
}

class _AvatarHeader extends State<AvatarHeader>{ 
  File? fCrop;  

  _getFilePic() async { 
     final dir = await  getTemporaryDirectory();  
     setState(() => fCrop = File('${dir.path}/profil_crop.jpg')); 
  }
   
  @override
  void initState() {          
    _getFilePic();  
    super.initState();    
  } 
    
  Widget build(BuildContext context) {
    return  Row(children: [
      avatarCrop(fCrop), 
      spasi(5),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
          Text('${widget.namaDepan} ${widget.namaBelakang}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,  )),
          Text('${widget.dept}', style: const TextStyle(fontSize: 11),) ,
          // Text('${widget.division}', style: const TextStyle(fontSize: 11),) ,
        ],),
      ),
      spasi(5),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text( getDay(), style: const TextStyle( fontWeight: FontWeight.bold),),
          Text( getDate(), style: const TextStyle(  fontSize: 11),)
      
      ],)
    ],);
  } 
   
}// ENd