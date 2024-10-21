
 // ignore_for_file: avoid_print
 
import 'dart:typed_data'; 

import 'package:image/image.dart' as imglib;
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class MlService{
  
  // tfl.Interpreter? interpreter;
  // late tfl.Delegate delegate;

  
  List? e1;
  List? getE1 () => e1;

  // initialize() async { 
  //   try{ 
  //      interpreter = await tfl.Interpreter.fromAsset('assets/mobilefacenet.tflite');
  //     //  interpreter = await tfl.Interpreter.fromAsset('assets/mobilefacenet.tflite', options: interpreterOptions);
  //      print('ML Service run Load Model "interpreter" ');
  //   }catch (e){
  //     print('Failed to load model.');
  //     print(e);
  //   } 
  // }
  
  // close() => interpreter!.close(); 

  // imgToTensor(imglib.Image? img) {
  //   List input = imageToByteListFloat32(img!, 112, 112, 128); 
  //   input = input.reshape([1, 112, 112, 3]);
  //   List output = List.generate(1, (index) => List.filled(192, 0)); 
  //   interpreter?.run(input, output);
  //   output = output.reshape([192]);
  //   e1 = List.from(output);
  // } 

  Float32List imageToByteListFloat32(  imglib.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) { 
        var  pixel = image.getPixel(j, i);  
        buffer[pixelIndex++] = (pixel.r - mean) / std;
        buffer[pixelIndex++] = (pixel.g - mean) / std;
        buffer[pixelIndex++] = (pixel.b - mean) / std; 
      }
    }
    return convertedBytes.buffer.asFloat32List();  
  } 

  // Float32List imageToByteListFloat32(imglib.Image image) {
  //   var convertedBytes = Float32List(1 * 112 * 112 * 3);
  //   var buffer = Float32List.view(convertedBytes.buffer);
  //   int pixelIndex = 0;

  //   for (var i = 0; i < 112; i++) {
  //     for (var j = 0; j < 112; j++) {
  //       var pixel = image.getPixel(j, i);
  //       buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
  //       buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
  //       buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
  //     }
  //   }
  //   return convertedBytes.buffer.asFloat32List();
  // }

}