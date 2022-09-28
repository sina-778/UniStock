import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../Model/ItemInfo.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  String user;
  String store;

  HomeScreen({Key? key, required this.user, required this.store})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _scanBarcode = 'sina';
  String? scannedResult;
  int qty = 1;
  TextEditingController qtyCon = TextEditingController();

  @override
  void initState() {
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

  bool isPosted = false;
  Future<void> autoScan() async {
    setState(() {
      isPosted = true;
    });
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/scan_only.php"),
        body: jsonEncode(<String, dynamic>{
          "item": _scanBarcode,
          "xwh": widget.store,
          "prep_id": widget.user
        }));
    print(response.body);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        "Product Added successfully",
        textAlign: TextAlign.center,
        style: TextStyle(
          //fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ));

    setState(() {
      isPosted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Center(
              child: Text(
                'UniStock',
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.logout_sharp,
                    size: 30,
                    color: Colors.black54,
                  ),
                ))
          ],
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        await scanBarcodeNormal();
                        await autoScan();
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xffF7F7F7),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(width: 3, color: Colors.black26),
                            image: const DecorationImage(
                                image: AssetImage('image/scan_and_add.png')),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await scanBarcodeNormal();
                        await postScannedResult();
                        Future.delayed(const Duration(milliseconds: 20), () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                if (isLoading == true) {
                                  return CircularProgressIndicator();
                                } else {
                                  return AlertDialog(
                                    title: Text(
                                      'Scan result',
                                      style: GoogleFonts.urbanist(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.tealAccent),
                                    ),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Item Code:   ${data!.xitem}',
                                          style: GoogleFonts.urbanist(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "Item Name:  ${data!.xdesc}",
                                          style: GoogleFonts.urbanist(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "Supplier Name:  ${data!.xcusname}",
                                          style: GoogleFonts.urbanist(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "Total Quantity:  ${data!.qty}",
                                          style: GoogleFonts.urbanist(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Quantity : ",
                                              style: GoogleFonts.urbanist(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black54),
                                            ),
                                            SizedBox(
                                              height: 60,
                                              width: 50,
                                              child: TextField(
                                                controller: qtyCon,
                                                autofocus: true,
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: Theme.of(context)
                                                    .primaryColorDark,
                                                decoration: InputDecoration(
                                                    // border:
                                                    //     OutlineInputBorder(),
                                                    counterText: ' ',
                                                    hintText: "1",
                                                    hintStyle:
                                                        GoogleFonts.urbanist(
                                                            color:
                                                                Colors.black)),
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
                                              .showSnackBar(const SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                              "Product Added successfully",
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
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Color(0xffF7F7F7),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(width: 3, color: Colors.black26),
                            image: const DecorationImage(
                                image: AssetImage('image/scan.png')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "List of Products added",
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: Container(
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 150,
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.blueGrey,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Item Code : 010497",
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        "Item Name : Tang powder Drink orange Jar 750gm",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Supplier Name : Sajeeb Corporation",
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Total Quantity : 10000",
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Last Added Quantity : 5",
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 120,
                                padding: EdgeInsets.only(
                                    top: 10, right: 5, bottom: 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Date : 30-Aug-2022",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Time: 19:00:55:32",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Edit quantity',
                                                  style: GoogleFonts.urbanist(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black54),
                                                ),
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Item Code:   010497',
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      "Item Name : Tang powder Drink orange Jar 750gm",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      "Supplier Name:  Sajeeb Corporation",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      "Total Quantity:  10100",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Last added quantity : ",
                                                          style: GoogleFonts
                                                              .urbanist(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                        SizedBox(
                                                          height: 60,
                                                          width: 50,
                                                          child: TextField(
                                                            controller: qtyCon,
                                                            textAlign: TextAlign
                                                                .center,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            cursorColor: Theme
                                                                    .of(context)
                                                                .primaryColorDark,
                                                            decoration:
                                                                InputDecoration(
                                                              // border:
                                                              //     OutlineInputBorder(),
                                                              counterText: ' ',
                                                              hintText: "5",
                                                              hintStyle: GoogleFonts
                                                                  .urbanist(
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            // onChanged:
                                                            //     (value) {
                                                            //   //focus scope next and previous use for control the controller movement.
                                                            //   if (value
                                                            //           .length ==
                                                            //       1) {
                                                            //     FocusScope.of(
                                                            //             context)
                                                            //         .nextFocus();
                                                            //   } else if (value
                                                            //       .isEmpty) {
                                                            //     FocusScope.of(
                                                            //             context)
                                                            //         .previousFocus();
                                                            //   }
                                                            // },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  FlatButton(
                                                    color: Colors.amberAccent,
                                                    onPressed: () async {
                                                      qtyCon.clear();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: Text(
                                                          "Product updated successfully",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .urbanist(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Update",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                scrollable: true,
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.amberAccent,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Center(
                                          child: Text(
                                            "Edit",
                                            style: GoogleFonts.urbanist(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )),
            ],
          ),
        ));
  }
}
