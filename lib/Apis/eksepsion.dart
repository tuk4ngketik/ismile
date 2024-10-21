// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:http/http.dart';

class Ekseption{
  final e;

  Ekseption({required this.e});


    Object trow(){ 
          if ( e is FileSystemException ){
             print(' e is  FileSystemException');
             throw  FileSystemException(e.message);  
          }
          if ( e is CertificateException ){
             print(' e is  CertificateException');
             throw  CertificateException(e.message);  
          }
          if ( e is StdoutException ){
             print(' Ekseption is  StdoutException');
             throw  StdoutException(e.message);  
          }
          if ( e is StdinException ){
             print(' Ekseption is  StdinException');
             throw  StdinException(e.message);  
          }
          if ( e is ClientException ){
             print(' Ekseption is  ClientException');
             throw  ClientException(e.message);  
          }
          if ( e is SocketException){
             print(' Ekseption is  SocketException');
             throw  SocketException(e.message);  
          }
          if ( e is HttpException){
             print(' Ekseption is  HttpException');
             throw  HttpException(e.message);  
          }
          if ( e is HandshakeException ){
             print(' Ekseption is  HandshakeException');
             throw  HandshakeException(e.message);
          }
          if ( e is TlsException ){
             print(' Ekseption is  TlsException');
             throw  TlsException(e.message);
          }
          else{ 
             print('Ekseption else');
            throw  Exception(e.toString());
          }
    }
  
}