import 'package:flutter/material.dart';

class TestLoginScreen extends StatefulWidget {
  const TestLoginScreen({Key? key}) : super(key: key);

  @override
  State<TestLoginScreen> createState() => _TestLoginScreenState();
}

class _TestLoginScreenState extends State<TestLoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController storeId = TextEditingController();
  String text = '';
  bool _secure = true;
  var _formKey = GlobalKey<FormState>();
  String? passError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextField(
            //   decoration: InputDecoration(
            //       hintText: 'enter your name',
            //       labelText: 'Name',
            //       labelStyle: TextStyle(color: Colors.orange, fontSize: 18),
            //       hintStyle: TextStyle(color: Colors.redAccent, fontSize: 18),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //       prefixIcon: Icon(Icons.account_circle),
            //       suffixIcon: IconButton(
            //         icon: Icon(_secure ? Icons.remove_red_eye : Icons.security),
            //         onPressed: () {
            //           setState(() {
            //             _secure = !_secure;
            //           });
            //         },
            //       ),
            //       errorText: text.isEmpty ? 'Empty' : null),
            //   keyboardType: TextInputType.text,
            //   obscureText: _secure,
            //   obscuringCharacter: '*',
            //   maxLength: 10,
            //   //maxLines: 2,
            //   onChanged: (value) {
            //     text = value;
            //   },
            //   onSubmitted: (value) {
            //     setState(() {
            //       text = value;
            //     });
            //
            //     print(value);
            //   },
            // ),
            Form(
              key: _formKey,
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'enter your name',
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.orange, fontSize: 18),
                  hintStyle: TextStyle(color: Colors.redAccent, fontSize: 18),
                  errorText: passError,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (password.text.isEmpty) {
                      passError = "Empty field!";
                    } else {
                      passError = null;
                    }
                  });
                  print("Submit pressed: ${username.text}");
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}
