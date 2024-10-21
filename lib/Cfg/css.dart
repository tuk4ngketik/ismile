import 'package:flutter/material.dart';

class Css{

// Biru Dongker
// color: Color.fromRGBO(0, 20, 72, 1.0),

// FORM 
  // Form Border roundInput20
   
  static OutlineInputBorder formInputEnable = const OutlineInputBorder(
                      borderSide: BorderSide(width:1, strokeAlign: 0, color: Colors.yellow, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(20)),  
                    ); 

  static OutlineInputBorder formInputBorder = const OutlineInputBorder(
                      borderSide: BorderSide(width:1, strokeAlign: 0, color: Colors.red, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(20)),  
                    ); 

  static OutlineInputBorder formInputFocus = const OutlineInputBorder(
                      borderSide: BorderSide(width:1, strokeAlign: 0, color: Colors.green, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(20)),  
                    ); 

  static OutlineInputBorder formInputError = const OutlineInputBorder(
                      borderSide: BorderSide(width:1, strokeAlign: 0, color: Colors.black, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(20)),  
                    ); 

  static TextStyle jamInOut =  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey);

}