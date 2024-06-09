// main.dart
// ignore_for_file: non_constant_identifier_names

import 'package:cali_mobile_app/model/func_select.dart';
import 'package:cali_mobile_app/view/continueForm.dart';
import 'package:cali_mobile_app/view/home.dart';
import 'package:cali_mobile_app/view/update_clientUser.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_menu.dart';

class _continueRwt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEBU AGUA LAB, INC',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 2, 23, 120),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const continueRwt(title: 'CEBU AGUA LAB, INC'),
    );
  }
}

class continueRwt extends StatefulWidget {
  const continueRwt({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  // ignore: no_logic_in_create_state
  _uploadRWTState createState() => _uploadRWTState();
}

class _uploadRWTState extends State<continueRwt> {
  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  final List<Map> _allUsers = [
    {"id": 1, "name": "Andy", "age": 29},
    {"id": 2, "name": "Aragon", "age": 40},
    {"id": 3, "name": "Bob", "age": 5},
    {"id": 4, "name": "Barbara", "age": 35},
    {"id": 5, "name": "Candy", "age": 21},
    {"id": 6, "name": "Colin", "age": 55},
    {"id": 7, "name": "Audra", "age": 30},
    {"id": 8, "name": "Banana", "age": 14},
    {"id": 9, "name": "Caversky", "age": 100},
    {"id": 10, "name": "Becky", "age": 32},
  ];

  bool? selectedall = false;
  bool _isLoading = false;
  String _userId = '';
  List<Map> _continueFormlist = [];

  TextEditingController _dateFrom = TextEditingController();
  TextEditingController _dateTo = TextEditingController();

  // This list holds the data for the list view
  List<Map> _dataSearch = [];
  String? _sampleSource;
  List<String> _sampleSourceList = [];

  String? _samplingPoint;
  List<String> _samplingPointList = [];

  @override
  initState() {
    // at the beginning, all users are shown
    _dataSearch = _allUsers;
    super.initState();
    getRwtData();
    // getRwtDataContinueSamples();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _continueFormlist;
    } else {
      results = _continueFormlist
          .where((user) => user["rwt_no"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _dataSearch = results;
    });
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
    final List<Map> dataRwtlist = await selectFunction.getrwtContinue();
    setState(() {
      _continueFormlist = dataRwtlist;
    });
  }

  Future<void> continueRWT(String _rwtNo) async {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return MyHomePage(title: 'CEBU AGUA LAB, INC', rwtNo: _rwtNo);
    }));
  }

  Future<void> DeleteRWT(String rwt_no) async {
    var rwtClientData = await selectFunction.getDeleteRW(rwt_no);
  }

  List<Map> SamplesdataContinue = [];

  // Future<void> getRwtDataContinueSamples() async {
  //   final List<Map> ContinueSamplesdata = await selectFunction.getrwtContinueSamples();
  //   for (var i = 0; i < ContinueSamplesdata.length; i++) {
  //     setState(() {
  //       // ignore: unnecessary_string_interpolations
  //       SamplesdataContinue = ContinueSamplesdata;
  //     });
  //   }
  // }

  void _showDialogDelete(item) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("DELETE"),
          content: const Text("Are you sure Delete RWT?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              onPressed: () => Navigator.pop(context, false), // passing false
              // ignore: prefer_const_constructors
              child: Text('Cancel'),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                DeleteRWT(item['rwt_no']);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const continueRwt(title: 'CEBU AGUA LAB, INC'),
                    ));
              },
            ),
          ],
        );
      },
    );
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _dataSearch.isNotEmpty
                  ? ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2)),
                        _continueFormlist.isNotEmpty
                            ? Wrap(
                                children: _continueFormlist.map((item) {
                                  return Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ExpansionTileCard(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                5, 0, 5, 0),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        initialElevation: 5,
                                        elevation: 5,
                                        expandedTextColor: const Color.fromARGB(
                                            255, 22, 6, 109),
                                        title: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                item['company_name'],
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 1, 1, 5),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: <Widget>[
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '----------------------------------------------------------',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 1, 1, 5),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 5, 20, 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              // ignore: prefer_interpolation_to_compose_strings
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'Date Of Sampling: ',
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 1, 1, 5),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: item[
                                                          'rwt_input_started'],
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 1, 1, 5),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                30, 5, 30, 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              // ignore: prefer_interpolation_to_compose_strings
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'registered Owners: ',
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 1, 1, 5),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: item[
                                                          'registered_owner_name'],
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 1, 1, 5),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 5, 20, 0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              // ignore: prefer_interpolation_to_compose_strings
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'AR Number: ',
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 1, 1, 5),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: item['rwt_no'],
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 1, 1, 5),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '----------------------------------------------------------',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 1, 1, 5),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: Container(
                                              width: 300,
                                              margin: const EdgeInsets.only(
                                                  top: 15),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 45,
                                                      child:
                                                          ElevatedButton.icon(
                                                        onPressed: () {
                                                          _showDialogDelete(
                                                              item);
                                                        },
                                                        icon: const Icon(Icons
                                                            .delete), //icon data for elevated button
                                                        label: const Text(
                                                            "Delete"),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  234,
                                                                  22,
                                                                  22),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 12.0,
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 45,
                                                      child:
                                                          ElevatedButton.icon(
                                                        onPressed: () {
                                                          continueRWT(
                                                              item['rwt_no']);
                                                        },
                                                        icon: const Icon(Icons
                                                            .forward), //icon data for elevated button
                                                        label: const Text(
                                                            "Continue"),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(255,
                                                                  5, 80, 45),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // ignore: avoid_unnecessary_containers
                                                ],
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
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return HomeScreen(signOut);
                                  }));
                                },
                                icon: const Icon(Icons
                                    .close), //icon data for elevated button
                                label: const Text("close"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 238, 52, 52),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
