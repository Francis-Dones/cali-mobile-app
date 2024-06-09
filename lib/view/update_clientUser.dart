// main.dart
import 'dart:convert';

import 'package:cali_mobile_app/model/func_insert.dart';
import 'package:cali_mobile_app/model/func_select.dart';
import 'package:cali_mobile_app/view/home.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'main_menu.dart';

class _updateUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEBU AGUA LAB, INC',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 2, 23, 120),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const updateUserAccount(title: 'CEBU AGUA LAB, INC'),
    );
  }
}

class updateUserAccount extends StatefulWidget {
  const updateUserAccount({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  // ignore: no_logic_in_create_state
  _updateAccountUserState createState() => _updateAccountUserState();
}

class _updateAccountUserState extends State<updateUserAccount> {
  @override
  initState() {
    super.initState();
    // getUserAccount('');
    sessionlogin();
    getBranchDetails();
    // main();
    print(old_Password);
  }

  // ignore: unused_field
  List<Map> _updateUser = [];
  // Future<void> getRwtDataContinue() async {
  //   final List<Map> dataRwtlist = await selectFunction.getUserAccount();

  //   setState(() {
  //     _updateUser = dataRwtlist;
  //   });
  // }

  signOut() async {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return const Homepage(
        title: 'home',
      );
    }));
  }

  AccountSettings() async {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return const updateUserAccount(
        title: 'home',
      );
    }));
  }

  // for snackbar
  void _showSnackBar(String text, bool isSuccess) {
    print(isSuccess);
    if (isSuccess == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text(text)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(text)));
    }
  } // end snack bar

  var myMenuItems = <String>[
    'Account Settings',
    'Logout',
  ];

  void onSelect(item) {
    switch (item) {
      case 'Account Settings':
        print('Account Settings clicked');
        AccountSettings();
        break;

      case 'Logout':
        print('Logout clicked');
        signOut();
        break;
    }
  }

  TextEditingController _user_id = TextEditingController();
  TextEditingController Nameuser = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController old_password = TextEditingController();
  TextEditingController EmployeeID = TextEditingController();
  TextEditingController FirstName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController MiddleName = TextEditingController();
  TextEditingController gender = TextEditingController();

  // List<String> _Gender = ['Male', 'Female'];
  String? gendercontroller;
  String _userNameID = "";
  String user_id = "";
  String old_Password = "";
  String? employee_id;
  String? first_name;
  String? last_name;
  String? middle_name;
  String? _gender;
  String device_id = '';
  String _branch_id = '';

  DateTime _dateInputStarted = DateTime.now();
  DateTime _dateInputEnded = DateTime.now();

  final textFieldpassword = FocusNode();
  final textFieldpassword1 = FocusNode();
  final textFieldpassword2 = FocusNode();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _obscured = true;
  bool _obscured1 = true;
  bool _obscured2 = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldpassword.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldpassword.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  void _toggleObscured1() {
    setState(() {
      _obscured1 = !_obscured1;
      if (textFieldpassword1.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldpassword1.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void _toggleObscured2() {
    setState(() {
      _obscured2 = !_obscured2;
      if (textFieldpassword2.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldpassword2.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  // void main() async {
  //   final _loggedUser = await SessionManager().get("loggedUser");
  //   print(_loggedUser['password'].toString());
  //   final bytes = utf8.encode("12345");
  //   // data being hashed

  //   var digest = sha512.convert(bytes);

  //   var b64 = base64UrlEncode(digest.bytes).toUpperCase();

  //   var b64password = base64UrlEncode(digest.bytes).toUpperCase();
  //   print("$b64");
  // }

  Future<void> sessionlogin() async {
    // _onSelectedparameters();
    // ignore: no_leading_underscores_for_local_identifiers
    final _loggedUser = await SessionManager().get("loggedUser");
    Map<String, dynamic> _userDetails = _loggedUser;

    setState(() {
      // _userNameID = _userDetails["user_name"].toString();
      // user_id = _userDetails['user_id'].toString();
      old_Password = _userDetails["password"].toString();
      // confirm_password.text = _userDetails['password'].toString();
      employee_id = _userDetails['employee_id'].toString();
      first_name = _userDetails['first_name'].toString();
      last_name = _userDetails['last_name'].toString();
      middle_name = _userDetails['middle_name'].toString();
      _gender = _userDetails['gender'].toString();
      device_id = _userDetails['device_id'].toString();
      // gendercontroller = _userDetails['gender'];
    });
  }

  Future<void> getBranchDetails() async {
    final List<Map> _list = await selectFunction.getbranchcode();

    setState(() {
      _branch_id = _list[0]['branch_id'].toString();
    });
  }

  Future<void> branchCode() async {
    final _loggedUser = await SessionManager().get("loggedUser");
    Map<String, dynamic> _userDetails = _loggedUser;
    setState(() {
      employee_id = _userDetails["employee_id"];
    });
  }

  Future<void> getUserAccountupdate() async {
    final bytePassword = utf8.encode(confirm_password.text);
    // data being hashed
    var convertedPassword = sha512.convert(bytePassword);
    var hashPassword = convertedPassword.toString().toUpperCase();

    var byteOldPassword = utf8.encode(old_password.text);
    // data being hashed
    var convertedOldPassword1 = sha512.convert(byteOldPassword);
    var hashOldPassword = convertedOldPassword1.toString().toUpperCase();

    Map<String, dynamic> userAccountUpdate = {
      'new_password': confirm_password.text,
      // 'old_password': hashOldPassword,
      'old_password': old_password.text,
      'employee_id': '$employee_id',
      'deveice_id': '$device_id',
      'branch_id': '$_branch_id'
    };

    Map<dynamic, dynamic> _result =
        await saveRwt.updateUserAccount(userAccountUpdate);
    if (_result['code'] == "1") {
      _showMyDialog();
    } else {
      _showSnackBar(_result['message'], false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool item = true;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 57, 149),
        automaticallyImplyLeading: false,
        title: const Text("CEBU AGUA LAB, INC."),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: onSelect,
              itemBuilder: (BuildContext context) {
                return myMenuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
        ],
      ),
      body: Form(
          key: _form,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Account Settings',
                        style: TextStyle(
                            color: Color.fromARGB(255, 1, 1, 5),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  // ignore: prefer_interpolation_to_compose_strings
                  child: RichText(
                    text: TextSpan(
                      text: 'Employee ID :',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 1, 5),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$employee_id',
                          style: TextStyle(
                              color: Color.fromARGB(255, 1, 1, 5),
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  // ignore: prefer_interpolation_to_compose_strings
                  child: RichText(
                    text: TextSpan(
                      text: 'First Name:',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 1, 5),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$first_name' + '',
                          style: TextStyle(
                              color: Color.fromARGB(255, 1, 1, 5),
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  // ignore: prefer_interpolation_to_compose_strings
                  child: RichText(
                    text: TextSpan(
                      text: 'Middle Name :',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 1, 5),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$middle_name',
                          style: TextStyle(
                              color: Color.fromARGB(255, 1, 1, 5),
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  // ignore: prefer_interpolation_to_compose_strings
                  child: RichText(
                    text: TextSpan(
                      text: 'Last Name :',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 1, 5),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$last_name',
                          style: TextStyle(
                              color: Color.fromARGB(255, 1, 1, 5),
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  // ignore: prefer_interpolation_to_compose_strings
                  child: RichText(
                    text: TextSpan(
                      text: 'Gender :',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 1, 5),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$_gender',
                          style: TextStyle(
                              color: Color.fromARGB(255, 1, 1, 5),
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "User ID:",
              //       style: TextStyle(color: Color.fromARGB(255, 1, 1, 5), fontSize: 17, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       setState(() {
              //         _dateInputStarted = DateTime.now();
              //       });
              //     },
              //     keyboardType: TextInputType.text,
              //     textCapitalization: TextCapitalization.characters,
              //     textInputAction: TextInputAction.next,
              //     controller: _user_id,
              //     textAlign: TextAlign.center,
              //     // The validator receives the text that the user has entered.
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter User-ID';
              //       }
              //       return null;
              //     },
              //     decoration: const InputDecoration(
              //       // isDense: true,
              //       contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color.fromARGB(255, 108, 108, 124),
              //           width: 2.0,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
              //       ),
              //     ),
              //   ),
              // ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Employee ID:",
              //       style: TextStyle(color: Color.fromARGB(255, 1, 1, 5), fontSize: 17, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       setState(() {
              //         _dateInputStarted = DateTime.now();
              //       });
              //     },
              //     keyboardType: TextInputType.text,
              //     textCapitalization: TextCapitalization.characters,
              //     textInputAction: TextInputAction.next,
              //     controller: EmployeeID,
              //     textAlign: TextAlign.center,
              //     // The validator receives the text that the user has entered.
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter EmployeeID';
              //       }
              //       return null;
              //     },
              //     decoration: const InputDecoration(
              //       // isDense: true,
              //       contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color.fromARGB(255, 108, 108, 124),
              //           width: 2.0,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
              //       ),
              //     ),
              //   ),
              // ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "First Name:",
              //       style: TextStyle(color: Color.fromARGB(255, 1, 1, 5), fontSize: 17, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       setState(() {
              //         _dateInputStarted = DateTime.now();
              //       });
              //     },
              //     keyboardType: TextInputType.text,
              //     textCapitalization: TextCapitalization.characters,
              //     textInputAction: TextInputAction.next,
              //     controller: FirstName,
              //     textAlign: TextAlign.center,
              //     // The validator receives the text that the user has entered.
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter FirstName';
              //       }
              //       return null;
              //     },
              //     decoration: const InputDecoration(
              //       // isDense: true,
              //       contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color.fromARGB(255, 108, 108, 124),
              //           width: 2.0,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
              //       ),
              //     ),
              //   ),
              // ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Middle Name:",
              //       style: TextStyle(color: Color.fromARGB(255, 1, 1, 5), fontSize: 17, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       setState(() {
              //         _dateInputStarted = DateTime.now();
              //       });
              //     },
              //     keyboardType: TextInputType.text,
              //     textCapitalization: TextCapitalization.characters,
              //     textInputAction: TextInputAction.next,
              //     controller: MiddleName,
              //     textAlign: TextAlign.center,
              //     // The validator receives the text that the user has entered.
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter MiddleName';
              //       }
              //       return null;
              //     },
              //     decoration: const InputDecoration(
              //       // isDense: true,
              //       contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color.fromARGB(255, 108, 108, 124),
              //           width: 2.0,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
              //       ),
              //     ),
              //   ),
              // ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Last Name:",
              //       style: TextStyle(color: Color.fromARGB(255, 1, 1, 5), fontSize: 17, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       setState(() {
              //         _dateInputStarted = DateTime.now();
              //       });
              //     },
              //     keyboardType: TextInputType.text,
              //     textCapitalization: TextCapitalization.characters,
              //     textInputAction: TextInputAction.next,
              //     controller: LastName,
              //     textAlign: TextAlign.center,
              //     // The validator receives the text that the user has entered.
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter LastName';
              //       }
              //       return null;
              //     },
              //     decoration: const InputDecoration(
              //       // isDense: true,
              //       contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color.fromARGB(255, 108, 108, 124),
              //           width: 2.0,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
              //       ),
              //     ),
              //   ),
              // ),

              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Gender:",
              //       style: TextStyle(color: Color.fromARGB(255, 1, 1, 5), fontSize: 17, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       setState(() {
              //         _dateInputStarted = DateTime.now();
              //       });
              //     },
              //     keyboardType: TextInputType.text,
              //     textCapitalization: TextCapitalization.characters,
              //     textInputAction: TextInputAction.next,
              //     controller: gender,
              //     textAlign: TextAlign.center,
              //     // The validator receives the text that the user has entered.
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter Gender';
              //       }
              //       return null;
              //     },
              //     decoration: const InputDecoration(
              //       // isDense: true,
              //       contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color.fromARGB(255, 108, 108, 124),
              //           width: 2.0,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              //   child: DropdownButtonFormField<String>(
              //     isExpanded: true,
              //     value: gendercontroller,
              //     items: _Gender.map((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Center(
              //           child: Text(value),
              //         ),
              //       );
              //     }).toList(),
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please Select UserType';
              //       }
              //       return null;
              //     },
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         gendercontroller = newValue;
              //       });
              //     },
              //     decoration: const InputDecoration(
              //         isDense: true,
              //         contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Color.fromARGB(255, 108, 108, 124),
              //             width: 2.0,
              //           ),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
              //         ),
              //         hintText: "Select User Type"),
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Old Password:",
                    style: TextStyle(
                        color: Color.fromARGB(255, 1, 1, 5),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: TextFormField(
                  controller: old_password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscured2,
                  focusNode: textFieldpassword2,
                  validator: (val) {
                    // var byteOldPassword = utf8.encode(val.toString());
                    // // data being hashed
                    // var convertedOldPassword1 = sha512.convert(byteOldPassword);
                    // var base64OldPassword =
                    //     convertedOldPassword1.toString().toUpperCase();

                    if (val!.isEmpty) {
                      return 'Empty';
                    }
                    if (val != '$old_Password') {
                      return 'Not Match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior
                        .never, //Hides label on focus or if filled
                    labelText: "Old Password",
                    filled: true, // Needed for adding a fill color
                    fillColor: const Color.fromARGB(255, 244, 239, 239),
                    isDense: true, // Reduces height a bit
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius:
                          BorderRadius.circular(12), // Apply corner radius
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured2,
                        child: Icon(
                          _obscured2
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "New Password:",
                    style: TextStyle(
                        color: Color.fromARGB(255, 1, 1, 5),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscured,
                  focusNode: textFieldpassword,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please input Remarks before Upload";
                    } else if (val.length < 5) {
                      return "Remarks must be atleast 5 characters long";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior
                        .never, //Hides label on focus or if filled
                    labelText: "Password",
                    filled: true, // Needed for adding a fill color
                    fillColor: const Color.fromARGB(255, 244, 239, 239),
                    isDense: true, // Reduces height a bit
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius:
                          BorderRadius.circular(12), // Apply corner radius
                    ),
                    prefixIcon: Icon(Icons.lock_rounded, size: 24),
                    suffixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ConFirm Password:",
                    style: TextStyle(
                        color: Color.fromARGB(255, 1, 1, 5),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: TextFormField(
                  controller: confirm_password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscured1,
                  focusNode: textFieldpassword1,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Empty';
                    }
                    if (val != password.text) {
                      return 'Not Match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior
                        .never, //Hides label on focus or if filled
                    labelText: "ConfirmPassword",
                    filled: true, // Needed for adding a fill color
                    fillColor: const Color.fromARGB(255, 244, 239, 239),
                    isDense: true, // Reduces height a bit
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius:
                          BorderRadius.circular(12), // Apply corner radius
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured1,
                        child: Icon(
                          _obscured1
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
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: [
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return HomeScreen(signOut);
                              }));
                            },
                            icon: const Icon(
                                Icons.close), //icon data for elevated button
                            label: const Text("close"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 238, 52, 52),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // ignore: unrelated_type_equality_checks
                            if (_form.currentState!.validate()) {
                              getUserAccountupdate();
                            } else {
                              print('no data');
                            }
                          },
                          icon: const Icon(
                              Icons.save), //icon data for elevated button
                          label: const Text("Save"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 3, 118, 30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _showMyDialog() async {
    // ignore: unrelated_type_equality_checks

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('$_title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Password has been successfully changed'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const Homepage(
                    title: 'home',
                  );
                }));
              },
            ),
          ],
        );
      },
    );
  }
}
