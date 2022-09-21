import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _fromKey = GlobalKey();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController store = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            backgroundColor: Colors.amberAccent,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                ' UniStock',
                style: GoogleFonts.urbanist(
                  color: Colors.black54,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 80, right: 10),
                  child: Container(
                    width: 400,
                    height: 380,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Form(
                      key: _fromKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 10, right: 10),
                            child: TextFormField(
                              controller: user,
                              decoration: InputDecoration(
                                hintText: 'User name',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                                prefixIcon: Icon(
                                  Icons.person,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            child: TextFormField(
                              // controller: passController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                                prefixIcon: Icon(
                                  Icons.vpn_key_outlined,
                                ),
                                suffixIcon: Icon(
                                  Icons.remove_red_eye_outlined,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 10, right: 10),
                            child: TextFormField(
                              controller: store,
                              decoration: InputDecoration(
                                hintText: 'Store ID',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                                prefixIcon: Icon(
                                  Icons.store_outlined,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: 44,
                            width: 194,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                              user: user.text,
                                              store: store.text,
                                            )));
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amberAccent),
                              child: Text(
                                'LogIn',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
