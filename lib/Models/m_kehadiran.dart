// To parse this JSON data, do
//
//     final MKehadiran = mKehadiranToJson(jsonString);

import 'dart:convert';

MKehadiran mKehadiranFromJson(String str) => MKehadiran.fromJson(json.decode(str));

String mKehadiranToJson(MKehadiran data) => json.encode(data.toJson());
class MKehadiran {
    MKehadiran({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final List<Datum> data;

    factory MKehadiran.fromJson(Map<String, dynamic> json){ 
        return MKehadiran(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
    };

}

class Datum {
    Datum({
        required this.nik,
        required this.signDate,
        required this.keterangan,
        required this.fileFoto,
    });

    final String? nik;
    final DateTime? signDate;
    final String? keterangan;
    final String? fileFoto;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            nik: json["nik"],
            signDate: DateTime.tryParse(json["sign_date"] ?? ""),
            keterangan: json["keterangan"],
            fileFoto: json["file_foto"],
        );
    }

    Map<String, dynamic> toJson() => {
        "nik": nik,
        "sign_date": signDate?.toIso8601String(),
        "keterangan": keterangan,
        "file_foto": fileFoto,
    };

}
