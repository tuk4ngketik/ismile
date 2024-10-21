// ignore_for_file: file_names

import 'package:get/get.dart';

class ProsessController extends GetxController{

  final sibuk = false.obs;

  final croping = false.obs;

  final recog = false.obs;

  switchCroping(bool status){
    croping(status);
    // croping.value = status; 
  }

  switchRecog(bool status){
    recog(status);
    // recog.value = status; 
  }

}