// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';  
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart'as imglib;
import 'package:path_provider/path_provider.dart';

class CropProfil{

  final String urlFoto; 
  CropProfil({required this.urlFoto});

  // FAcedetektor
  late FaceDetector faceDetector;
  late Face face;
  
  late InputImage inputImage;   
  
  Uint8List? uint8listCroped;
  Uint8List get getUint8listCroped => uint8listCroped!; 
 
  String? base64ImageCrop;
  String? get getbase64ImageCrop => base64ImageCrop; 
 

  deteksi() async { 

    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate
    ); 

    faceDetector = FaceDetector(options: options);

    final File?  file = await  getPicture(); 

    inputImage = InputImage.fromFile(file!);

    final faces =  await faceDetector.processImage(inputImage);

     
    if(faces.isEmpty) {
      print('Deteksi Profil: No FAce');
      return;
    } 
    
    print('Deteksi Profil: Face Detected');
    face = faces[0];
      double x = (face.boundingBox.left - 10.0);
      double y = (face.boundingBox.top - 10.0);
      double w = (face.boundingBox.width + 10.0);
      double h = (face.boundingBox.height + 10.0);  
      
     imglib.Image? img  =  imglib.decodeImage(File(file.path).readAsBytesSync()); // OK
     imglib.Image croped = imglib.copyCrop( img!, x: x.round(), y: y.round(), width: w.round(), height: h.round());
     croped = imglib.copyResizeCropSquare(croped, size: 112);  
 

      // Croping Image
      uint8listCroped =  imglib.encodeJpg( croped );    

      // Get temporary directory
      final dir = await getTemporaryDirectory(); 
      final filename = '${dir.path}/profil_crop.jpg'; 
      final f = File(filename);  
      await f.writeAsBytes(uint8listCroped!);  

      // crop profil  to base64
      final bytes = File(f.path).readAsBytesSync();
      // base64ImageCrop =  "data:image/png;base64,"+base64Encode(bytes);  
      base64ImageCrop =   base64Encode(bytes);  
      // print("DON:: $base64ImageCrop");
      // print('DON:: $uint8listCroped'); 

     faceDetector.close();
     
  }
  
  Future<File?> getPicture () async {

    try {
      
        final http.Response response = await http.get( Uri.parse(urlFoto));

        // Get temporary directory
        final dir = await getTemporaryDirectory();
        
        // Create an image name
        final filename = '${dir.path}/profil_vkool.jpg';
        
        final f = File(filename); 
        
        await f.writeAsBytes(response.bodyBytes);   

        print('f.path ${f.path}');
        return f;

      } catch (e) { 
        print('ProsesImage.downloadImage() Err:  $e'); 
        return null;
      }   
  } 



}// end 