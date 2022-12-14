import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

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

  bool ob_value=true;

  void toggle(){
    setState(() {
      ob_value=!ob_value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 75),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Uni",
                      style: GoogleFonts.urbanist(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    Image.asset(
                      'image/s.png',
                      width: 40,
                    ),
                    Text(
                      "tock",
                      style: GoogleFonts.urbanist(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 80, right: 10),
                  child: Container(
                    width: 400,
                    height: 380,
                    decoration: BoxDecoration(
                      color: Colors.white12,
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
                              decoration: const InputDecoration(
                                hintText: 'User name',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                                prefixIcon: Icon(
                                  Icons.person,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
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

                                suffixIcon: IconButton(
                                  icon:  Icon(
                                    //Changing icon by checking the value of ternary operation
                                      ob_value?Icons.remove_red_eye_outlined:Icons.visibility_off_outlined
                                  ),
                                  onPressed: () {
                                    toggle();
                                  },

                                ),

                              ),
                              obscureText: ob_value,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 10, right: 10),
                            child: TextFormField(
                              controller: store,
                              decoration: const InputDecoration(
                                hintText: 'Store ID',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                                prefixIcon: Icon(
                                  Icons.store_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
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
                              child: const Text(
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
