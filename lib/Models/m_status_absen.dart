// To parse this JSON data, do
//
//     final mStatusAbsen = mStatusAbsenFromJson(jsonString);

import 'dart:convert';

MStatusAbsen mStatusAbsenFromJson(String str) => MStatusAbsen.fromJson(json.decode(str));

String mStatusAbsenToJson(MStatusAbsen data) => json.encode(data.toJson());

class MStatusAbsen {
    bool? status;
    String? message;
    List<Datum>? data;

    MStatusAbsen({
        this.status,
        this.message,
        this.data,
    });

    factory MStatusAbsen.fromJson(Map<String, dynamic> json) => MStatusAbsen(
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
    String? nik;
    DateTime? signDate;
    String? keterangan;

    Datum({
        this.serial,
        this.nik,
        this.signDate,
        this.keterangan,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        serial: json["serial"],
        nik: json["nik"],
        signDate: json["sign_date"] == null ? null : DateTime.parse(json["sign_date"]),
        keterangan: json["keterangan"],
    );

    Map<String, dynamic> toJson() => {
        "serial": serial,
        "nik": nik,
        "sign_date": signDate?.toIso8601String(),
        "keterangan": keterangan,
    };
}
