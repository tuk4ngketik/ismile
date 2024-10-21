// To parse this JSON data, do
//
//     final mLogin = mLoginFromJson(jsonString);

import 'dart:convert';

MLogin mLoginFromJson(String str) => MLogin.fromJson(json.decode(str));

String mLoginToJson(MLogin data) => json.encode(data.toJson());

class MLogin {
    bool? status;
    String? message;
    Data? data;

    MLogin({
        this.status,
        this.message,
        this.data,
    });

    factory MLogin.fromJson(Map<String, dynamic> json) => MLogin(
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
    String? serial;
    String? nik;
    String? namaDepan;
    String? namaBelakang;
    String? email;
    DateTime? tglLahir;
    String? jenisKelamin;
    String? division;
    String? deptSerial;
    String? jabatan;
    String? fileLocation;
    String? fileName; 
            String?   companySerial;
            String?   companyBranchSerial;

    Data({
        this.serial,
        this.nik,
        this.namaDepan,
        this.namaBelakang,
        this.email,
        this.tglLahir,
        this.jenisKelamin,
        this.division,
        this.deptSerial,
        this.jabatan,
        this.fileLocation,
        this.fileName,
        this.companySerial,
        this.companyBranchSerial,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        serial: json["serial"],
        nik: json["nik"],
        namaDepan: json["nama_depan"],
        namaBelakang: json["nama_belakang"],
        email: json["email"],
        tglLahir: json["tgl_lahir"] == null ? null : DateTime.parse(json["tgl_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        division: json["_division"],
        deptSerial: json["_dept_serial"],
        jabatan: json["jabatan"],
        fileLocation: json["file_location"],
        fileName: json["file_name"], 
        companySerial: json["company_serial"],
        companyBranchSerial: json["company_branch_serial"],
    );

    Map<String, dynamic> toJson() => {
        "serial": serial,
        "nik": nik,
        "nama_depan": namaDepan,
        "nama_belakang": namaBelakang,
        "email": email,
        "tgl_lahir": "${tglLahir!.year.toString().padLeft(4, '0')}-${tglLahir!.month.toString().padLeft(2, '0')}-${tglLahir!.day.toString().padLeft(2, '0')}",
        "jenis_kelamin": jenisKelamin,
        "_division": division,
        "_dept_serial": deptSerial,
        "jabatan": jabatan,
        "file_location": fileLocation,
        "file_name": fileName,
        "company_serial": companySerial,
        "company_branch_serial": companyBranchSerial,
    };
}
