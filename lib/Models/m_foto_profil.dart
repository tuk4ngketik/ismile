// To parse this JSON data, do
//
//     final mFotoProfil = mFotoProfilFromJson(jsonString);

import 'dart:convert';

MFotoProfil mFotoProfilFromJson(String str) => MFotoProfil.fromJson(json.decode(str));

String mFotoProfilToJson(MFotoProfil data) => json.encode(data.toJson());

class MFotoProfil {
    bool? status;
    String? message;
    Data? data;

    MFotoProfil({
        this.status,
        this.message,
        this.data,
    });

    factory MFotoProfil.fromJson(Map<String, dynamic> json) => MFotoProfil(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String? fileName;
    String? fileNameOri;
    String? fileLocation;

    Data({
        this.fileName,
        this.fileNameOri,
        this.fileLocation,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        fileName: json["file_name"],
        fileNameOri: json["file_name_ori"],
        fileLocation: json["file_location"],
    );

    Map<String, dynamic> toJson() => {
        "file_name": fileName,
        "file_name_ori": fileNameOri,
        "file_location": fileLocation,
    };
}
