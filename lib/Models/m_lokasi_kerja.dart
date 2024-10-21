// To parse this JSON data, do
//
//     final mLokasiKerja = mLokasiKerjaFromJson(jsonString);

import 'dart:convert';

MLokasiKerja mLokasiKerjaFromJson(String str) => MLokasiKerja.fromJson(json.decode(str));

String mLokasiKerjaToJson(MLokasiKerja data) => json.encode(data.toJson());

class MLokasiKerja {
    bool? status;
    String? message;
    List<Datum>? data;

    MLokasiKerja({
        this.status,
        this.message,
        this.data,
    });

    factory MLokasiKerja.fromJson(Map<String, dynamic> json) => MLokasiKerja(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? serial;
    String? mesinName;
    String? mesinLocLat;
    String? mesinLocLog;

    Datum({
        this.serial,
        this.mesinName,
        this.mesinLocLat,
        this.mesinLocLog,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        serial: json["serial"],
        mesinName: json["mesin_name"],
        mesinLocLat: json["mesin_loc_lat"],
        mesinLocLog: json["mesin_loc_log"],
    );

    Map<String, dynamic> toJson() => {
        "serial": serial,
        "mesin_name": mesinName,
        "mesin_loc_lat": mesinLocLat,
        "mesin_loc_log": mesinLocLog,
    };
}
