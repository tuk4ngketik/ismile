
 // ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, slash_for_doc_comments, prefer_typing_uninitialized_variables, non_constant_identifier_names
 

import 'dart:typed_data'; 

import 'package:camera/camera.dart';
import 'package:convert_native_img_stream/convert_native_img_stream.dart'; 
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;

import '../Models/G/Proses_comtroller.dart';   

class CameraToImage{ 

  final CameraImage cameraImage;
  final Face face;
  CameraToImage({required this.cameraImage, required this.face });
  // final bool sibuk;
  // CameraToImage({required this.cameraImage, required this.face, required this.sibuk});

  //  tfl.Interpreter? interpreter; 

  final prosesController = Get.put(ProsessController()); 

  // Proses Image
  final convertNative = ConvertNativeImgStream(); 
  int rotation = 270; 
  int quality = 50;
  List e1 = [];
  List getE1 () => e1; 

    /**
     * Tensore
     */
    
  // List imgToTensor(imglib.Image? img, tfl.Interpreter? interpreter)     {    
  //   if(interpreter == null ){
  //     print('interpreter is NULL'); 
  //     return [];
  //   }
  //   List input = imageToByteListFloat32(img!, 112, 128, 128);
  //   input = input.reshape([1, 112, 112, 3]);
  //   List output = List.filled(1 * 192, null, growable: false).reshape([1, 192]);
  //   interpreter.run(input, output);
  //   output = output.reshape([192]); 
  //   e1 =  List.from(output); 
  //   // print('output e1 $e1'); 
  //   prosesController.switchCroping(false);
  //   return e1;
  // } 
  
  // Float32List imageToByteListFloat32(  imglib.Image image, int inputSize, double mean, double std) {
  //   var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  //   var buffer = Float32List.view(convertedBytes.buffer);
  //   int pixelIndex = 0;
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) { 
  //       imglib.Pixel pixel = image.getPixel(j, i);  
  //       buffer[pixelIndex++] = (pixel.r - mean) / std;
  //       buffer[pixelIndex++] = (pixel.g - mean) / std;
  //       buffer[pixelIndex++] = (pixel.b - mean) / std;   
  //     }
  //   }
  //   return convertedBytes.buffer.asFloat32List();  
  // }  

    /**
     *  Image
     */ 
  // Future<ResultTensor?> retImageCrop(tfl.Interpreter? interpreter) async  {
  Future<ResultTensor?> retImageCrop() async  {

    if( prosesController.croping.value == true){ 
      return null;
    }
    prosesController.switchCroping(true);

     final Uint8List? uint8list = await captureFromCam( cameraImage );
    //  if(uint8list == null) { return null; } 
     final _cropeImage = cropeImage( uint8list,   face); 
     return ResultTensor(full_image: uint8list , img: _cropeImage);
  }
  
  // Capture dari camera
  Future<Uint8List?> captureFromCam(CameraImage cameraImage)    {    
    final uint8list =    convertNative.convertImgToBytes(cameraImage.planes.first.bytes, 
                                                    cameraImage.width, 
                                                    cameraImage.height,
                                                    rotationFix: rotation,
                                                    quality: quality
                                                  );  
    return uint8list;
  }

  imglib.Image cropeImage(Uint8List? uint8list, Face face){   
 
        double x = (face.boundingBox.left );
        double y = (face.boundingBox.top );
        double w = (face.boundingBox.width );
        double h = (face.boundingBox.height );  

          imglib.Image? img  =   imglib.decodeImage(Uint8List.fromList(uint8list!)); 
          imglib.Image _croped =   imglib.copyCrop(img!,x: x.round()  , y: y.round()  , width: w.round()  , height: h.round() );  
          _croped = imglib.copyResizeCropSquare(_croped, size: 112);    
          
          // prosesController.switchCroping(false);  
          return _croped;
  } 

}// End

class ResultTensor{
  // final List dataTensor;
  // final double kemiripan;
  final full_image;
  final imglib.Image img; // imaage Crop

  // ResultTensor({required this.dataTensor, required this.kemiripan, required this.img});
  ResultTensor({  required this.full_image,  required this.img});
}