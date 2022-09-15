import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? scannedResult;

  //post method for barcode scanned value
  Future<void> postScannedResult() async {
    var response = http.post(Uri.parse("Api Link will be added here"),
        body: jsonEncode(<String, dynamic>{"something": "$scannedResult"}));
    // print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Barcode scanner"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber, onPrimary: Colors.black),
              onPressed: scanBarcode,
              icon: Icon(Icons.camera_alt_outlined),
              label: Text("Start scan"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              scannedResult == null
                  ? "Scan a code!"
                  : "Scan result : $scannedResult",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber, onPrimary: Colors.black),
                  onPressed: () {},
                  icon: Icon(Icons.cloud_upload),
                  label: Text(
                    "Upload",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future scanBarcode() async {
    String? scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      scanResult = scannedResult;
    });
  }
}
