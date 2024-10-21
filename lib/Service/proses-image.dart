// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data'; 
 
import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;

import 'deteksi.dart';
import 'ml_service.dart'; 

class ProsesImage{ 

  File? f; 

  Uint8List? uint8listCroped;
  Uint8List get getUint8listCroped => uint8listCroped!; 


  imglib.Image? croped; 
  imglib.Image? getCroped ()=> croped;
  List? dataTensorCrop;   

  Deteksi deteksi = Deteksi();
  MlService mlService = MlService();
 

  Future<RetImaagProcess?> initialize() async {
 
  //  mlService.initialize();  

    // Init Face detektor  
    deteksi.initialize();
 
    
     final dir = await  getTemporaryDirectory();  
     String str_file = '${dir.path}/profil_crop.png';   
     f = File(str_file); 
     
    InputImage inputImage = InputImage.fromFile(f!);
 
    await deteksi.deteksiWajah(inputImage);

    Face face = deteksi.getFace(); 
      double x = (face.boundingBox.left - 10);
      double y = (face.boundingBox.top - 10);
      double w = (face.boundingBox.width + 10);
      double h = (face.boundingBox.height + 10); 

        // double x = (face.boundingBox.left );
        // double y = (face.boundingBox.top );
        // double w = (face.boundingBox.width );
        // double h = (face.boundingBox.height );  
     imglib.Image? img  =  imglib.decodeImage(File(f!.path).readAsBytesSync()); // OK
     
      croped = imglib.copyCrop( img!, x: x.round(), y: y.round(), width: w.round(), height: h.round());
      croped = imglib.copyResizeCropSquare(croped!, size: 112);  

      if(croped == null) { return null; }

      
      uint8listCroped =  imglib.encodeJpg( croped! );     
      // print('ProsesIMage() $uint8listCroped'); 

      // mlService.imgToTensor(croped!);
      dataTensorCrop =  mlService.getE1()!;  
      // print('ProsesIMage() $dataTensorCrop');

      // Wajib ditutup
      deteksi.close(); 
      // mlService.close();

      return RetImaagProcess(uint8listFromSvr: uint8listCroped!, dataTensor: dataTensorCrop!);

  } 
  

}

class RetImaagProcess{
  final Uint8List uint8listFromSvr;
  final List dataTensor; 
  RetImaagProcess({required this.uint8listFromSvr, required this.dataTensor}); 
}