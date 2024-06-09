// ignore_for_file: prefer_const_constructors, unnecessary_new, camel_case_types, prefer_interpolation_to_compose_strings, unnecessary_import

import 'dart:async';

import 'package:cali_mobile_app/model/func_select.dart';
import 'package:cali_mobile_app/model/func_upload_db.dart';
import 'package:cali_mobile_app/view/update_clientUser.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'main_menu.dart';

class _mainUploadRwt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEBU AGUA LAB, INC',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 2, 23, 120),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const uploadRWT(title: 'CEBU AGUA LAB, INC'),
    );
  }
}

class uploadRWT extends StatefulWidget {
  const uploadRWT({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  // ignore: no_logic_in_create_state
  _uploadRWTState createState() => _uploadRWTState();
}

class _uploadRWTState extends State<uploadRWT> {
  List<Map> _uploadRwtlistdata = [];

  List<bool> _selectedALL = [];
  bool? selectedall = false;
  bool _isLoading = false;

  String _companyName = '';
  String _clientName = '';
  String _userId = '';

  int _totalUpload = 0;
  int _currentUpload = 0;

  @override
  void initState() {
    // getListingupload('');
    super.initState();
    getRwtData();
    sessionlogin();
  }

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

  Future<void> getRwtData() async {
    final List<Map> dataRwtlist = await selectFunction.getRwtList();
    setState(() {
      _uploadRwtlistdata = dataRwtlist;
    });
    print(_uploadRwtlistdata);
  }

  void SelectAllFunction(bool? ischecked) {
    for (var i = 0; i < _uploadRwtlistdata.length; i++) {
      setState(() {
        _uploadRwtlistdata[i]['is_checked'] = ischecked;
      });
    }
  }

  void _showDialogError(String errorMessage) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.pop(context, true);
                _isLoading = false;
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadFunction() async {
    try {
      List<String> selectedRWTNo = [];
      String _uploaded = "";
      setState(() {
        _totalUpload = 0;
        _currentUpload = 0;
        _uploaded = "";
      });

      for (var eachRwt in _uploadRwtlistdata) {
        if (eachRwt['is_checked'] == true) {
          setState(() {
            selectedRWTNo.add(eachRwt['rwt_no']);
          });
        }
      }
      setState(() {
        _totalUpload = selectedRWTNo.length;
      });

      // _showMyDialog('RWT Upload', _currentUpload.toString());

      if (selectedRWTNo.isEmpty) {
        _showSnackBar('No Data Selected', false);
      } else {
        _showLoadingDialog(_currentUpload);
        DateTime _mobileTransDate = DateTime.now();
        String _converteDateMobileTransDate =
            await convertToDateWithTimezone(_mobileTransDate);

        for (var i = 0; i <= selectedRWTNo.length; i++) {
          print(_currentUpload);
          // print(_totalUpload);
          if (_currentUpload == _totalUpload) {
            Timer(Duration(seconds: 2), () {
              hideOpendialog();
              _showMyDialog('RWT Upload', _uploaded);
            });
          } else {
            var uploadRwtNo = await uploadRWtClass.uploadApiRwtFunc(
                selectedRWTNo[i], _userId, _converteDateMobileTransDate);
            if (uploadRwtNo['code'] == "1") {
              setState(() {
                _uploaded +=
                    "RWT No.: " + uploadRwtNo['rwt_no'] + " - Success\n";
              });
            } else {
              setState(() {
                _uploaded +=
                    "RWT No.: " + uploadRwtNo['rwt_no'] + " - Failed\n";
                _showSnackBar(uploadRwtNo['message'], false);
              });
            }
            setState(() => _currentUpload += 1);
            _showLoadingDialog(_currentUpload);
          }
        }
      }
    } on Exception catch (e) {
      _showSnackBar(e.toString(), false);
    }
  }

  Future<void> sessionlogin() async {
    // _onSelectedparameters();
    // ignore: no_leading_underscores_for_local_identifiers
    final _loggedUser = await SessionManager().get("loggedUser");
    Map<String, dynamic> _userDetails = _loggedUser;

    setState(() {
      _userId = _userDetails["employee_id"];
    });
  }

  Future<String> convertToDateWithTimezone(DateTime date) async {
    DateTime now = date.toLocal();

    String dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String timezone = "";
    String timeOffset = now.timeZoneOffset.inHours.toString();
    if (timeOffset.contains("-")) {
      String numOnly = timeOffset.substring(1);
      timezone = "-${numOnly.padLeft(2, '0')}";
    } else {
      timezone = "+${timeOffset.padLeft(2, '0')}";
    }
    return dateTime + timezone;
  }

  void hideOpendialog() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    bool item = true;
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
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
          body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: [
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Checkbox(
                        value: selectedall,
                        activeColor: const Color.fromARGB(255, 36, 57, 149),
                        checkColor: Colors.white,
                        onChanged: (bool? newValue) {
                          setState(() {
                            selectedall = newValue;
                          });
                          SelectAllFunction(selectedall);
                        },
                      ),
                      const Text(
                        'Select All',
                        style: TextStyle(
                            color: Color.fromARGB(255, 1, 1, 5),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            uploadFunction();
                          },
                          icon: const Icon(
                              Icons.upload), //icon data for elevated button
                          label: const Text("UPLOAD"),
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
              const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              _uploadRwtlistdata.isNotEmpty
                  ? Wrap(
                      children: _uploadRwtlistdata.map((item) {
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ExpansionTileCard(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              initialElevation: 5,
                              elevation: 5,
                              expandedTextColor:
                                  const Color.fromARGB(255, 22, 6, 109),
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Checkbox(
                                      value: item['is_checked'],
                                      activeColor: const Color.fromARGB(
                                          255, 36, 57, 149),
                                      checkColor: Colors.white,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          item['is_checked'] = newValue!;
                                        });
                                      },
                                    ),
                                    // ignore: prefer_interpolation_to_compose_strings
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      item['company_name'],
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 1, 1, 5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    // ignore: prefer_interpolation_to_compose_strings
                                    child: RichText(
                                      text: new TextSpan(
                                        text: 'AR No:',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 1, 1, 5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          new TextSpan(
                                            text: item['rwt_no'],
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 1, 1, 5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    // ignore: prefer_interpolation_to_compose_strings
                                    child: RichText(
                                      text: new TextSpan(
                                        text: 'Date Of Sampling: ',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 1, 1, 5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          new TextSpan(
                                            text: item['date_of_sampling'],
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 1, 1, 5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    // ignore: prefer_interpolation_to_compose_strings
                                    child: RichText(
                                      text: new TextSpan(
                                        text: 'Register Owners: ',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 1, 1, 5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          new TextSpan(
                                            text: item['contact_person_name'],
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 1, 1, 5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    // ignore: prefer_interpolation_to_compose_strings
                                    child: RichText(
                                      text: new TextSpan(
                                        text: 'Contact Person: ',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 1, 1, 5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          new TextSpan(
                                            text: item['contact_person_name'],
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 1, 1, 5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      }).toList(),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 10, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return HomeScreen(signOut);
                        }));
                      },
                      icon: const Icon(
                          Icons.close), //icon data for elevated button
                      label: const Text("close"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 238, 52, 52),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _showLoadingDialog(int currentUpload) async {
    // ignore: unrelated_type_equality_checks

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              // ignore: avoid_unnecessary_containers
              Container(
                padding: EdgeInsets.only(left: 25),
                child: Text("Uploading $currentUpload out of $_totalUpload"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog(String _title, String _message) async {
    // ignore: unrelated_type_equality_checks

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$_title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('$_message'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const uploadRWT(title: 'CEBU AGUA LAB, INC'),
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
