// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:cali_mobile_app/model/func_insert.dart';
import 'package:cali_mobile_app/model/func_select.dart';
import 'package:cali_mobile_app/view/continue_rwt.dart';
import 'package:cali_mobile_app/view/home.dart';
import 'package:cali_mobile_app/view/main_menu.dart';
import 'package:cali_mobile_app/view/update_clientUser.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_sunmi_printer_plus/enums.dart';
import 'package:flutter_sunmi_printer_plus/flutter_sunmi_printer_plus.dart';
import 'package:flutter_sunmi_printer_plus/sunmi_style.dart';
// ignore: unnecessary_import
import 'package:intl/intl.dart';

class _Continue extends StatelessWidget {
  @override
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEBU AGUA LAB, INC',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 2, 23, 120),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'CEBU AGUA LAB, INC', rwtNo: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String rwtNo;
  const MyHomePage({Key? key, required this.title, required this.rwtNo})
      : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static dynamic jsonDecode(String source,
          {Object? Function(Object? key, Object? value)? reviver}) =>
      json.decode(source, reviver: reviver);
  var myMenuItems = <String>[
    'Account Settings',
    'Logout',
  ];

  void onSelect(item) {
    switch (item) {
      case 'Account Settings':
        AccountSettings();
        print('Account Settings clicked');
        break;

      case 'Logout':
        print('Logout clicked');
        signOut();
        break;
    }
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

  int currentStep = 0;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _paymentKey = GlobalKey<FormFieldState>();

  TextEditingController _rwt_no = TextEditingController();
  TextEditingController _company_name = TextEditingController();
  TextEditingController _client_name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _telephone_no = TextEditingController();
  TextEditingController _fax_no = TextEditingController();
  TextEditingController _cellphone_no = TextEditingController();
  TextEditingController _email_address = TextEditingController();
  TextEditingController _dateInput = TextEditingController();
  TextEditingController _Submittedsignature = TextEditingController();
  TextEditingController _ContactPerson = TextEditingController();
  TextEditingController _remarks = TextEditingController();

  final List<TextEditingController> _otherSampleSource = [];
  final List<TextEditingController> _otherSamplingPoint = [];
  final List<TextEditingController> _otherLocation = [];
  final List<TextEditingController> _timeInput = [];

  final TextEditingController _bacterialogical = TextEditingController();
  final TextEditingController _physicalchemical = TextEditingController();
  final TextEditingController _Specical_Instructions = TextEditingController();
  TextEditingController _TotalAmount = TextEditingController();
  TextEditingController _registerowners = TextEditingController();

  final TextEditingController _paidAmount = TextEditingController();

  TextEditingController _amountPaid = TextEditingController();

  String _Arnumber = '';
  String _userName = '';
  // String _companyName = '';
  // String _nameOfClient = '';
  // String _Address = '';
  // String _telephoneNumber = '';
  // String _cellphoneNumber = '';
  // String _paidtotalamount = '';
  // String _submittedby = '';

  DateTime _dateInputStarted = DateTime.now();
  DateTime _dateInputEnded = DateTime.now();

  String _dateOfSampling = '';
  String currentDate = DateFormat().format(DateTime.now());
  String printercurrentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String printercurrentTime = DateFormat('hh:mm a').format(DateTime.now());

  String? _sampleSource;
  final List<String> _sampleSourceList = [];

  String? _samplingPoint;
  final List<String> _samplingPointList = [];

  String? _testpackages;
  String _branchName = '';
  String _branchCode = '';

  List<Map> _checkboxPackage = [];
  String _selectedPackage = "";
  String _selectedPackageName = "";

  String saveAcknowledgement = "";

  bool enabledSamplesource = false;
  bool enabledSamplingpoint = false;

  bool enabledAmountpaid = false;

  final List<Map> _sampleData = [];

  // ignore: prefer_final_fields
  List<Map> _checkboxBacterialogical = [];
  final List<String> _selectedBacteriological = [];

  List<Map> _checkboxPhysicalChemical = [];
  final List<String> _selectedPhysicalChemical = [];
  List<String> _selectedParameter = [];

  List<String> _rwtParameters = [];
  Map<dynamic, dynamic> _updateClientData = {};

  final List<String> _paymentStatus = ['PAID', 'OTHERS'];
  String? _payment;

  String dropdownvaluepaymenttype = "FULL PAYMENT";
  List<String> Paymentype = [
    'FULL PAYMENT',
    'PARTIAL PAYMENT',
    'CREDIT',
  ];

  String _paymentRemark = '';

  bool enabledtestpakage = true;
  bool enabledpysicalChemical = true;
  final bool _isLoading = true;

  final List<Map> _userDetails = [];

  // ignore: unnecessary_nullable_for_final_variable_declarations

  var _bactIsDisabled = 0;
  var _phyIsDisabled = 0;
  var _packIsDisabled = 0;
  double _totalAmount = 0;

  var dropdownvalueaddress = "PLESE SELECT ADDRESS";
  List<String> addressOption = [];
  String valueAdress = "";

  @override
  void initState() {
    _dateInput.text = "";
    // TODO: implement initState
    super.initState();
    getSamplesource();
    getSamplingPoint();
    getBranchDetails();
    getpackages();
    getBacterialogical();
    getPhysicalchemical();
    sessionlogin();
    // getArnumber();

    TextEditingController _eachotherSampleSource = TextEditingController();
    TextEditingController _eachotherSamplingPoint = TextEditingController();
    TextEditingController _eachotherLocation = TextEditingController();
    TextEditingController _eachtimeInput = TextEditingController();

    _otherSampleSource.add(_eachotherSampleSource);
    _otherSamplingPoint.add(_eachotherSamplingPoint);
    _otherLocation.add(_eachotherLocation);
    _timeInput.add(_eachtimeInput);

    getRwtData();
    getRwtSamplesData();
    getRwtDataParameters();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  void _showSnackBar(String _text, bool _isSuccess) {
    print(_isSuccess);
    if (_isSuccess == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text(_text)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(_text)));
    }
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

  Future<String> convertToTimeWithTimezone(String time) async {
    DateTime now = DateTime.now().toLocal();

    DateTime dateJms = DateFormat.jms().parse(time);
    String dateTime = DateFormat("HH:mm:ss").format(dateJms);
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

  Future<void> getSamplesource() async {
    final List<Map> _list = await selectFunction.getDatasampleList();

    setState(() {
      for (var i = 0; i < _list.length; i++) {
        _sampleSourceList.add(_list[i]['sample_source'].toString());
      }
      _sampleSourceList.add('OTHERS');
    });
  }

  Future<void> getSamplingPoint() async {
    final List<Map> _list = await selectFunction.getClientSamplePoint();

    setState(() {
      for (var j = 0; j < _list.length; j++) {
        _samplingPointList.add(_list[j]['sampling_point'].toString());
      }
      _samplingPointList.add('OTHERS');
    });
  }

  Future<void> sessionlogin() async {
    // _onSelectedparameters();
    // ignore: no_leading_underscores_for_local_identifiers
    final _loggedUser = await SessionManager().get("loggedUser");
    Map<String, dynamic> _userDetails = _loggedUser;

    setState(() {
      _userName = _userDetails["employee_id"];
      _userName = _userDetails["employee_id"];
    });
  }

  // Future<void> getArnumber() async {
  //   String Arnumber = await selectFunction.geArnumber();
  //   setState(() {
  //     _Arnumber = Arnumber;
  //     _sampleData.add({
  //       'id': 1,
  //       'sampleSource': null,
  //       'otherSampleSource': '',
  //       'otherSampleSourceIsActive': false,
  //       'samplingPoint': null,
  //       'otherSamplingPoint': '',
  //       'otherSamplingPointIsActive': false,
  //       'samplingLocation': '',
  //       'timeOfSampling': '',
  //       'samplingID': _Arnumber + '_1',
  //     });
  //   });
  // }

  void addSample() {
    TextEditingController _eachotherSampleSource = TextEditingController();
    TextEditingController _eachotherSamplingPoint = TextEditingController();
    TextEditingController _eachotherLocation = TextEditingController();
    TextEditingController _eachtimeInput = TextEditingController();

    _otherSampleSource.add(_eachotherSampleSource);
    _otherSamplingPoint.add(_eachotherSamplingPoint);
    _otherLocation.add(_eachotherLocation);
    _timeInput.add(_eachtimeInput);

    setState(() {
      int _id = _sampleData.length;
      _id = _id += 1;
      _sampleData.add({
        'id': _id,
        'sampleSource': null,
        'otherSampleSource': '',
        'otherSampleSourceIsActive': false,
        'samplingPoint': null,
        'otherSamplingPoint': '',
        'otherSamplingPointIsActive': false,
        'samplingLocation': '',
        'timeOfSampling': '',
        'samplingID': '${widget.rwtNo}_$_id',
      });
    });
  }

  void removesample() {
    setState(() {
      _sampleData.removeLast();
      _otherSampleSource.removeLast();
      _otherSamplingPoint.removeLast();
      _timeInput.removeLast();
    });
  }

  bool step2Validation() {
    int _errorCount = 0;
    for (var i = 0; i < _sampleData.length; i++) {
      if (_sampleData[i]['otherSampleSourceIsActive'] == false) {
        if (_sampleData[i]['sampleSource'] == '' ||
            _sampleData[i]['sampleSource'] == null) {
          _errorCount += 1;
        }
      } else {
        if (_sampleData[i]['otherSampleSource'] == '' ||
            _sampleData[i]['otherSampleSource'] == null) {
          _errorCount += 1;
        }
      }
      if (_sampleData[i]['otherSamplingPointIsActive'] == false) {
        if (_sampleData[i]['samplingPoint'] == '' ||
            _sampleData[i]['samplingPoint'] == null) {
          _errorCount += 1;
        }
      } else {
        if (_sampleData[i]['otherSamplingPoint'] == '' ||
            _sampleData[i]['otherSamplingPoint'] == null) {
          _errorCount += 1;
        }
      }
    }
    if (_errorCount > 0) {
      return false;
      // _showMyDialog();
    } else {
      return true;
    }
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onSelectedparameters() async {
    _selectedParameter = [];
    for (var i = 0; i < _checkboxBacterialogical.length; i++) {
      if (_checkboxBacterialogical[i]['is_checked'] == true) {
        setState(() {
          _selectedBacteriological
              .add(_checkboxBacterialogical[i]['parameter_name']);
          _selectedParameter.add(_checkboxBacterialogical[i]['parameter_id']);
        });
      }
    }
    for (var l = 0; l < _checkboxPhysicalChemical.length; l++) {
      if (_checkboxPhysicalChemical[l]['is_checked'] == true) {
        setState(() {
          _selectedPhysicalChemical
              .add(_checkboxPhysicalChemical[l]['parameter_name']);
          _selectedParameter.add(_checkboxPhysicalChemical[l]['parameter_id']);
        });
      }
    }
  }

  _amountChange(bool _isCheck, double _amount) {
    int _sampleDataCounts = _sampleData.length;
    if (_isCheck == true) {
      setState(() {
        _totalAmount += _amount * _sampleDataCounts;
        _TotalAmount = TextEditingController()
          ..text = _totalAmount.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _totalAmount -= _amount * _sampleDataCounts;
        _TotalAmount = TextEditingController()
          ..text = _totalAmount.toStringAsFixed(2);
      });
    }
  }

  Future<void> _onSelected(bool _isCheck, String _amount, String _packageId,
      String _packageName) async {
    double _intAmount = double.parse(_amount);
    int _nochecked = 0;
    if (_isCheck == true) {
      setState(() {
        _totalAmount = 0;
        enabledtestpakage = false;
        _bacterialogical.clear();
        enabledpysicalChemical = false;
        _physicalchemical.clear();
      });

      final _packageParameters =
          await selectFunction.getPackageParameter(_packageId);
      for (var j = 0; j < _checkboxPhysicalChemical.length; j++) {
        _checkboxPhysicalChemical[j]['is_checked'] = false;
        for (var k = 0; k < _packageParameters.length; k++) {
          if (_checkboxPhysicalChemical[j]['parameter_id'] ==
              _packageParameters[k]['parameter_id']) {
            setState(() {
              _checkboxPhysicalChemical[j]['is_checked'] = true;
            });
          }
        }
      }

      for (var g = 0; g < _checkboxBacterialogical.length; g++) {
        _checkboxBacterialogical[g]['is_checked'] = false;
        for (var n = 0; n < _packageParameters.length; n++) {
          if (_checkboxBacterialogical[g]['parameter_id'] ==
              _packageParameters[n]['parameter_id']) {
            setState(() {
              _checkboxBacterialogical[g]['is_checked'] = true;
            });
          }
        }
      }
      setState(() {
        _selectedPackage = _packageId;
        _selectedPackageName = _packageName;
      });
    } else {
      for (var l = 0; l < _checkboxPhysicalChemical.length; l++) {
        _checkboxPhysicalChemical[l]['is_checked'] = false;
      }
      for (var v = 0; v < _checkboxBacterialogical.length; v++) {
        _checkboxBacterialogical[v]['is_checked'] = false;
      }
      setState(() {
        _selectedPackage = "";
        _selectedPackageName = "";
      });
    }
    for (var i = 0; i < _checkboxPackage.length; i++) {
      if (_checkboxPackage[i]['is_checked'] == true) {
        _nochecked += 1;
      }
    }
    if (_nochecked > 0) {
      setState(() {
        _bactIsDisabled = 1;
        _phyIsDisabled = 1;
      });
    } else {
      setState(() {
        _bactIsDisabled = 0;
        _phyIsDisabled = 0;
        enabledtestpakage = true;
        _bacterialogical.clear();
        enabledpysicalChemical = true;
        _physicalchemical.clear();
      });
    }
    _amountChange(_isCheck, _intAmount);
    print(_selectedPackage);
  }

  Future<void> _onSelected1(
      bool _isCheck, String _amount, String parameterId) async {
    double _intAmount = double.parse(_amount);
    int _nochecked = 0;
    if (_isCheck == true) {
      setState(() {
        // _selectedBacteriological.add(parameter_id);
        _TotalAmount = TextEditingController()
          ..text = _intAmount.toStringAsFixed(2);
        print(_selectedBacteriological);
        print(_intAmount);
        enabledpysicalChemical = false;
        _physicalchemical.clear();
      });
    } else {
      setState(() {
        // _selectedBacteriological.remove(parameter_id);
        _TotalAmount = TextEditingController()..text = "";
      });
    }
    for (var i = 0; i < _checkboxBacterialogical.length; i++) {
      if (_checkboxBacterialogical[i]['is_checked'] == true) {
        _nochecked += 1;
      }
    }
    if (_nochecked > 0) {
      setState(() {
        _packIsDisabled = 1;
        _phyIsDisabled = 1;
      });
    } else {
      setState(() {
        _packIsDisabled = 0;
        _phyIsDisabled = 0;
        enabledpysicalChemical = true;
        _physicalchemical.clear();
      });
    }
    _amountChange(_isCheck, _intAmount);
  }

  void _print() async {
    await SunmiPrinter.printText(
        content: "Test String",
        style: SunmiStyle(
            fontSize: 20,
            isUnderLine: true,
            bold: false,
            align: SunmiPrintAlign.LEFT));
  }

  Future<void> _onSelected2(
      bool _isCheck, String _amount, String parameterId) async {
    double _intAmount = double.parse(_amount);
    int _nochecked = 0;
    if (_isCheck == true) {
      setState(() {
        // _selectedPhysicalChemical.add(parameter_id);
        print(_selectedPhysicalChemical);
        enabledtestpakage = false;
        _bacterialogical.clear();
        print(_intAmount);
      });
    } else {
      setState(() {
        // _selectedPhysicalChemical.remove(parameter_id);
      });
    }
    for (var i = 0; i < _checkboxPhysicalChemical.length; i++) {
      if (_checkboxPhysicalChemical[i]['is_checked'] == true) {
        _nochecked += 1;
      }
    }
    if (_nochecked > 0) {
      setState(() {
        _packIsDisabled = 1;
        _bactIsDisabled = 1;
      });
    } else {
      setState(() {
        _packIsDisabled = 0;
        _bactIsDisabled = 0;
        enabledtestpakage = true;
        _bacterialogical.clear();
      });
    }
    _amountChange(_isCheck, _intAmount);
  }

  Future<void> getPhysicalchemical() async {
    final List<Map> _physicoChemical =
        await selectFunction.getPhysicalchecmical();

    setState(() {
      _checkboxPhysicalChemical = _physicoChemical;
    });
  }

  Future<void> getBacterialogical() async {
    final List<Map> _bacteriological =
        await selectFunction.getBacterialogical();

    setState(() {
      _checkboxBacterialogical = _bacteriological;
    });
  }

  Future<void> getpackages() async {
    final List<Map> _testPackages = await selectFunction.getTestpakage();

    setState(() {
      _checkboxPackage = _testPackages;
    });
  }

  Future<void> getBranchDetails() async {
    final List<Map> _list = await selectFunction.getbranchcode();

    setState(() {
      _branchName = _list[0]['branch_name'].toString();
      _branchCode = _list[0]['branch_id'].toString();
    });
  }

  Future<void> saveStep1() async {
    String _converteDateInputStarted =
        await convertToDateWithTimezone(_dateInputStarted);
    setState(() {
      _updateClientData = {
        'rwt_no': _rwt_no.text,
        'company_name': _company_name.text.toUpperCase(),
        'registered_owner_name': _registerowners.text.toUpperCase(),
        'contact_person_name': _ContactPerson.text.toUpperCase(),
        'address': valueAdress.toUpperCase(),
        'telephone_number': _telephone_no.text,
        'fax_number': _fax_no.text,
        'email_address': _email_address.text,
        'cellphone_number': _cellphone_no.text
      };
    });
    Map<dynamic, dynamic> _result =
        await saveRwt.updateRwtClientData(_updateClientData);

    if (_result['code'] == "1") {
      _showSnackBar(_result['message'], true);
    } else {
      _showSnackBar(_result['message'], false);
    }
  }

  Future<void> saveStep2() async {
    setState(() => _dateOfSampling = _dateInput.text);

    for (var i = 0; i < _sampleData.length; i++) {
      String _convertedTime =
          await convertToTimeWithTimezone(_timeInput[i].text);

      setState(() {
        _sampleData[i]['otherSampleSource'] =
            _otherSampleSource[i].text.toUpperCase();
        _sampleData[i]['otherSamplingPoint'] =
            _otherSamplingPoint[i].text.toUpperCase();
        _sampleData[i]['samplingLocation'] =
            _otherLocation[i].text.toUpperCase();
        _sampleData[i]['timeOfSampling'] = _convertedTime;
      });
    }
    Map<dynamic, dynamic> _result = await saveRwt.saveSampleData(
        _sampleData, widget.rwtNo, _dateOfSampling);

    if (_result['code'] == "1") {
      _showSnackBar(_result['message'], true);
    } else {
      _showSnackBar(_result['message'], false);
    }
  }

  Future<void> saveStep3() async {
    _onSelectedparameters();
    if (_selectedParameter.length == 0) {
      _showMyDialog('Validation', 'Please Select Test Parameters or Package');
    }
    Map<dynamic, dynamic> typeOfTestData = {
      'rwt_no': widget.rwtNo,
      // 'branch_id': _branchCode,
      // 'special_instruction': _Specical_Instructions.text.toUpperCase(),
      // 'test_package': _selectedPackage,
      // 'total_amount': _TotalAmount.text,
      'branch_id': _branchCode,
      'special_instruction': _Specical_Instructions.text.toUpperCase(),
      'payment_type': _payment.toString().toUpperCase(),
      'amount_paid': _amountPaid.text.toUpperCase(),
      'payment_remarks': _remarks.text.toUpperCase(),
      'test_package': _selectedPackage,
      'total_amount': _TotalAmount.text,
    };
    print(_selectedPackage);
    print(_selectedParameter);
    print(_TotalAmount.text);

    Map<dynamic, dynamic> _result = await saveRwt.saveTypeofTest(
        _sampleData, _selectedParameter, typeOfTestData);

    if (_result['code'] == "1") {
      _showSnackBar(_result['message'], true);
    } else {
      _showSnackBar(_result['message'], false);
    }
  }

  Future<void> saveStep4() async {
    _dateInputEnded = DateTime.now();
    String _converteDateInputEnded =
        await convertToDateWithTimezone(_dateInputEnded);

    int paidCount = 1;
    Map<dynamic, dynamic> acknowledgementData = {
      'submitedby': _ContactPerson.text.toUpperCase(),
      'payment_remarks': _remarks.text.toUpperCase(),
      'reciveBy': _userName,
      'dateInputEnd': _converteDateInputEnded,
      'rwtNO': widget.rwtNo
    };

    print(_Submittedsignature.text);
    print(_paidAmount.text);
    print(_converteDateInputEnded);

    Map<dynamic, dynamic> _saveResult =
        await saveRwt.saveAcknowledgementData(acknowledgementData);

    if (_saveResult['code'] == "1") {
      _showSnackBar(_saveResult['message'], true);
    } else {
      _showSnackBar(_saveResult['message'], false);
    }
  }

  Future<void> getRwtData() async {
    final Map rwtClientData =
        await selectFunction.getRwtClientData(widget.rwtNo);
    List<String> _myList = [];
    List<String> _addressList = [];

    // String optionView = "Plese Select Address";
    setState(() {
      _rwt_no.text = rwtClientData['rwt_no'];
      _company_name.text = rwtClientData['company_name'];
      _registerowners.text = rwtClientData['registered_owner_name'];
      _ContactPerson.text = rwtClientData['contact_person_name'];
      _email_address.text = rwtClientData['email_address'];
      _telephone_no.text = rwtClientData['telephone_no'];
      _fax_no.text = rwtClientData['fax_no'];
      _cellphone_no.text = rwtClientData['cellphone_no'];

      // Map<dynamic, dynamic> _jsonAddress = jsonDecode(rwtClientData['address']);
      // _myList.add(_jsonAddress.toString());

      // _myList.add(rwtClientData['address']);
      var _addressOptions = rwtClientData['address_options'];

      if (_addressOptions['address1'] == "" ||
          _addressOptions['address1'] == null) {
      } else {
        _addressList.add("PLESE SELECT ADDRESS");
        Map<dynamic, dynamic> _jsonAddress1 =
            jsonDecode(_addressOptions['address1']);

        String _addressoptiondata1 = _jsonAddress1['region'] +
            ' ' +
            _jsonAddress1['province'] +
            ' ' +
            _jsonAddress1['city'] +
            ' ' +
            _jsonAddress1['barangay'] +
            ' ' +
            _jsonAddress1['street_address'] +
            ' ' +
            _jsonAddress1['zip_code'];
        _addressList.add(_addressoptiondata1);
      }

      if (_addressOptions['address2'] == "" ||
          _addressOptions['address2'] == null) {
      } else {
        Map<dynamic, dynamic> _jsonAddress2 =
            jsonDecode(_addressOptions['address2']);

        String _addressoptiondata2 = _jsonAddress2['region'] +
            ' ' +
            _jsonAddress2['province'] +
            ' ' +
            _jsonAddress2['city'] +
            ' ' +
            _jsonAddress2['barangay'] +
            ' ' +
            _jsonAddress2['street_address'] +
            ' ' +
            _jsonAddress2['zip_code'];
        _addressList.add(_addressoptiondata2);
      }

      if (_addressOptions['address3'] == "" ||
          _addressOptions['address3'] == null) {
      } else {
        Map<dynamic, dynamic> _jsonAddress3 =
            jsonDecode(_addressOptions['address3']);

        String _addressoptiondata3 = _jsonAddress3['region'] +
            ' ' +
            _jsonAddress3['province'] +
            ' ' +
            _jsonAddress3['city'] +
            ' ' +
            _jsonAddress3['barangay'] +
            ' ' +
            _jsonAddress3['street_address'] +
            ' ' +
            _jsonAddress3['zip_code'];
        _addressList.add(_addressoptiondata3);
      }

      // Map<dynamic, dynamic> jsonAddress1 =
      //     jsonDecode(rwtClientData['address1']);
      // _AddressList.add(jsonAddress1.toString());

      // Map<dynamic, dynamic> jsonAddress2 =
      //     jsonDecode(rwtClientData['address2']);
      // _AddressList.add(jsonAddress2.toString());

      setState(() {
        valueAdress = rwtClientData['address'].toString();
      });

      setState(() {
        addressOption = _addressList;
      });

      if (rwtClientData['submitted_by'] == "null" ||
          rwtClientData['submitted_by'] == "") {
        _Submittedsignature.text = "";
      } else {
        _Submittedsignature.text = rwtClientData['submitted_by'];
      }

      if (rwtClientData['is_paid_remarks'] == "null" ||
          rwtClientData['is_paid_remarks'] == "") {
        _paymentKey.currentState?.reset();
      } else {
        _payment = rwtClientData['is_paid_remarks'];
      }
    });
  }

  Future<void> getRwtDataParameters() async {
    final Map rwtClientData =
        await selectFunction.getRwtParametersData(widget.rwtNo);

    if (rwtClientData['code'] == "1") {
      Map _data = rwtClientData['data'];
      setState(() {
        _totalAmount = double.parse(_data['total_amount']);
        _Specical_Instructions.text = _data['special_instructions'].toString();
        _TotalAmount.text = _totalAmount.toStringAsFixed(2);
        _rwtParameters = _data['parameters'];
        _remarks.text = _data['payment_remarks'].toString();
        _payment = _data['payment_type'].toString();

        if (_data['payment_type'] == "FULL PAYMENT") {
          enabledAmountpaid = false;
          _amountPaid = _TotalAmount;
        } else if (_data['payment_type'] == "PARTIAL PAYMENT") {
          enabledAmountpaid = true;
          var _amountPaid1 = TextEditingController()..text = "0.00";
          setState(() {
            _amountPaid = _amountPaid1;
            print(_amountPaid.text);
          });
        } else if (_data['payment_type'] == "CREDIT") {
          enabledAmountpaid = false;

          var _amountPaid2 = TextEditingController()..text = "0.00";
          setState(() {
            _amountPaid = _amountPaid2;
            print(_amountPaid.text);
          });
        }
      });

      if (_data['package_tests'] == "" || _data['package_tests'] == null) {
        _bactIsDisabled = 0;
        _phyIsDisabled = 0;
        _packIsDisabled = 1;
      } else {
        _bactIsDisabled = 1;
        _phyIsDisabled = 1;
        _packIsDisabled = 0;
      }

      for (var package in _checkboxPackage) {
        if (package['package_id'] == _data['package_tests']) {
          setState(() {
            package['is_checked'] = true;
          });
        } else {
          setState(() {
            package['is_checked'] = false;
          });
        }
      }

      for (var bacteriological in _checkboxBacterialogical) {
        for (var parameterId in _rwtParameters) {
          if (bacteriological['parameter_id'] == parameterId) {
            setState(() {
              bacteriological['is_checked'] = true;
            });
          }
        }
      }

      for (var physicoChemical in _checkboxPhysicalChemical) {
        for (var parameterId in _rwtParameters) {
          if (physicoChemical['parameter_id'] == parameterId) {
            setState(() {
              physicoChemical['is_checked'] = true;
            });
          }
        }
      }
    }
  }

  bool step1Validation() {
    int _errorCount = 0;

    // ignore: unnecessary_null_comparison
    if (valueAdress == '' || valueAdress == null) {
      _errorCount += 1;
    }

    if (_errorCount > 0) {
      return false;
      // _showMyDialog();
    } else {
      return true;
    }
  }

  Future<void> getRwtSamplesData() async {
    // ignore: unused_local_variable

    final Map _rwtSampleData =
        await selectFunction.getRwtSamplesdata(widget.rwtNo);

    if (_rwtSampleData['code'] == "1") {
      List<Map> _sampledata = _rwtSampleData['data'];

      _dateInput.text = _sampledata[0]['date_of_sampling'];

      for (var i = 0; i < _sampledata.length; i++) {
        TextEditingController _eachotherSampleSource = TextEditingController();
        TextEditingController _eachotherSamplingPoint = TextEditingController();
        TextEditingController _eachotherLocation = TextEditingController();
        TextEditingController _eachtimeInput = TextEditingController();

        _otherSampleSource.add(_eachotherSampleSource);
        _otherSamplingPoint.add(_eachotherSamplingPoint);
        _otherLocation.add(_eachotherLocation);
        _timeInput.add(_eachtimeInput);
        String _sampleSourceValue = '';
        String _otherSampleSourceValue = '';
        int _sampleSourceInChoices = 0;
        bool _otherSampleSourceIsActive = false;

        for (var j = 0; j < _sampleSourceList.length; j++) {
          if (_sampledata[i]['sample_source'] == _sampleSourceList[j]) {
            _sampleSourceInChoices = 1;
          }
        }
        if (_sampleSourceInChoices == 1) {
          _otherSampleSourceIsActive = false;
          _sampleSourceValue = _sampledata[i]['sample_source'];
        } else {
          _sampleSourceValue = 'OTHERS';
          _otherSampleSourceIsActive = true;
          _otherSampleSourceValue = _sampledata[i]['sample_source'];
          _otherSampleSource[i].text = _sampledata[i]['sample_source'];
        }

        String _samplingPointeValue = '';
        String _otherSamplingPointValue = '';
        int _samplingPointInChoices = 0;
        bool _otherSamplingPointIsActive = false;

        for (var h = 0; h < _samplingPointList.length; h++) {
          if (_sampledata[i]['sampling_point'] == _samplingPointList[h]) {
            _samplingPointInChoices = 1;
          }
        }
        if (_samplingPointInChoices == 1) {
          _otherSamplingPointIsActive = false;
          _samplingPointeValue = _sampledata[i]['sampling_point'];
        } else {
          _samplingPointeValue = 'OTHERS';
          _otherSamplingPointIsActive = true;
          _otherSamplingPointValue = _sampledata[i]['sampling_point'];
          _otherSamplingPoint[i].text = _sampledata[i]['sampling_point'];
        }

        setState(() {
          var id = i;
          _sampleData.add({
            'id': id + 1,
            'sampleSource': _sampleSourceValue,
            'otherSampleSource': _otherSampleSourceValue,
            'otherSampleSourceIsActive': _otherSampleSourceIsActive,
            'samplingPoint': _samplingPointeValue,
            'otherSamplingPoint': _otherSamplingPointValue,
            'otherSamplingPointIsActive': _otherSamplingPointIsActive,
            'samplingLocation': _sampledata[i]['sampling_location'],
            'timeOfSampling': _sampledata[i]['time_of_sampling'],
            'samplingID': _sampledata[i]['water_sampling_id'],
          });

          String _strTimeOfSampling = _sampledata[i]['time_of_sampling'];
          _strTimeOfSampling = _strTimeOfSampling.substring(0, 8);
          DateTime _dateTimeOfSampling =
              DateFormat("hh:mm:ss").parse(_strTimeOfSampling);
          String _convertedTo12Hourformat =
              DateFormat("hh:mm:ss a").format(_dateTimeOfSampling);

          _otherLocation[i].text = _sampledata[i]['sampling_location'];
          _timeInput[i].text = _convertedTo12Hourformat;
        });
      }
    }
  }

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
            body: Theme(
              data: ThemeData(
                  colorScheme: const ColorScheme.light(
                      primary: Color.fromARGB(255, 36, 57, 149))),
              child: Stepper(
                type: StepperType.horizontal,
                steps: getSteps(),
                currentStep: currentStep,
                onStepContinue: () {
                  final isLastStep = currentStep == getSteps().length - 1;
                  if (isLastStep) {
                    if (!_formKey3.currentState!.validate()) {
                      return print('Fill form correctly');
                    }
                    saveStep3();
                    saveStep4();
                    _showDialogSuccessfillup();
                  } else if (currentStep == 0) {
                    if (!_formKey1.currentState!.validate()) {
                      return print('Fill form correctly');
                    }
                    // address1Function();
                    if (step1Validation() == true) {
                      saveStep1();
                      // addSample();
                      setState(() => currentStep += 1);
                    } else {
                      _showMyDialog("Validation", "Fill form correctly");
                    }
                  } else if (currentStep == 1) {
                    if (!_formKey2.currentState!.validate()) {
                      return print('Fill form correctly');
                      // ignore: unrelated_type_equality_checks
                    }
                    // ignore: unrelated_type_equality_checks

                    if (step2Validation() == true) {
                      saveStep2();
                      setState(() => currentStep += 1);
                    } else {
                      _showMyDialog("Validation", "Fill form correctly");
                    }
                  } //else if (currentStep == 2) {
                  //   if (!_formKey3.currentState!.validate()) {
                  //     return print('Fill form correctly');
                  //   }
                  //   saveStep3();
                  //   setState(() => currentStep += 1);
                  // }
                },
                onStepCancel: () =>
                    currentStep == 0 ? null : setState(() => currentStep -= 1),
                controlsBuilder: (context, ControlsDetails details) {
                  final isLastStep = currentStep == getSteps().length - 1;
                  return Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              // ignore: sort_child_properties_last
                              child: currentStep != 0
                                  ? const Text('Previous')
                                  : const Text('Close'),
                              onPressed: currentStep != 0
                                  ? details.onStepCancel
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const continueRwt(
                                                  title: 'home',
                                                )),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),

                        // ignore: avoid_unnecessary_containers

                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              // ignore: sort_child_properties_last
                              child: isLastStep
                                  ? const Text('Submit')
                                  : const Text(
                                      'Next',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),

                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLastStep
                                    ? Colors.green
                                    : const Color.fromARGB(255, 36, 57, 149),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )));
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title:
              currentStep == 0 ? const Text('Client Details') : const Text(''),
          content: step1(),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: currentStep == 1 ? const Text('Sample Data') : const Text(''),
          content: step2(),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: currentStep == 2 ? const Text('Type of Test') : const Text(''),
          content: step3(),
        ),
        // Step(
        //   state: currentStep > 3 ? StepState.complete : StepState.indexed,
        //   isActive: currentStep >= 3,
        //   title:
        //       currentStep == 3 ? const Text('Acknowledgement') : const Text(''),
        //   content: step4(),
        // ),
      ];

  step1() {
    return Form(
      key: _formKey1,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "RWTNO:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _dateInputStarted = DateTime.now();
                });
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              controller: _rwt_no,
              textAlign: TextAlign.center,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter CompanyName';
                }
                return null;
              },
              decoration: const InputDecoration(
                // isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 108, 108, 124),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Company /Client Name:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _dateInputStarted = DateTime.now();
                  });
                },
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: _company_name,
                textAlign: TextAlign.center,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Company /Client Name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    // isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 108, 108, 124),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
                    ),
                    hintText: "Company /Client Name"),
              )),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Registered Owner's Name:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              controller: _registerowners,
              textAlign: TextAlign.center,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Name of Owners';
                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
                  ),
                  hintText: "Name of Owners"),
            ),
          ),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Contact Person Name:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              controller: _ContactPerson,
              textAlign: TextAlign.center,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Name of Contact Person Name';
                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
                  ),
                  hintText: "Contact Person Name"),
            ),
          ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     "Address:",
          //     style: TextStyle(
          //         color: Color.fromARGB(255, 1, 1, 5),
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold),
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 3, 0, 10),
          //   child: TextFormField(
          //     keyboardType: TextInputType.text,
          //     textCapitalization: TextCapitalization.characters,
          //     textInputAction: TextInputAction.next,
          //     controller: _address,
          //     textAlign: TextAlign.center,
          //     // The validator receives the text that the user has entered.
          //     validator: (value) {
          //       if (value == null || value.isEmpty) {
          //         return 'Please enter Complete Address';
          //       }
          //       return null;
          //     },
          //     decoration: InputDecoration(
          //         contentPadding: EdgeInsets.symmetric(vertical: 3.0),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Color.fromARGB(255, 108, 108, 124),
          //             width: 2.0,
          //           ),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //               color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
          //         ),
          //         hintText: "Address"),
          //   ),
          // ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Telephone No:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _telephone_no,
              textAlign: TextAlign.center,
              // The validator receives the text that the user has entered.
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter Telephone';
              //   }
              //   return null;
              // },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
                  ),
                  hintText: "Telephone"),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Fax No:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _fax_no,
              textAlign: TextAlign.center,
              // The validator receives the text that the user has entered.
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter faxNumber';
              //   }
              //   return null;
              // },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
                  ),
                  hintText: "Fax Number"),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Cellphone No:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
            child: TextFormField(
              maxLength: 16,
              controller: _cellphone_no,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Cellphone No';
                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
                  ),
                  hintText: "09XXXXXXXXX"),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Email Address:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
            child: TextFormField(
              controller: _email_address,
              textAlign: TextAlign.center,
              // The validator receives the text that the user has entered.

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Email Address';
                }
                return null;
              },
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return 'Email is Required';
              //   }
              //   if (!RegExp(
              //           r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
              //       .hasMatch(value)) {
              //     return 'Please enter a valid Email';
              //   }
              //   return null;
              // },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 2.0),
                  ),
                  hintText: "Email Address"),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Address:",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
            child: DropdownButtonFormField(
              isExpanded: true,
              // Initial Value

              value: valueAdress,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: addressOption.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 7.0), // Adjust the padding as needed
                    child: Text(items),
                  ),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value == "") {
                  return 'Please Select Address';
                }
                return null;
              },
              decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 9.0, horizontal: 11),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
                  ),
                  hintText: "Select Address"),

              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalueaddress = newValue!;
                  // if (dropdownvalueaddress == "ADDRESS LINE 1") {
                  //   valueAdress = _addressoptiondata1;
                  // } else if (dropdownvalueaddress == "ADDRESS LINE 2") {
                  //   valueAdress = _addressoptiondata2;
                  // } else if (dropdownvalueaddress == "ADDRESS LINE 3") {
                  //   valueAdress = _addressoptiondata3;
                  // }

                  setState(() {
                    valueAdress = dropdownvalueaddress;
                  });
                  print(valueAdress);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  step2() {
    return Form(
        key: _formKey2,
        child: Column(children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Date of Sampling",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          TextFormField(
            textAlign: TextAlign.center,
            controller: _dateInput,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Select Date';
              }
              return null;
            },
            //editing controller of this TextField
            decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 108, 108, 124),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
                ),
                hintText: "YYYY/MM/DD"),
            readOnly: true,

            //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary:
                            Color.fromARGB(255, 36, 57, 149), // <-- SEE HERE
                        onPrimary:
                            Color.fromARGB(255, 241, 242, 245), // <-- SEE HERE
                        onSurface:
                            Color.fromARGB(255, 36, 57, 149), // <-- SEE HERE
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 3, 3, 141), // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                print(
                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print(
                    formattedDate); //formatted date output using intl package =>  2021-03-16
                setState(() {
                  _dateInput.text =
                      formattedDate; //set output date to TextField value.
                });
              } else {}
              // ignore: unused_label
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
          _sampleData.isNotEmpty
              ? Wrap(
                  children: _sampleData.map((item) {
                    int index = item['id'] - 1;
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ExpansionTileCard(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          initialElevation: 5,
                          elevation: 5,
                          expandedTextColor:
                              const Color.fromARGB(255, 22, 6, 109),
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              AppBar(
                                toolbarHeight: 40,
                                elevation: 0,
                                titleTextStyle: const TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                backgroundColor: Colors.white10,
                                automaticallyImplyLeading: false,
                                title: Text('Sample ${item['id']}'),
                                actions: <Widget>[
                                  IconButton(
                                    alignment: Alignment.centerRight,
                                    onPressed: () {
                                      removesample();
                                      print("remove");
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sample Source:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 1, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: item['sampleSource'],
                                items: _sampleSourceList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Center(
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select SampleSource';
                                  }
                                  return null;
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    item['sampleSource'] = newValue;
                                    if (item['sampleSource'] == "OTHERS") {
                                      item['otherSampleSourceIsActive'] = true;
                                      item['otherSampleSource'] = "";
                                    } else {
                                      item['otherSampleSourceIsActive'] = false;
                                      item['otherSampleSource'] = "";
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 108, 108, 124),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 36, 57, 149),
                                          width: 1.0),
                                    ),
                                    hintText: "Select Sample Source"),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Others:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 1, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child: TextField(
                                controller: _otherSampleSource[index],
                                onChanged: (value) {
                                  setState(() {
                                    item['otherSampleSource'] = value;
                                  });
                                },
                                enabled: item['otherSampleSourceIsActive'],
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 108, 108, 124),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 36, 57, 149),
                                          width: 1.0),
                                    ),
                                    hintText: "Others Sample Source..."),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sampling Point:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 1, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: item['samplingPoint'],
                                items: _samplingPointList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Center(
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Sampling Point';
                                  }
                                  return null;
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    item['samplingPoint'] = newValue;
                                    if (item['samplingPoint'] == "OTHERS") {
                                      item['otherSamplingPointIsActive'] = true;
                                      item['otherSamplingPoint'] = "";
                                    } else {
                                      item['otherSamplingPointIsActive'] =
                                          false;
                                      item['otherSamplingPoint'] = "";
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 108, 108, 124),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 36, 57, 149),
                                          width: 1.0),
                                    ),
                                    hintText: "Select Sampling Point"),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Others:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 1, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child: TextField(
                                controller: _otherSamplingPoint[index],
                                onChanged: (value) {
                                  setState(() {
                                    item['otherSamplingPoint'] = value;
                                  });
                                },
                                enabled: item['otherSamplingPointIsActive'],
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 108, 108, 124),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 36, 57, 149),
                                          width: 1.0),
                                    ),
                                    hintText: "Others Sample Source..."),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sampling Location:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 1, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                              // ignore: sort_child_properties_last
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.characters,
                                textInputAction: TextInputAction.next,
                                textAlign: TextAlign.center,
                                controller: _otherLocation[index],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Date';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 108, 108, 124),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 36, 57, 149),
                                          width: 1.0),
                                    ),
                                    hintText: "Enter Sampling Location"),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Time of Sampling:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 1, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Center(
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: _timeInput[index],
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 108, 108, 124),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 36, 57, 149),
                                            width: 1.0),
                                      ),
                                      hintText: "HH:MM/PM/AM"),
                                  readOnly: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Time';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );

                                    if (pickedTime != null) {
                                      DateTime date = DateTime.now();
                                      String second = date.second
                                          .toString()
                                          .padLeft(2, '0');
                                      List timeSplit =
                                          pickedTime.format(context).split(' ');
                                      String formattedTime = timeSplit[0];
                                      String time = '$formattedTime:$second';
                                      String type = '';
                                      if (timeSplit.length > 1) {
                                        type = timeSplit[1];
                                        time = '$time $type';
                                      }

                                      print(time);
                                      //DateFormat() is from intl package, you can format the time on any pattern you need.

                                      setState(() {
                                        _timeInput[index].text =
                                            time; //set the value of text field.
                                      });
                                    } else {
                                      print("Time is not selected");
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ));
                  }).toList(),
                )
              : Container(),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                addSample();
                // increment();
                print("add");
              },
              icon: const Icon(Icons.add), //icon data for elevated button
              label: const Text("Add"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 36, 57, 149),
              ),
            ),
          ),
        ]));
  }

  step3() {
    return Form(
      key: _formKey3,
      child: Column(
        children: [
          const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 175, 5),
              child: Text(
                "Package Test:",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 1, 5),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),

          _checkboxPackage.isNotEmpty
              ? Wrap(
                  children: _checkboxPackage.map(
                    (item) {
                      return SizedBox(
                        width: 155,
                        height: 45,
                        child: Card(
                          child: InkWell(
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: item['is_checked'],
                                    activeColor:
                                        const Color.fromARGB(255, 36, 57, 149),
                                    checkColor: Colors.white,
                                    onChanged: _packIsDisabled == 1
                                        ? null
                                        : (_newValue) {
                                            for (var i = 0;
                                                i < _checkboxPackage.length;
                                                i++) {
                                              if (_checkboxPackage[i]
                                                      ['package_id'] ==
                                                  item['package_id']) {
                                                setState(() {
                                                  item['is_checked'] =
                                                      _newValue;
                                                  _checkboxPackage[i]
                                                          ['is_checked'] =
                                                      _newValue;
                                                });
                                              } else {
                                                setState(() {
                                                  _checkboxPackage[i]
                                                      ['is_checked'] = false;
                                                });
                                              }
                                            }
                                            _onSelected(
                                                item['is_checked'],
                                                item['amount'],
                                                item['package_id'],
                                                item['package_name']);

                                            //  _onSelected23(
                                            // item['is_checked'], item['amount'], item['package_id']);
                                          },
                                  ),
                                  Expanded(child: Text(item['package_name'])),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                )
              : Container(),

          const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 120, 5),
              child: Text(
                "Bacterialogical Test:",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 1, 5),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),

          _checkboxBacterialogical.isNotEmpty
              ? Wrap(
                  children: _checkboxBacterialogical.map(
                    (item) {
                      return IntrinsicWidth(
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          width: 155,
                          height: 55,
                          child: Card(
                            child: InkWell(
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: item['is_checked'],
                                      activeColor: const Color.fromARGB(
                                          255, 36, 57, 149),
                                      checkColor: Colors.white,
                                      onChanged: _bactIsDisabled == 1
                                          ? null
                                          : (_newValue) {
                                              setState(() {
                                                item['is_checked'] = _newValue;
                                              });
                                              _onSelected1(
                                                  item['is_checked'],
                                                  item['amount'],
                                                  item['parameter_id']);
                                            },
                                    ),
                                    Expanded(
                                        child: Text(item['parameter_name'])),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                )
              : Container(),

          // Padding(
          //     padding: EdgeInsets.fromLTRB(0, 0, 240, 0),
          //     child: Text(
          //       "Others:",
          //       style: TextStyle(color: Color.fromARGB(255, 1, 1, 5), fontSize: 17, fontWeight: FontWeight.bold),
          //     )),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          //   // ignore: sort_child_properties_last
          //   child: TextFormField(
          //     keyboardType: TextInputType.text,
          //     textCapitalization: TextCapitalization.characters,
          //     textInputAction: TextInputAction.next,
          //     textAlign: TextAlign.center,
          //     controller: _bacterialogical,
          //     enabled: enabledtestpakage,
          //     decoration: InputDecoration(
          //         contentPadding: EdgeInsets.symmetric(vertical: 3.0),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Color.fromARGB(255, 108, 108, 124),
          //             width: 1.0,
          //           ),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
          //         ),
          //         hintText: "Bacterialogical Test"),
          //   ),
          // ),
          const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 90, 0),
              child: Text(
                "Physical And Chemical:",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 1, 5),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),

          _checkboxPhysicalChemical.isNotEmpty
              ? Wrap(
                  children: _checkboxPhysicalChemical.map(
                    (item) {
                      return IntrinsicWidth(
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          width: 155,
                          height: 45,
                          child: Card(
                            child: InkWell(
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: item['is_checked'],
                                      activeColor: const Color.fromARGB(
                                          255, 36, 57, 149),
                                      checkColor: Colors.white,
                                      onChanged: _phyIsDisabled == 1
                                          ? null
                                          : (_newValue) {
                                              setState(() {
                                                item['is_checked'] = _newValue;
                                              });
                                              _onSelected2(
                                                  item['is_checked'],
                                                  item['amount'],
                                                  item['parameter_id']);
                                            },
                                    ),
                                    Expanded(
                                        child: Text(item['parameter_name'])),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                )
              : Container(),

          // Padding(
          //     padding: EdgeInsets.fromLTRB(0, 0, 240, 0),
          //     child: Text(
          //       "Others:",
          //       style: TextStyle(color: Color.fromARGB(255, 1, 1, 5), fontSize: 17, fontWeight: FontWeight.bold),
          //     )),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          //   // ignore: sort_child_properties_last
          //   child: TextFormField(
          //     keyboardType: TextInputType.text,
          //     textCapitalization: TextCapitalization.characters,
          //     textInputAction: TextInputAction.next,
          //     textAlign: TextAlign.center,
          //     controller: _physicalchemical,
          //     enabled: enabledpysicalChemical,
          //     decoration: InputDecoration(
          //         contentPadding: EdgeInsets.symmetric(vertical: 3.0),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Color.fromARGB(255, 108, 108, 124),
          //             width: 1.0,
          //           ),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
          //         ),
          //         hintText: "Others Physical And Chemical"),
          //   ),
          // ),
          const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 130, 0),
              child: Text(
                "Specical Instructions",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 1, 5),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            // ignore: sort_child_properties_last
            child: TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              controller: _Specical_Instructions,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
                  ),
                  hintText: "Specical Instructions"),
            ),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 185, 0),
              child: Text(
                "Total Amount:",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 1, 5),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            // ignore: sort_child_properties_last
            child: TextFormField(
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              // onChanged: (value) => setState(() {

              // }),
              onEditingComplete: () {
                double _totalAmountWithDecimal =
                    double.parse(_TotalAmount.text);
                _totalAmount = _totalAmountWithDecimal;
                _TotalAmount.text = _totalAmountWithDecimal.toStringAsFixed(2);
              },
              // inputFormatters: TextInputFormatter('double'),
              controller: _TotalAmount,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Total Amount';
                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
                  ),
                  hintText: "₱ 0.00"),
            ),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 185, 0),
              child: Text(
                "Payment Type:",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 1, 5),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              )),

          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: _payment,
              items: Paymentype.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(value),
                  ),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Select Payment';
                }
                return null;
              },
              onChanged: (String? newValue) {
                setState(() {
                  _payment = newValue;
                  if (_payment == "FULL PAYMENT") {
                    // ignore: unrelated_type_equality_checks
                    enabledAmountpaid = false;
                    _amountPaid = _TotalAmount;

                    print(_amountPaid.text);
                  } else if (_payment == "PARTIAL PAYMENT") {
                    enabledAmountpaid = true;
                    var _amountPaid1 = TextEditingController()..text = "0.00";
                    setState(() {
                      _amountPaid = _amountPaid1;
                      print(_amountPaid.text);
                    });
                    // _amountPaid =
                    //     double.parse(valueamount) as TextEditingController;
                    // print(_payment);
                  } else if (_payment == "CREDIT") {
                    enabledAmountpaid = false;

                    var _amountPaid2 = TextEditingController()..text = "0.00";
                    setState(() {
                      _amountPaid = _amountPaid2;
                      print(_amountPaid.text);
                    });
                  }
                });
              },
              decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
                  ),
                  hintText: "Select Payment"),
            ),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 185, 0),
              child: Text(
                "Amaount Paid:",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 1, 5),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              )),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: TextFormField(
              onChanged: (value) => setState(() => _amountPaid.text = value),
              controller: _amountPaid,
              enabled: enabledAmountpaid,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 108, 108, 124),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
                ),
              ),
            ),
          ),

          const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 185, 0),
              child: Text(
                "Payment Remarks:",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 1, 5),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            // ignore: sort_child_properties_last
            child: TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              controller: _remarks,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 108, 108, 124),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
                  ),
                  hintText: "Remarks"),
            ),
          ),
        ],
      ),
    );
  }

  // step4() {
  //   return Form(
  //     key: _formKey4,
  //     child: Column(
  //       children: [
  //         const Padding(
  //             padding: EdgeInsets.fromLTRB(0, 0, 220, 0),
  //             child: Text(
  //               "Receive by:",
  //               style: TextStyle(
  //                 color: Color.fromARGB(255, 1, 1, 5),
  //                 fontSize: 17,
  //               ),
  //             )),
  //         const Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15)),
  //         Padding(
  //             padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
  //             child: Text(
  //               _userName,
  //               style: const TextStyle(
  //                   color: Color.fromARGB(255, 1, 1, 5),
  //                   fontSize: 17,
  //                   fontWeight: FontWeight.bold),
  //             )),
  //         const Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15)),
  //         const Padding(
  //             padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
  //             child: Text(
  //               "I Hereby authorized CEBU AGUA LAB INC. to perform the analysis indicated.",
  //               style: TextStyle(
  //                 color: Color.fromARGB(255, 1, 1, 5),
  //                 fontSize: 17,
  //               ),
  //             )),
  //         const Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15)),
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
  //           child: Align(
  //               alignment: Alignment.centerLeft,
  //               child: Text(
  //                 "Submitted by:",
  //                 style: TextStyle(
  //                   color: Color.fromARGB(255, 1, 1, 5),
  //                   fontSize: 17,
  //                 ),
  //               )),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
  //           // ignore: sort_child_properties_last
  //           child: TextFormField(
  //             // onChanged: (value) => setState(() => _submittedby = value),
  //             keyboardType: TextInputType.text,
  //             textCapitalization: TextCapitalization.characters,
  //             textInputAction: TextInputAction.next,
  //             textAlign: TextAlign.center,
  //             controller: _Submittedsignature,
  //             // The validator receives the text that the user has entered.
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter Full Name';
  //               }
  //               return null;
  //             },
  //             decoration: const InputDecoration(
  //                 contentPadding: EdgeInsets.symmetric(vertical: 3.0),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Color.fromARGB(255, 108, 108, 124),
  //                     width: 1.0,
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                       color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
  //                 ),
  //                 hintText: "Text Here..."),
  //           ),
  //         ),
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
  //           child: Align(
  //               alignment: Alignment.centerLeft,
  //               child: Text(
  //                 "Payment:",
  //                 style: TextStyle(
  //                   color: Color.fromARGB(255, 1, 1, 5),
  //                   fontSize: 17,
  //                 ),
  //               )),
  //         ),

  //         // Padding(
  //         //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
  //         //   // ignore: sort_child_properties_last
  //         //   child: TextFormField(
  //         //     onChanged: (value) => setState(() => _paidtotalamount = value),
  //         //     keyboardType: TextInputType.number,
  //         //     textCapitalization: TextCapitalization.characters,
  //         //     textInputAction: TextInputAction.next,
  //         //     textAlign: TextAlign.center,
  //         //     controller: _paidAmount,
  //         //     // The validator receives the text that the user has entered.
  //         //     validator: (value) {
  //         //       if (value == null || value.isEmpty) {
  //         //         return 'Please Paid TotalAmount';
  //         //       }
  //         //       return null;
  //         //     },
  //         //     decoration: InputDecoration(
  //         //         contentPadding: EdgeInsets.symmetric(vertical: 3.0),
  //         //         enabledBorder: OutlineInputBorder(
  //         //           borderSide: BorderSide(
  //         //             color: Color.fromARGB(255, 108, 108, 124),
  //         //             width: 1.0,
  //         //           ),
  //         //         ),
  //         //         focusedBorder: OutlineInputBorder(
  //         //           borderSide: BorderSide(color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
  //         //         ),
  //         //         hintText: "₱ 0.00"),
  //         //   ),
  //         // ),

  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
  //           child: DropdownButtonFormField<String>(
  //             isExpanded: true,
  //             value: _payment,
  //             key: _paymentKey,
  //             items: _paymentStatus.map((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Center(
  //                   child: Text(value),
  //                 ),
  //               );
  //             }).toList(),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please Select Payment';
  //               }
  //               return null;
  //             },
  //             onChanged: (String? newValue) {
  //               setState(() {
  //                 _payment = newValue;
  //               });
  //             },
  //             decoration: const InputDecoration(
  //                 isDense: true,
  //                 contentPadding:
  //                     EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Color.fromARGB(255, 108, 108, 124),
  //                     width: 1.0,
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                       color: Color.fromARGB(255, 36, 57, 149), width: 1.0),
  //                 ),
  //                 hintText: "Select Payment"),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  showdialogLoding() async {
    //added this dynamic variable
    showDialog(
        context: context,
        builder: (context) {
          //assigned the context to my variable
          return Container(
            child: AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    padding: const EdgeInsets.only(left: 25),
                    child: const Text("Loading...."),
                  ),
                ],
              ),
            ),
          );
        });

    //and used it to pop the dialog when updateDetails() is done
  }

  Future<void> _showDialogSuccessfillup() async {
    String totalamount1 = _TotalAmount.text;
    showGeneralDialog(
        context: context,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height - 1,
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "$_branchName",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 1, 1, 5),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Color.fromARGB(84, 96, 125, 139),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "AR No : ${widget.rwtNo}",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 5),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Date : $printercurrentDate",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 1, 1, 5),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Colors.white,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Color.fromARGB(84, 96, 125, 139),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Client Details:",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 5),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Color.fromARGB(84, 96, 125, 139),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Company / Client Name:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _company_name.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Register Owner's Name:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _registerowners.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Contact Person:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _ContactPerson.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Address:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  valueAdress.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Tel No/fax No:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _telephone_no.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Cellphone No:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _cellphone_no.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Email Address:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _email_address.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Payment Type:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _payment.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Amount Paid:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _amountPaid.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Payment Remarks:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _remarks.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Colors.white,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Color.fromARGB(84, 96, 125, 139),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Type of Test:",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 5),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Color.fromARGB(84, 96, 125, 139),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Package Test:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _selectedPackageName,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Bacterialogical Test:",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 15, 15, 15),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                                children: _selectedBacteriological
                                    .map((i) => Text(
                                          i.toString(),
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 1, 1, 5),
                                              fontSize: 15),
                                          textAlign: TextAlign.left,
                                        ))
                                    .toList()),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Physical And Chemical:",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                                children: _selectedPhysicalChemical
                                    .map((i) => Text(
                                          i.toString(),
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 1, 1, 5),
                                              fontSize: 15),
                                          textAlign: TextAlign.left,
                                        ))
                                    .toList()),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Colors.white,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Color.fromARGB(84, 96, 125, 139),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Total Amount:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  totalamount1,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Color.fromARGB(84, 96, 125, 139),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Received by:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _userName,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  "Submited by:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _ContactPerson.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        ),
                        Center(
                          child: SizedBox(
                            height: 60,
                            width: 300,
                            child: TextButton(
                              onPressed: () {
                                _print();
                                _selectedBacteriological.clear();
                                _selectedPhysicalChemical.clear();
                                _selectedParameter.clear();
                                // showdialogLoding();
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return HomeScreen(signOut);
                                }));
                              },
                              // ignore: sort_child_properties_last
                              child: const Text(
                                'Print',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0)),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 36, 57, 149),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                          color: Colors.white,
                        ),
                        Center(
                          child: SizedBox(
                            height: 60,
                            width: 300,
                            child: TextButton(
                              onPressed: () {
                                _selectedBacteriological.clear();
                                _selectedPhysicalChemical.clear();
                                _selectedParameter.clear();
                                Navigator.of(context).pop(false);
                              },
                              // ignore: sort_child_properties_last
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0)),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 215, 25, 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
