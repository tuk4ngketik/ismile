// To parse this JSON data, do
//
//     final mCheckImei = mCheckImeiFromJson(jsonString);

import 'dart:convert';

MCheckImei mCheckImeiFromJson(String str) => MCheckImei.fromJson(json.decode(str));

String mCheckImeiToJson(MCheckImei data) => json.encode(data.toJson());
class MCheckImei {
    MCheckImei({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final Data? data;

    factory MCheckImei.fromJson(Map<String, dynamic> json){ 
        return MCheckImei(
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
        required this.createdDate,
        required this.createdBy,
        required this.status,
        required this.accSerial,
        required this.imeiPhone,
    });

    final String? serial;
    final DateTime? createdDate;
    final dynamic createdBy;
    final String? status;
    final String? accSerial;
    final String? imeiPhone;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            serial: json["serial"],
            createdDate: DateTime.tryParse(json["created_date"] ?? ""),
            createdBy: json["created_by"],
            status: json["status"],
            accSerial: json["acc_serial"],
            imeiPhone: json["imei_phone"],
        );
    }

    Map<String, dynamic> toJson() => {
        "serial": serial,
        "created_date": createdDate?.toIso8601String(),
        "created_by": createdBy,
        "status": status,
        "acc_serial": accSerial,
        "imei_phone": imeiPhone,
    };

}
