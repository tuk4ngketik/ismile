// Tanggal, Jam, Waktu, Split

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:intl/intl.dart';

String getDate(){ // INdo
        final  now =   DateTime.now();
        // final  _hari =   DateFormat("EEEE", 'id');
        final  formatter =   DateFormat("d MMMM yyyy", 'id');
        // final  formatter =   DateFormat('dd-MM-yyy');
        return  formatter.format(now); 
}

String bulanTahun(){ // INdo
        final  now =   DateTime.now();
        // final  _hari =   DateFormat("EEEE", 'id');
        final  formatter =   DateFormat("MMMM yyyy", 'id'); 
        return  formatter.format(now); 
}

String getDateEng(){ 
  final  now =   DateTime.now();
  final  formatter =   DateFormat("yyyy-MM-dd", 'EN');
  return  formatter.format(now); 
} 

String getCurrMonth(){ 
  final  now =   DateTime.now();
  final  formatter =   DateFormat("yyyy-MM", 'EN');
  return  formatter.format(now); 
} 

String getDay(){
        final  now =   DateTime.now();
        final  _hari =   DateFormat("EEEE", 'id');
        return  _hari.format(now); 
}

String convertJmd(DateTime datetime){  
        // final datetime = DateTime.now(); 
        final jam  = datetime.hour.toString().padLeft(2, '0');
        final menit  = datetime.minute.toString().padLeft(2, '0');
        final detik = datetime.second.toString().padLeft(2, '0');
        return '$jam:$menit:$detik';
}
String convertTbt(DateTime datetime){  
        final tgl  = datetime.day.toString().padLeft(2, '0'); 
        final bln  = datetime.month.toString().padLeft(2, '0');
        final thn = datetime.year;
        return '$tgl-$bln-$thn';
}
String convertYmd(DateTime datetime){  
        final tgl  = datetime.day.toString().padLeft(2, '0');
        final bln  = datetime.month.toString().padLeft(2, '0');
        final thn = datetime.year;
        return '$thn-$bln-$tgl';
}
String convertHari(DateTime datetime){ 
        final  _hari =   DateFormat("EEEE", 'id');
        return  _hari.format(datetime);  
}




double euclideanDistance(List? e1, List? e2) {
  double sum = 0.0;
  if (e1 == null || e2 == null) {return sum;}
    
  for (int i = 0; i < e1.length; i++) {
    sum += pow((e1[i] - e2[i]), 2);
  }
  return sqrt(sum);
} 

int fromList(List<String> list, String val){ 
  int i = list.indexWhere((item) => item == val);
  return i;
}

fromMap(var map){
  var key = map.keys.firstWhere((k) => map[k] == 'Brazil', orElse: () => null);
  return key; 
}