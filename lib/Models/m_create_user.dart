// To parse this JSON data, do
//
//     final creaUser = creaUserFromJson(jsonString);

import 'dart:convert';

CreaUser creaUserFromJson(String str) => CreaUser.fromJson(json.decode(str));

String creaUserToJson(CreaUser data) => json.encode(data.toJson());

class CreaUser {
    List<Datum>? data;
    String? message;
    bool? status;

    CreaUser({
        this.data,
        this.message,
        this.status,
    });

    factory CreaUser.fromJson(Map<String, dynamic> json) => CreaUser(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Datum {
    String? folder;
    String? img;
    double? waktuEksekusi;
    String? base64;
    String? encoding;

    Datum({
        this.folder,
        this.img,
        this.waktuEksekusi,
        this.base64,
        this.encoding,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        folder: json["Folder"],
        img: json["Img"],
        waktuEksekusi: json["Waktu Eksekusi"]?.toDouble(),
        base64: json["base64"],
        encoding: json["encoding"],
    );

    Map<String, dynamic> toJson() => {
        "Folder": folder,
        "Img": img,
        "Waktu Eksekusi": waktuEksekusi,
        "base64": base64,
        "encoding": encoding,
    };
}
