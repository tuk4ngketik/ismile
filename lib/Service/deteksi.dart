// ignore_for_file: avoid_print, unnecessary_nullable_for_final_variable_declarations

import 'package:google_ml_kit/google_ml_kit.dart';

class Deteksi{
  

  late Face face;
  Face getFace() => face;

  late FaceDetector faceDetector ; 

  initialize(){

    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate
    );

    faceDetector = FaceDetector(options: options);

  }
  
  close(){
    faceDetector.close();
  }

  Future<void> deteksiWajah(InputImage inputImage) async{
    try {
      final faces = await faceDetector.processImage(inputImage); 
      if(faces.isEmpty) {
        print('Deteksi.deteksiWajah: No FAce');
        return;
      } 
      extractFaces(faces);
    } catch (e) {
      print('Deteksi.deteksiWajah() Err: $e');
      return;
    } 
  }

  extractFaces(List<Face> faces){
    
      face = faces[0];
    // for(Face _face in faces){
    //   face = _face;
    // }
  }
  
}// End