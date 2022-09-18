import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import 'Model/ItemInfo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _scanBarcode = 'Unknown';
  String? scannedResult;
  int qty = 1;

  @override
  void initState() {
    super.initState();
  }

  Future<List<ItemInfo>>? futurePost;
  api() async {
    scanBarcodeNormal();
    print("1");
    Future<List<ItemInfo>> fetchPost() async {
      print("object");
      var response = await http.post(
          Uri.parse('http://172.20.20.69/sina/unistock/item_info.php'),
          body: jsonEncode(<String, String>{
            "item": _scanBarcode,
          }));

      print(response.body);

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed.map<ItemInfo>((json) => ItemInfo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load album');
      }
    }
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  //post method for barcode scanned value
  Future<void> postScannedResult() async {
    var response = http.post(Uri.parse("Api Link will be added here"),
        body: jsonEncode(<String, dynamic>{"something": "$scannedResult"}));
    // print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amberAccent,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Text(
                    ' UniStock',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(builder: (BuildContext context) {
              return Container(
                alignment: Alignment.center,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: RaisedButton(
                        child: Column(
                          children: [
                            Icon(
                              Icons.qr_code_2_rounded,
                              size: 50,
                            ),
                            Text("SCAN"),
                          ],
                        ),
                        onPressed: () async {
                          api();
                          print('SCAN');

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Scan result',
                                      style: TextStyle(fontSize: 20)),
                                  content: FutureBuilder<List<ItemInfo>>(
                                    future: futurePost,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (_, index) => Column(
                                            children: [
                                              Text(
                                                  "Item: ${snapshot.data![index].xitem}",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Text(
                                                  "Cus: ${snapshot.data![index].xcus}",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                        );
                                      }

                                      // By default, show a loading spinner.
                                      return AlertDialog(
                                        title: Text('Scan result',
                                            style: TextStyle(fontSize: 20)),
                                        content: Column(
                                          children: [
                                            Text('Item Code: $_scanBarcode',
                                                style: TextStyle(fontSize: 24)),
                                            Text("Item Name: ")
                                          ],
                                        ),
                                        actions: [
                                          FlatButton(
                                            color: Color(0xFF8CA6DB),
                                            onPressed: () {
                                              //Navigator.pop(context);
                                              // print(addworkNote);
                                              //
                                              // addUsers();
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                        scrollable: true,
                                      );
                                    },
                                  ),
                                  actions: [
                                    FlatButton(
                                      color: Color(0xFF8CA6DB),
                                      onPressed: () {
                                        //Navigator.pop(context);
                                        // print(addworkNote);
                                        //
                                        // addUsers();
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                  scrollable: true,
                                );
                              });
                        }),
                  ),
                  Text('Scan result : $_scanBarcode\n',
                      style: TextStyle(fontSize: 20)),
                  Text("$qty"),
                ]),
              );
            })));
  }
}
