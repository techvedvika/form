// To parse this JSON data, do
//
//     final blockModel = blockModelFromJson(jsonString);

import 'dart:convert';

List<BlockModel> blockModelFromJson(String str) =>
    List<BlockModel>.from(json.decode(str).map((x) => BlockModel.fromJson(x)));

String blockModelToJson(List<BlockModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlockModel {
  BlockModel({
    this.blockId,
    this.stateId,
    this.districtId,
    this.blockName,
    this.status,
  });

  String? blockId;
  String? stateId;
  String? districtId;
  String? blockName;
  String? status;

  factory BlockModel.fromJson(Map<String, dynamic> json) => BlockModel(
        blockId: json["blockId"],
        stateId: json["stateId"],
        districtId: json["DistrictId"],
        blockName: json["blockName"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "blockId": blockId,
        "stateId": stateId,
        "DistrictId": districtId,
        "blockName": blockName,
        "status": status,
      };
}
