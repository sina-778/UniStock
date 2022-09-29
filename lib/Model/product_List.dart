// To parse this JSON data, do
//
//     final productList = productListFromJson(jsonString);

import 'dart:convert';

List<ProductList> productListFromJson(String str) => List<ProductList>.from(json.decode(str).map((x) => ProductList.fromJson(x)));

String productListToJson(List<ProductList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductList {
  ProductList({
    required this.xitem,
    required this.date,
    required this.xtime,
    required this.itemname,
    required this.supname,
    required this.xcount,
    required this.lastqty,
  });

  String xitem;
  String date;
  String xtime;
  String itemname;
  String supname;
  int xcount;
  int lastqty;

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    xitem: json["xitem"],
    date: json["date"],
    xtime: json["xtime"],
    itemname: json["itemname"],
    supname:  json["supname"],
    xcount: json["xcount"],
    lastqty: json["lastqty"],
  );

  Map<String, dynamic> toJson() => {
    "xitem": xitem,
    "date": date,
    "xtime": xtime,
    "itemname": itemname,
    "supname": supname,
    "xcount": xcount,
    "lastqty": lastqty,
  };
}
