// To parse this JSON data, do
//
//     final mLokasiKerjaDefault = mLokasiKerjaDefaultFromJson(jsonString);

import 'dart:convert';
 

MLokasiKerjaDefault mLokasiKerjaDefaultFromJson (String str) => MLokasiKerjaDefault.fromJson(jsonDecode(str));

String mLokasiKerjaDefaultToJson(MLokasiKerjaDefault data) => jsonEncode(data.toJson());
class MLokasiKerjaDefault {
    MLokasiKerjaDefault({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final Data? data;

    factory MLokasiKerjaDefault.fromJson(Map<String, dynamic> json){ 
        return MLokasiKerjaDefault(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };

}

class Data {
    Data({
        required this.serial,
        required this.mesinName,
        required this.mesinLocLat,
        required this.mesinLocLog,
    });

    final String? serial;
    final String? mesinName;
    final String? mesinLocLat;
    final String? mesinLocLog;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            serial: json["serial"],
            mesinName: json["mesin_name"],
            mesinLocLat: json["mesin_loc_lat"],
            mesinLocLog: json["mesin_loc_log"],
        );
    }

    Map<String, dynamic> toJson() => {
        "serial": serial,
        "mesin_name": mesinName,
        "mesin_loc_lat": mesinLocLat,
        "mesin_loc_log": mesinLocLog,
    };

}
