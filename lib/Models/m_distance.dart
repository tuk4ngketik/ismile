// To parse this JSON data, do
//
//     final mDistance = mDistanceFromJson(jsonString);

import 'dart:convert';

MDistance mDistanceFromJson(String str) => MDistance.fromJson(json.decode(str));

String mDistanceToJson(MDistance data) => json.encode(data.toJson());

class MDistance {
    List<Datum>? data;
    String? message;
    bool? status;

    MDistance({
        this.data,
        this.message,
        this.status,
    });

    factory MDistance.fromJson(Map<String, dynamic> json) => MDistance(
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
    double? waktuEksekusi;
    double? distance;
    String? nik;

    Datum({
        this.waktuEksekusi,
        this.distance,
        this.nik,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        waktuEksekusi: json["Waktu Eksekusi"]?.toDouble(),
        distance: json["distance"],
        nik: json["nik"],
    );

    Map<String, dynamic> toJson() => {
        "Waktu Eksekusi": waktuEksekusi,
        "distance": distance,
        "nik": nik,
    };
}
