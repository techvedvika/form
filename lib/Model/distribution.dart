// To parse this JSON data, do
//
//     final distributionActivity = distributionActivityFromMap(jsonString);

import 'dart:convert';

DistributionActivity distributionActivityFromMap(String str) =>
    DistributionActivity.fromMap(json.decode(str));

String distributionActivityToMap(DistributionActivity data) =>
    json.encode(data.toMap());

class DistributionActivity {
  DistributionActivity({
    this.status,
    this.data,
  });

  int? status;
  List<Data1>? data;

  factory DistributionActivity.fromMap(Map<String, dynamic> json) =>
      DistributionActivity(
        status: json["status"],
        data: List<Data1>.from(json["data"].map((x) => Data1.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Data1 {
  Data1({
    this.id,
    this.itemName,
    this.programmeId,
  });

  String? id;
  String? itemName;
  String? programmeId;

  factory Data1.fromMap(Map<String, dynamic> json) => Data1(
        id: json["id"],
        itemName: json["item_name"],
        programmeId: json["programme_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "item_name": itemName,
        "programme_id": programmeId,
      };
}

