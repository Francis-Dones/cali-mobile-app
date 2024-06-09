// ignore_for_file: use_build_context_synchronously, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';

import 'package:cali_mobile_app/model/login.dart';
import 'package:cali_mobile_app/model/save_to_db.dart';
import 'package:cali_mobile_app/model/sync_data_api.dart';
import 'package:cali_mobile_app/model/versionCaliAPI.dart';
import 'package:cali_mobile_app/view/main_menu.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Homepage> createState() => _HomepageState();
}

enum LoginStatus { notSignIn, signIn }

class _HomepageState extends State<Homepage> {
  var useridController = TextEditingController()..text = '001';
  var passwController = TextEditingController()..text = '12345678';

  var _apiReturn;

  bool _success = false;
  bool _isLoading = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final textFieldpassword = FocusNode();
  bool _obscured = true;

  bool _secureMode = false;

// for snackbar
  void _showSnackBar(String _text, bool _isSuccess) {
    print(_isSuccess);
    if (_isSuccess == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text(_text)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(_text)));
    }
  } // end snack bar

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldpassword.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldpassword.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  int versionApi = 3;
  void version() async {
    var _getVehicleInfo = await versionApplication.getVersion(versionApi);

    if (_getVehicleInfo['Status'] == false) {
      print(_getVehicleInfo['URL']);
      _showDialogUpdateVersion();
    }
  }

  void _showDialogUpdateVersion() async {
    String _version = versionApi.toString();
    var _getVehicleInfo = await versionApplication.getVersion(versionApi);
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text(
            "Please Update Version ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(
            Icons.warning,
            color: Colors.yellow,
            size: 40,
          ),
          content: Text(
            'V.' + _version,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
                onPressed: () {
                  launchUrl(Uri.parse(_getVehicleInfo['URL']),
                      mode: LaunchMode.externalApplication);
                },
                child: const Text('Download')),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
        );
      },
    );
  }

  @override
  void initState() {
    // screenShotdisable();
    super.initState();
    // _print();
    syncData1();
  }

  void screenShotdisable() async {
    final secureModeToggle = !_secureMode;

    if (secureModeToggle == true) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      print('sample');
    } else {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      print('sample1');
    }

    setState(() {
      _secureMode = !_secureMode;
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Connection Failed"),
          content: const Text("Please Connect Internet or Select Offline Mode"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            TextButton(
              child: const Text("Offline Mode"),
              onPressed: () {
                Navigator.pop(context, true);
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // for syncdata api
  Future<void> syncData1() async {
    var _getsyncData = await syncDataApi.getsyncData();

    if (_getsyncData['code'] == "1") {
      _apiReturn = _getsyncData['data'];
      var _saveToDb = await saveToDatabase.saveDataToDatabase(_apiReturn);
      List experation = _getsyncData['data']['data_users'];

      for (var i = 0; i < experation.length; i++) {
        var expirationDate = experation[i]['user_expiration'];
        setState(() {
          _expirationdate_userID = expirationDate;
        });
      }

      print(_saveToDb);
      if (_saveToDb['code'] == "1") {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(_saveToDb['message'], true);
        version();
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(_saveToDb['message'], false);
        _showDialog();
      }
    } else {
      _showSnackBar(_getsyncData['message'], false);
      _showDialog();
    }
  }

  List<dynamic> regionItems = [];

  var _expirationdate_userID;

  // for syncdata api
  Future<void> login() async {
    var _userId = useridController.text.trim();
    var _password = passwController.text.trim();
    String str3 = "#@F&L^&%U##T#T@#ER###CA@#@M*(PU@&#S%^%2324@*'(^&";
    String result3 = str3.replaceAll(RegExp('[^A-Za-z0-9]'), '.');

    var bytes = utf8.encode(_password);
    // data being hashed
    var digest = sha512.convert(bytes);
    var b64passsword = digest.toString().toUpperCase();

    if ((_userId == "" ||
            _userId == null ||
            _userId == str3.replaceAll(RegExp('[^A-Za-z0-9]'), '.')) &&
        (b64passsword == "" ||
            b64passsword == null ||
            b64passsword == str3.replaceAll(RegExp('[^A-Za-z0-9]'), '.'))) {
      _showSnackBar("email and password is Empty", false);
      setState(() {
        _isLoading = false;
      });
    } else {
      if (_userId == "" ||
          _userId == null ||
          _userId == str3.replaceAll(RegExp('[^A-Za-z0-9]'), '.')) {
        _showSnackBar("User ID is Empty", false);
        setState(() {
          _isLoading = false;
        });
      } else if (b64passsword == "" ||
          b64passsword == null ||
          b64passsword == str3.replaceAll(RegExp('[^A-Za-z0-9]'), '.')) {
        _showSnackBar("password is Empty", false);
        setState(() {
          _isLoading = false;
        });
      } else {
        var _getlogin =
            await loginUser.loginUserFunc(_userId, b64passsword, '');
        setState(() {
          _isLoading = false;
        });
        // DateTime now = DateTime.now();
        // // ignore: non_constant_identifier_names
        // String Datenow = DateFormat('yyyy-MM-dd').format(now.toLocal());

        // DateTime dtnow = DateTime.parse("$Datenow");
        // DateTime dtexpirationuserID = DateTime.parse("$_expirationdate_userID");
        // DateTime dtexpirationuserID1 = DateTime.parse("2022-05-04");
        // if (dtnow.isBefore(dtexpirationuserID)) {

        if (_getlogin['code'] == "1") {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomeScreen(signOut);
          }));

          _showSnackBar(_getlogin['message'], true);
        } else {
          _showSnackBar(_getlogin['message'], false);
        }

        // print("no expired");
        // } else {
        //   _showSnackBar('User ID is Expired Please contact to admin', false);
        // }
      }
    }
  }

  void warning() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Wanna Exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // passing false
                child: const Text('No'),
              ),
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        }).then((exit) {
      if (exit == null) return;

      if (exit) {
        // user pressed Yes button
      } else {
        // user pressed No button
      }
    });
  }

  // void _print() async {
  //   SunmiPrinter.hr();
  //   SunmiPrinter.emptyLines(1);

  //   SunmiPrinter.text('Date: March/1/2024',
  //       styles: const SunmiStyles(size: SunmiSize.md, bold: true));
  //   SunmiPrinter.text('Time: 09:35-pm',
  //       styles: const SunmiStyles(size: SunmiSize.md, bold: true));
  //   SunmiPrinter.hr();
  //   SunmiPrinter.emptyLines(2);
  //   SunmiPrinter.text('(Qty:2) Pancit Canton: ₱150',
  //       styles: const SunmiStyles(
  //           align: SunmiAlign.center, size: SunmiSize.md, bold: true));

  //   SunmiPrinter.emptyLines(2);

  //   SunmiPrinter.text('(Qty:1)  Palabok: ₱80',
  //       styles: const SunmiStyles(
  //           align: SunmiAlign.center, size: SunmiSize.md, bold: true));
  //   SunmiPrinter.emptyLines(2);
  //   SunmiPrinter.text('(Qty:3)  Tropicana Juice: ₱60',
  //       styles: const SunmiStyles(
  //           align: SunmiAlign.center, size: SunmiSize.md, bold: true));
  //   SunmiPrinter.emptyLines(2);
  //   SunmiPrinter.hr();
  //   SunmiPrinter.text('Total Amount:₱290',
  //       styles: SunmiStyles(size: SunmiSize.md, bold: true));
  //   SunmiPrinter.hr();
  //   SunmiPrinter.text('Recived by: Ivan',
  //       styles: SunmiStyles(size: SunmiSize.md, bold: true));
  //   SunmiPrinter.text('Submited by justine L Lopez',
  //       styles: SunmiStyles(size: SunmiSize.md, bold: true));
  //   SunmiPrinter.emptyLines(3);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          warning();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'CEBU AGUA LAB, INC.',
                style: TextStyle(
                    color: Color.fromARGB(255, 36, 57, 149),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
          resizeToAvoidBottomInset: false,
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Welcome",
                            style: TextStyle(
                                color: Color.fromARGB(255, 108, 108, 124),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login to your Account",
                            style: TextStyle(
                                color: Color.fromARGB(255, 108, 108, 124),
                                fontSize: 25),
                          )),
                      const Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "User ID",
                            style: TextStyle(
                                color: Color.fromARGB(255, 108, 108, 124),
                                fontSize: 20),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        child: TextField(
                          controller: useridController,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: "User Id",
                            prefixIcon: Icon(Icons.people, size: 24),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 108, 108, 124),
                                  width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 36, 57, 149),
                                  width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(
                                color: Color.fromARGB(255, 108, 108, 124),
                                fontSize: 20),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        child: TextField(
                          obscureText: _obscured,
                          controller: passwController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior
                                .never, //Hides label on focus or if filled
                            filled: true, // Needed for adding a fill color
                            fillColor: const Color.fromARGB(255, 244, 239, 239),
                            isDense: true, // Reduces height a bit
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 108, 108, 124),
                                  width: 2.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 36, 57, 149),
                                  width: 2.0),
                            ),
                            prefixIcon:
                                const Icon(Icons.lock_rounded, size: 24),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: GestureDetector(
                                onTap: _toggleObscured,
                                child: Icon(
                                  _obscured
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 1.0,
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              login();
                            },
                            // ignore: prefer_const_constructors
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 36, 57, 149))),
                            child: const Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }

  void signOut() {}
}
