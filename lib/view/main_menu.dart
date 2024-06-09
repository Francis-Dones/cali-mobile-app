// ignore_for_file: unused_field

import 'package:cali_mobile_app/model/save_to_db2.dart';
import 'package:cali_mobile_app/model/sync_data2_api.dart';
import 'package:cali_mobile_app/view/continue_rwt.dart';
import 'package:cali_mobile_app/view/update_clientUser.dart';
import 'package:cali_mobile_app/view/upload_rwt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'home.dart';
import 'new_rwt.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback signOut;
  HomeScreen(this.signOut);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var sessionManager = SessionManager();
  var _apiReturn;
  bool _isLoading = true;
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

  // var value;
  // getPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     value = preferences.getInt("value");
  //   });
  // }
  late final bool enableFeedback;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPref();
  }

  Future<void> syncData2() async {
    bool disableSyncButton = false;
    var _getsyncData2 = await syncDataApi2.getsyncData2();

    if (_getsyncData2['code'] == "1") {
      _apiReturn = _getsyncData2['data'];
      var _saveToDb = await saveToDatabase2.saveDataToDatabase(_apiReturn);
      print(_saveToDb);
      if (_saveToDb['code'] == "1") {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(_saveToDb['message'], true);
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(_saveToDb['message'], false);
      }
    } else {
      _showSnackBar(_getsyncData2['message'], false);
    }
    dynamic _loggedUser = await SessionManager().get("loggedUser");
    Map<String, dynamic> _userDetails = _loggedUser;
    print(_userDetails['user_id']);
    print(_getsyncData2);
  }

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

  List<Map> datatable = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
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
          body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(60),
              ),
              SizedBox(
                height: 60,
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const MyHomePage(
                        title: 'sampledata',
                      );
                    }));
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 36, 57, 149))),
                  child: const Text("NEW RWT"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              SizedBox(
                height: 70,
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const continueRwt(
                                title: 'home',
                              )),
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 36, 57, 149))),
                  child: const Text("RWT LISTING"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              SizedBox(
                height: 60,
                width: 335,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const uploadRWT(
                                title: 'home',
                              )),
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 36, 57, 149))),
                  child: const Text("UPLOAD RWT"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(50),
              ),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              syncData2();
            },
            child: Icon(Icons.sync_outlined, color: Colors.white, size: 40.0),
            backgroundColor: Color.fromARGB(255, 36, 57, 149),
          ),
        ));
  }
}
