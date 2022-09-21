// To parse this JSON data, do
//
//     final itemInfo = itemInfoFromJson(jsonString);

import 'dart:convert';

ItemInfo itemInfoFromJson(String str) => ItemInfo.fromJson(json.decode(str));

String itemInfoToJson(ItemInfo data) => json.encode(data.toJson());

class ItemInfo {
  ItemInfo({
    required this.qty,
    required this.xitem,
    required this.xdesc,
    required this.xcus,
    required this.xcusname,
    required this.xbodycode,
    required this.xoldcode,
  });

  int qty;
  String xitem;
  String xdesc;
  String xcus;
  String xcusname;
  String xbodycode;
  String xoldcode;

  factory ItemInfo.fromJson(Map<String, dynamic> json) => ItemInfo(
        qty: json["qty"],
        xitem: json["xitem"],
        xdesc: json["xdesc"],
        xcus: json["xcus"],
        xcusname: json["xcusname"],
        xbodycode: json["xbodycode"],
        xoldcode: json["xoldcode"],
      );

  Map<String, dynamic> toJson() => {
        "qty": qty,
        "xitem": xitem,
        "xdesc": xdesc,
        "xcus": xcus,
        "xcusname": xcusname,
        "xbodycode": xbodycode,
        "xoldcode": xoldcode,
      };
}
