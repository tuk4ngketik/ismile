// To parse this JSON data, do
//
//     final mDept = mDeptFromJson(jsonString);

import 'dart:convert';

MDept mDeptFromJson(String str) => MDept.fromJson(json.decode(str));

String mDeptToJson(MDept data) => json.encode(data.toJson());

class MDept {
    MDept({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final Data? data;

    factory MDept.fromJson(Map<String, dynamic> json){ 
        return MDept(
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
        required this.deptName,
        required this.divisionName,
    });
 
    final String? divisionName;
    final String? deptName;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data( 
            divisionName: json["division_name"],
            deptName: json["dept_name"],
        );
    }

    Map<String, dynamic> toJson() => { 
        "division_name": divisionName,
        "dept_name": deptName,
    };

}
