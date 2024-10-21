// ignore_for_file: library_private_types_in_public_api, annotate_overrides, avoid_print, unused_element, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, unused_field, slash_for_doc_comments, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable
   
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart'; 
import 'package:path_provider/path_provider.dart';  
import 'package:image/image.dart' as imglib;

import '../Apis/a_distance.dart';
import '../Cfg/Sess.dart';
import '../Helper/func.dart'; 
import '../Helper/wg.dart';
import '../Models/G/Proses_comtroller.dart';
import '../Painter/face_detector_painter.dart';
import '../Service/camera-to-image.dart';
import '../Service/ml_service.dart';
import 'Absen/absen-valid.dart';
import 'home.dart';

late List<CameraDescription> _cameras; 

class Absen extends StatefulWidget{   
  final String resolution;  
  final  headers;
  final  postData;
  const Absen({super.key, required this.resolution, required this.headers,  required this.postData});
  @override
  _Absen createState() => _Absen();
}

class _Absen extends State<Absen> with WidgetsBindingObserver{
  
    // bool isOpencam = false;
    bool isFace = false, isWidth = false, isCenter = false, isSmile = false;   
    // bool sibuk = false, isCrop = false, isRecog = false;
    bool   isCrop = false, isRecognize = false, isIcondistance = false;
    File? filePicCrop;  
    var nik; // nik as sha1 
    Color color_indikator = Colors.white60;

    ApiDistance apiDistance = ApiDistance();
  
  final prosesController = Get.put(ProsessController()); 
  Sess sess = Sess(); 
  CameraController? _cameraController;  

  // Paint
  CustomPaint? customPaint; 
   
  final  faceDetector = FaceDetector(
                    options: FaceDetectorOptions(
                      enableClassification: true,
                      enableLandmarks: true,
                      // enableContours: true,
                      performanceMode: FaceDetectorMode.accurate
                    )
              );   
  MlService mlService = MlService();

  List  profilpicTensor = [];
  List  dataTensorStream = [];
  double  hasilKalikulasiFace = 0;   

  String jam(){
    DateTime d = DateTime.now(); 
    String now ='${d.year}:${d.month}:${d.day} ${d.hour}:${d.minute}:${d.second}';  
    return now;
  }  
  
  initState(){  
    WidgetsBinding.instance.addObserver(this); 
    var bytes = utf8.encode(widget.postData['nik']); // data being hashed  
    
        if (!mounted) { return;  } 
    setState(() => nik = sha1.convert(bytes) );
    // print('DON:: ${widget.postData}');
    _openCam();   
    _getFilePic();   
    super.initState(); 
  }  
  void dispose(){ 
    faceDetector.close(); 
    _cameraController?.dispose();   
    customPaint = null;
    super.dispose();  
  }
   
  String? str_file;
  _getFilePic() async { 
     final dir = await  getTemporaryDirectory();    
        if (!mounted) { return;  } 
     setState( () => str_file = '${dir.path}/profil_crop.jpg' );
  }  
   
   Future<void>  _openCam() async { 
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }  
    _cameraController = CameraController( _cameras[1], ResolutionPreset.medium,  
                                          //  _cameras[1], ResolutionPreset.low, 
                                          enableAudio: false,  
                                          imageFormatGroup:   Platform.isAndroid 
                                                                ? ImageFormatGroup.nv21 // for Android ^0.10.6
                                                                : ImageFormatGroup.bgra8888, // for iOS
                                        );    
     
    final CameraController? camera = _cameraController; 
      // print('DON:: Before  _cameraController!.initialize()' ); 
      await camera!.initialize().then((_) async{ 
        // print('DON:: _cameraController!.initialize() ' );
        if (!mounted) { return;  }  
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('Handle access errors here');
              break;
            default:
              print('Handle other errors here');
              break;
          }
        }
      });   
      await _startStream();   
   }

  Future<void>  _startStream() async {   
    
    final CameraController? camera = _cameraController;
    
        // print("DON:: First .aspectRatio ${camera!.value.aspectRatio}");   

    if (camera == null  ) { 
      // print('DON:: DBG  _startStream() _cameraController = null ');  
      return; 
    }   
    
    // print('DON::  run _startStream()' );   
    bool sibuk = false;
    // await camera.startImageStream( _handleStream ); 
    await camera.startImageStream((cameraImage) async {  

        // print("DON:: First .aspectRatio ${camera.value.aspectRatio} Width: ${cameraImage.width} x ${cameraImage.height}");   
        // double getMinZoomLevel = await camera.getMinZoomLevel(); 
        // print("DON:: getMinZoomLevel $getMinZoomLevel Max: ${camera.getMaxZoomLevel()}");  

        // if (camera == null ) { 
        //   customPaint = null;
        //   return; 
        // }     
 
        if( isRecognize  == true ){   
          await camera.pausePreview();
          // print("DON:: isRecognize $isRecognize");
          return ;  
        }

        if( isCrop  == true ){   
          await camera.pausePreview();
          // print("DON:: isCrop");
          return ;   
        }

        if( sibuk  == true ){  
          // print("DON:: SIBUK");
          return ;  
        }  

        sibuk = true; 
          final inputImage = _inputImageFromCameraImage (cameraImage);  
          if(inputImage == null ) {
            // print('DON:: run __handleStream() :: inputImage == null ');  
            sibuk = false;
            return ; 
          }
          final faces = await faceDetector.processImage(inputImage); 
          if(faces.isEmpty){
              customPaint = null;
              // print('DON:: run __handleStream() :: faces.isEmpty '); 
              sibuk =  false; 
              if(!mounted) { return;} 
              setState((){ 
                isFace =  false ;
                isCenter =false;
                isSmile =  false; 
                color_indikator = Colors.white60;
              });    
              return;   
          } 
          setState(() => isFace =  true );   
          // NEXT
    
          // print('DON Face detected');
          final painter = FaceDetectorPainter(
                    faces,
                    inputImage.metadata!.size,
                    inputImage.metadata!.rotation,
                    CameraLensDirection.front
                  ); 

          customPaint = CustomPaint(
                    painter: painter,
                    // child: const Center(child: Text('Name of Image'),),
                    willChange: true,
                    isComplex: true,
                  );    
          // Face Center Here
                  
        await _handleFace(faces[0], cameraImage, camera);  
        sibuk =  false;  

     }, ); 
    // _startCounter(); 
  }  
  
  final frameWidth = Get.width;
  final frameHeight = Get.height; 
  final scr_w_2 =  Get.width / 2;
  final scr_h_2 =  Get.height / 2;
  int camera_w = 0, camera_h = 0;
  Future<void> _handleFace(face, cameraImage,  camera ) async {   
      final Rect boundingBox = face.boundingBox;   
        if (!mounted) { return;  } 
      setState(() {  
        rect = '$boundingBox' ;   
        camera_w = cameraImage.width;  camera_h = cameraImage.height;
        bounding_width = boundingBox.width;
        bounding_width_2 = bounding_width / 2;
        bounding_height = boundingBox.height;
        bounding_height_2 = bounding_height / 2;
        sisa_screen_w = frameWidth - bounding_width;  
        sisa_screen_w_2 = sisa_screen_w / 2;
        sisa_screen_h = frameHeight - bounding_height;
        sisa_screen_h_2 = sisa_screen_h / 2;  
      });

      if ( _isWidth(  boundingBox) == false ){ return;  } 
      // print('DON:: _isWidth: $_isWidth');

      if ( _isCenter(boundingBox) == false){   
        if (!mounted) { return;  } 
        setState(() {
          msgInfo = 'Posisikan wajah pada area lingkaran';
        });
        return;   
      }
      // print('DON:: _isCenter: $_isCenter'); 

      if (  _isSmile( face ) == false ){
        // print('DON:: _isSmile: false_ $isSmile');
        return;
      }   
      // print('DON:: _isSmile: true_ $isSmile');
    
    if( isCrop  == true  ){  
      // print('DON:: isCrop  == true => TRUE');
      return ;  
    }
    isCrop = true; 
    final _img = CameraToImage(cameraImage: cameraImage, face: face );
    final _ret = await _img.retImageCrop(); 
    if(_ret == null) { isCrop = false; return ;  } 
     
    Uint8List? uint8listCropFromCam = imglib.encodeJpg(_ret.img); 
    String? str_base64 =  base64Encode(uint8listCropFromCam); 
     isCrop = false; 
    
    if( isRecognize == true) {  return ; }  // 09-07-2024
    isRecognize = true;
    _distanceFace(camera, str_base64, _ret.full_image, uint8listCropFromCam);
      str_base64 = null;
      uint8listCropFromCam = null;
      customPaint = null; 
      isRecognize = false;
  } 

  Future<void> _distanceFace(CameraController camera, String img_crop, Uint8List imageCaptured, Uint8List uint8listCropFromCam)async { 
    // prosesController.switchRecog(true); 
    var formData = {
      'nik' : '$nik',
      'img_crop' : img_crop
    }; 
    // print('DON:: data :: img_crop :: $formData');
    // catch OK
    await apiDistance.postDistancebase64(formData, widget.headers).then((v) async {  
      bool? status = v!.status;
      String? msg = v.message;
      if( (status != true) && (msg != 'success')){
        prosesController.switchRecog(false);
        prosesController.switchCroping(false);    
        // isRecog =  false; 
        if (!mounted) { return;  } 
        setState(() {
          isIcondistance = true;
          color_indikator = Colors.red;
        });
        await Future.delayed(const Duration( seconds: 1));
        if(camera.value.isPreviewPaused) {
          // print("DON:: isPreviewPaused ${camera.value.isPreviewPaused}");
          await camera.resumePreview();
        if (!mounted) { return;  } 
          setState(() => isIcondistance = false );
        }
        return  ;
      } 
      _stopCam();
      // formData = {}; 
      var data = v.data;
      double? distance = data![0].distance;
      final postData = widget.postData;
      postData['ponsel_time'] = jam(); 
      // print('DON:: _distanceFace');
      // print('DON:: headers ${widget.headers}');
      // print('DON:: postData: $postData');
      Get.offAll(AbsenValid(headers: widget.headers, postData: widget.postData, hasilKalikulasiFace:  distance!, imageCaptured: imageCaptured, imageCapturedCrop: uint8listCropFromCam));  
      // Get.toEnd(()=> AbsenValid(headers: widget.headers, postData: widget.postData, hasilKalikulasiFace:  distance!, imageCaptured: imageCaptured, imageCapturedCrop: uint8listCropFromCam));  
      
    })
    .catchError((onError){ 
      prosesController.switchRecog(false); 
      _stopCam();
      defaultDialogErrToHome('${onError.message}');
      print('${onError.message }');
    });
  }

  @override
  Widget build(BuildContext context) {  
    return ( _cameraController == null ||  _cameraController!.value.isInitialized == false   ) 
      ? const Center(child: CircularProgressIndicator(color: Colors.green,),) :
       (  _cameraController!.value.isStreamingImages == false   ) ? const Center(child: CircularProgressIndicator(color: Colors.indigo,),) : 
       Scaffold(
      // appBar:  AppBar(),  
      appBar:  appbar0(),  
      body:  Stack(
        
                // fit: StackFit.expand,
                children: [
                  
                //  Container(
                //   width: Get.width,
                //   child: CameraPreview(_cameraController!, child:  customPaint,)
                //  ),  
                //  CameraPreview(_cameraController!, child:  customPaint,),  

                  // Default | OK
                  // SizedBox(
                  //   height: double.infinity,
                  //   width: double.infinity,
                  //   // child : CameraPreview(_cameraController!, child:( isFace == true ) ? customPaint : null), 
                  //   // child : CameraPreview(_cameraController!, child: customPaint ), 
                  //   child : CameraPreview(_cameraController!), 
                  // ),  

                  // AspectRatio(
                  //   // aspectRatio: MediaQuery.of(context).size.aspectRatio,
                  //   aspectRatio: 0.8,
                  //   // aspectRatio: _cameraController!.value.aspectRatio,
                  //   // aspectRatio: 1,
                  //   child: CameraPreview(_cameraController!), 
                  // ),

                  // FittedBox(
                  //   fit: BoxFit.cover,
                  //   child: CameraPreview(_cameraController!),
                  // ),
                  
                  SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: Transform.scale(
                      // scale: (Get.width / Get.height) / _cameraController!.value.aspectRatio, // ress <
                      // scale: _cameraController!.value.aspectRatio / (Get.width / Get.height), // ress >
                      // scale: _cameraController!.value.aspectRatio,
                      scale:1, // _cameraController!.value.aspectRatio , 
                      // child: CameraPreview(_cameraController!, child: customPaint,),
                      child: AspectRatio( 
                        aspectRatio: 0.6,
                        // aspectRatio: _cameraController!.value.aspectRatio ,
                        child: CameraPreview(_cameraController!, child: customPaint,),
                      ), 
                    ),
                  ),
                  
                  (isIcondistance == true ) ? iconDistance() : const Text(''),

                  // Overlay 
                  overlayFaceCam(color_indikator),

                  /*  Widget Debuging */ 
                  // _garisTengah(),                    
                  // _wgTextDebug(),
                  _wgInfo()

                ],
              ), 
      bottomNavigationBar:_bottomNavigationBar(),
    );
  }
   
  _stopCam() async {  
    // sibuk = true;
    customPaint = null;  
    final CameraController? camera = _cameraController;
    if (camera == null ) { 
    // if (_cameraController == null ) { 
      print('run _stopCam() _cameraController = null ');  
      return; 
    }   
    if(camera.value.isStreamingImages == true){
    // if(_cameraController!.value.isStreamingImages == true){
    //  await _cameraController!.stopImageStream(); // rm 
     await camera.stopImageStream();
      // print('DON::  camera.stopImageStream() '); 
    }
    // _cameraController!.dispose();
    camera.dispose(); 
    _cameraController =  null; // rm
    if (!mounted) { return;  } 
    setState(() => isFace =  true );  
    setState((){
      isCenter = false;
      isSmile = false; 
    });   
  }

  void didChangeAppLifecycleState(AppLifecycleState state) { 
    // print('DON state: $state');
    
    if (state == AppLifecycleState.resumed) {
        // print('DON AppLifecycleState.resumed ${ AppLifecycleState.resumed}');
        _openCam();
    }    
    if (state == AppLifecycleState.hidden) {
        // print('DON AppLifecycleState.hidden ${ AppLifecycleState.hidden}');
        _stopCam();
        // _stopCounter();
    }
    if (state == AppLifecycleState.paused) {
        // print('DON AppLifecycleState.paused ${ AppLifecycleState.paused}');
        //do your stuff
        _stopCam();
        // _stopCounter();
    }
    if (state == AppLifecycleState.inactive) {
        // print('DON AppLifecycleState.inactive ${ AppLifecycleState.inactive}');
        //do your stuff
        _stopCam();
        // _stopCounter();
    }  
  }
 
  final _orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };
  
  InputImage? _inputImageFromCameraImage(CameraImage image) {  // OK
    final CameraController? camera = _cameraController;
    if (camera == null) { return null; }
    if (camera.value.isInitialized == false) { return null; }
    if (camera.value.isStreamingImages == false) { return null; }
    // print('FON:: DBG  _inputImageFromCameraImage(CameraImage image)'); 
    InputImageRotation? rotation;
    final sensorOrientation = _cameras[1].sensorOrientation; 
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation); 
    } else if (Platform.isAndroid) {
        // print('FON:: DBG  _inputImageFromCameraImage() :: Platform.isAndroid'); 
      var rotationCompensation =  _orientations[ _cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (_cameras[1].lensDirection == CameraLensDirection.front) {
        // print('FON:: DBG  _inputImageFromCameraImage() ::CameraLensDirection.front'); 
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360; 
      } else { 
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360; 
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation); 
    }
    if (rotation == null) {return null;} 
        // print('DON:: rotation  _inputImageFromCameraImage() :: $rotation'); 
 
    final format = InputImageFormatValue.fromRawValue(image.format.raw);  
    // print('DON:: format  _inputImageFromCameraImage() :: $format'); 
    if (format == null ||
        // (Platform.isAndroid && format != InputImageFormat.yuv_420_888) ||  // camera: > ^0.10.6
        (Platform.isAndroid && format != InputImageFormat.nv21) ||            // camera: <= ^0.10.6
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
              //  print('DON:: DBG  _inputImageFromCameraImage() :: format == null'); 
               return null;
            } 

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1){ return null;}
    final plane = image.planes.first;
    // print('DON:: image.width.toDouble() :: ${image.width.floor()}  ${image.height.floor()}'); 
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );  
  }  

  String rect = '';
  double toleransi = 20;  
  double bounding_width = 0, bounding_width_2 = 0 , bounding_height = 0, bounding_height_2 = 0;
  double sisa_screen_w = 0, sisa_screen_w_2 = 0, center_face_w = 0;
  double sisa_screen_h = 0, sisa_screen_h_2 = 0,  center_face_h = 0; 
  
  bool _isWidth(Rect boundingBox){   
      // if (boundingBox.width > 135 && boundingBox.width <= 200){
      if (  boundingBox.width <= 230){
        if (!mounted) { return false;  } 
        setState(()   {
          isWidth =  true; 
          color_indikator = Colors.yellow;
        } );
      }else{
        if (!mounted) { return false;  } 
        setState((){ 
          isWidth =  false; 
          isCenter = false;
          isSmile = false;
          color_indikator = Colors.red;
        });
      }  
      return isWidth;
  }
   
  bool _isCenter(Rect boundingBox){
 
    final left = boundingBox.left; 
    final top = boundingBox.top; 
    if (!mounted) { return false;  } 
    
    setState(() {   
      center_face_w = left + bounding_width / 4 ;   
      // center_face_h = top + bounding_height  ;
      center_face_h = (top + bounding_height) /4; // 17-09-2004
      // Tab only
      // center_face_w = left + bounding_width ;   
      // center_face_h = top + bounding_height; 
    });

    if( 
        center_face_w <= ( scr_w_2 + toleransi)  
        && center_face_w >= ( scr_w_2 - toleransi)  
          // && center_face_h <= ( scr_h_2 + toleransi)
          // && center_face_h >= (scr_h_2 - toleransi)

        // Tab only
        // center_face_w <= ( scr_w_2 + toleransi)  
        // && center_face_w >= ( scr_w_2 - toleransi)  
        // && center_face_h <= ( scr_h_2 + toleransi)
        // && center_face_h >= (scr_h_2 - toleransi)
 
       ){
        if (!mounted) { return false;  } 
          setState(()  { 
            isCenter = true; 
            msgInfo = 'Silahkan senyum untuk verifikasi';
          });
          color_indikator = Colors.yellow;
          // print("DON:: CENTER FACE");
          return true;
        }
        if (!mounted) { return false;  } 
      setState(()  { 
        isCenter = false;
        isSmile = false; 
        color_indikator = Colors.red;
      });
      // print("DON:: NOT CENTER FACE");
      return false;  
  }
   
  bool _isSmile(Face face){     
    
    if (face.smilingProbability != null) {
      final double? smileProb = face.smilingProbability;  
      // if(smileProb! >= 0.99){
      if(smileProb! >= 0.5){
        if (!mounted) { return false;  } 
        setState(() {
          isSmile = true; 
          color_indikator = Colors.green;
          msgInfo = 'Wajah sedang diverifikasi';
        }); 
        // print("DON:: face is smiling ");
      } else{
        if (!mounted) { return false;  } 
        setState(()  => isSmile = false); 
        // print("DON:: !!!! face is smiling ");
      } 
    } 
      return isSmile;
  }  

  Widget iconDistance(){
    return Center(
      child: Container( 
        padding: const EdgeInsets.all(5),
        decoration:   const BoxDecoration(
        color: Colors.white60,
          shape: BoxShape.circle,
        ), 
        child: const Icon(Icons.back_hand, color: Colors.red,size: 50,weight:10 ,)
      )
    );
  }

  Widget _header(){
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(top:20, left: 20, right: 20),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.indigoAccent,  
        borderRadius: BorderRadius.all(Radius.circular(30))
      ), 
      child: Row(
        children: [
          const Flexible(
            flex: 8 ,
            fit: FlexFit.tight,
           child:  Text('VIL Grup Presensi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white ),),  
          ), 
          Align(
            alignment: Alignment.centerRight, 
            child: Text( getDate(), style: const TextStyle(color: Colors.amber), )
          )
        ],
      ),
    );
  }

  Widget _bottomNavigationBar(){
    return Container(
        height: 100,
        color: Colors.black,
        child: Center(
          child: TextButton.icon(onPressed: (){ 
            _stopCam();
            Get.off( const Home());
          },  
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.white,),
            label: const Text('Kembali', style: TextStyle(color: Colors.white),)
          ),
        ),
      );
  }
  
  Widget _garisTengah(){
    return Container(
      height: Get.height / 2,
      width: Get.width / 2,
      decoration: BoxDecoration( 
        border: Border.all(color: Colors.red)
      ),);
  }

  Widget _wgTextDebug(){
   return  Positioned(
                    bottom: 10, 
                    width: Get.width,
                    child:   Column(
                      children: [ 
                        Center(child: Text(' Width: ${Get.width.floor()} / ${scr_w_2.floor()} | ${scr_w_2.floor()} - Height: ${Get.height.floor()}', 
                          style: const TextStyle(backgroundColor: Colors.yellow, ))),Container(height: 5,),                         
                        // Center(child: Text(' camera_w: ${camera_w.floor()} | ${camera_h.floor()}', 
                        //   style: const TextStyle(backgroundColor: Colors.yellow, ))),Container(height: 5,), 
                        Center(child: Text('Bnd Width: $bounding_width  - ssc_w: ${sisa_screen_w.floor()} - ssc_w_2: ${sisa_screen_w_2.floor()}', 
                          style: const TextStyle(backgroundColor: Colors.yellow, ))),Container(height: 5,),   
                        Center(child: Text('Bnd Height: $bounding_height - ssc_h: ${sisa_screen_h.floor()} - ssc_h_2: ${sisa_screen_h_2.floor()}', 
                          style: const TextStyle(backgroundColor: Colors.yellow,))),Container(height: 5,),   
                        Center(child: Text('$rect ', 
                          style: const TextStyle(backgroundColor: Colors.yellow, ))),Container(height: 5,),   
                        Center(child: Text('center_face_w: ${center_face_w.floor()} | center_face_h: ${center_face_h.floor()}', 
                          style: const TextStyle(backgroundColor: Colors.yellow, ))),Container(height: 5,),   
                        Center(child: Text('Width: $isWidth | Center: $isCenter | Smile: $isSmile ', 
                          style: const TextStyle(backgroundColor: Colors.yellow, ))),Container(height: 5,),   
                        // Center(child: Text('capture ${prosesController.croping.value} | recog ${prosesController.recog.value}', 
                        //   style: const TextStyle(backgroundColor: Colors.yellow,  ))),Container(height: 5,),   
                       ],
                    ),
                  );
  }

  String msgInfo = '';
  Widget _wgInfo(){
   return  Positioned(
                    top: 10, 
                    width: Get.width,
                    child:  Align( 
                      alignment: Alignment.center,
                      child: Card( 
                        color: Colors.yellowAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Icon(Icons.info_outline_rounded, color: Colors.indigo,),
                              const Text('Pastikan pencahayaan cukup', style: TextStyle(fontSize: 12, color: Colors.indigo),),
                              Text( msgInfo , style: const TextStyle(fontSize: 12, color: Colors.indigo),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
  }

}//END