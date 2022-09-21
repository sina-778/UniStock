import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'Model/ItemInfo.dart';

class ScanandAdd extends StatefulWidget {
  String user;
  String store;
  ScanandAdd({Key? key, required this.user, required this.store})
      : super(key: key);

  @override
  State<ScanandAdd> createState() => _ScanandAddState();
}

class _ScanandAddState extends State<ScanandAdd> {
  String _scanBarcode = 'sina';
  String? scannedResult;
  int qty = 1;
  TextEditingController qtyCon = TextEditingController();

  @override
  void initState() {
    // postScannedResult();
    super.initState();
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
  bool isLoading = false;
  ItemInfo? data;
  Future<void> postScannedResult() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/item_info.php"),
        body: jsonEncode(<String, dynamic>{"item": _scanBarcode}));
    data = itemInfoFromJson(response.body);
    setState(() {
      isLoading = false;
    });
    print(response.body);
  }

  Future<void> postQuantity(String q) async {
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/add_item.php"),
        body: jsonEncode(<String, dynamic>{
          "item": _scanBarcode,
          "xcus": data!.xcus,
          "qty": q,
          "prep_id": widget.user
        }));
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white70,
            appBar: AppBar(
              backgroundColor: Colors.amberAccent,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Center(
                  child: Text(
                    'Scan & ADD',
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
                  //height: 200,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      await scanBarcodeNormal();
                      await postScannedResult();
                      Future.delayed(Duration(milliseconds: 20), () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              if (isLoading == true) {
                                return CircularProgressIndicator();
                              } else {
                                return AlertDialog(
                                  title: Text('Scan result',
                                      style: TextStyle(fontSize: 20)),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Item Code:   ${data!.xitem}'),
                                      Text("Item Name:  ${data!.xdesc} "),
                                      Text(
                                          "Supplier Name:  ${data!.xcusname} "),
                                      Row(
                                        children: [
                                          Text("Quantity : "),
                                          SizedBox(
                                            height: 60,
                                            width: 50,
                                            child: TextField(
                                              controller: qtyCon,
                                              autofocus: true,
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: Theme.of(context)
                                                  .primaryColorDark,
                                              decoration: const InputDecoration(
                                                  // border:
                                                  //     OutlineInputBorder(),
                                                  counterText: ' ',
                                                  hintText: "1",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20)),
                                              onChanged: (value) {
                                                //focus scope next and previous use for control the controller movement.
                                                if (value.length == 1) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                } else if (value.isEmpty) {
                                                  FocusScope.of(context)
                                                      .previousFocus();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                      color: Color(0xFF8CA6DB),
                                      onPressed: () async {
                                        // print("_scanBarcode");
                                        // print(_scanBarcode);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "Order Confirmed",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ));

                                        if (qtyCon.text.isEmpty) {
                                          await postQuantity(1.toString());
                                          await postScannedResult();
                                        } else {
                                          //post to api
                                          postQuantity(qtyCon.text);
                                          qtyCon.clear();
                                        }
                                        // var snackBar = SnackBar(
                                        //     content: Text('Hello World'));
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(snackBar);
                                        //scanBarcodeNormal();
                                        Navigator.pop(context);
                                      },
                                      child: Text("ADD"),
                                    ),
                                  ],
                                  scrollable: true,
                                );
                              }
                            });
                      });
                    },
                    // child: Container(
                    //   height: 180,
                    //   width: 180,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //         width: 5, color: Colors.yellowAccent),
                    //     image: DecorationImage(
                    //         image:
                    //             AssetImage('image/barcode-icon-21.jpg')),
                    //   ),
                    // ),
                  ));
            })));
  }
}
