// ignore_for_file: unused_import
import 'dart:convert';

import 'package:cali_mobile_app/model/db_agua_lab.dart';
import 'package:cali_mobile_app/view/upload_rwt.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class selectFunction {
  static dynamic jsonDecode(String source,
          {Object? reviver(Object? key, Object? value)?}) =>
      json.decode(source, reviver: reviver);

  static Future<List<Map>> getDatasampleList() async {
    MyDb mydb = MyDb();
    await mydb.open();

    final dataSamplesource =
        await mydb.db.rawQuery('SELECT * FROM tb_sample_source');
    List<String> _sampleSource = [];
    for (var i = 0; i < dataSamplesource.length; i++) {
      _sampleSource.add(dataSamplesource[i].toString());
    }
    // print(dataSamplesource);
    return dataSamplesource;
  }

  static Future<List<Map>> getClientSamplePoint() async {
    MyDb mydb = MyDb();
    await mydb.open();

    final dataSamplePoint =
        await mydb.db.rawQuery('SELECT * FROM tb_sampling_point');
    List<String> _sampleClient = [];

    for (var j = 0; j < dataSamplePoint.length; j++) {
      _sampleClient.add(dataSamplePoint[j].toString());
    }
    // print(dataSamplePoint);
    return dataSamplePoint;
  }

  static Future<List<Map>> getbranchcode() async {
    MyDb mydb = MyDb();
    await mydb.open();

    final databranchcode = await mydb.db.rawQuery('SELECT * FROM tb_settings');
    List<String> _brachcode = [];
    for (var t = 0; t < databranchcode.length; t++) {
      _brachcode.add(databranchcode[t].toString());
    }
    // print(databranchcode);
    return databranchcode;
  }

  static Future<List<Map>> getTestpakage() async {
    MyDb mydb = MyDb();
    await mydb.open();
    final datatestpakages =
        await mydb.db.rawQuery('SELECT * FROM tb_test_packages');
    List<Map> _testPackages = [];

    for (var i = 0; i < datatestpakages.length; i++) {
      _testPackages.add({
        'package_id': datatestpakages[i]['package_id'].toString(),
        'package_name': datatestpakages[i]['package_name'].toString(),
        'amount': datatestpakages[i]['amount'].toString(),
        'is_checked': false
      });
    }

    return _testPackages;
  }

  static Future<List<Map>> getPackageParameter(String _packageId) async {
    MyDb mydb = MyDb();
    await mydb.open();

    final datatestpakages = await mydb.db.rawQuery(
        "SELECT * FROM tb_test_packages WHERE package_id = '$_packageId'");
    var _parametersIncluded = datatestpakages[0]['test_parameters_included'];
    List<Map> _paramListIncluded = [];

    final List<dynamic> _arrParametersIncluded =
        jsonDecode(_parametersIncluded.toString());

    for (var i = 0; i < _arrParametersIncluded.length; i++) {
      String _paramId = _arrParametersIncluded[i];
      final _dataParametersIncluded = await mydb.db.rawQuery(
          "SELECT * FROM tb_parameters WHERE parameter_id = '$_paramId'");
      _paramListIncluded.add(_dataParametersIncluded[0]);
    }
    print(_paramListIncluded);
    return _paramListIncluded;
  }

  static Future<List<Map>> getBacterialogical() async {
    MyDb mydb = MyDb();
    await mydb.open();
    final dataBacteriological = await mydb.db.rawQuery(
        "SELECT * FROM tb_parameters WHERE parameter_category ='BACTERIOLOGICAL' AND is_active = 1");
    List<Map> _bacteriological = [];

    for (var i = 0; i < dataBacteriological.length; i++) {
      _bacteriological.add({
        'parameter_id': dataBacteriological[i]['parameter_id'].toString(),
        'parameter_name': dataBacteriological[i]['parameter_name'].toString(),
        'amount': dataBacteriological[i]['amount'].toString(),
        // 'package_id': dataBacteriological[i]['package_id'].toString(),
        'is_checked': false
      });
    }

    return _bacteriological;
  }

  static Future<List<Map>> getPhysicalchecmical() async {
    MyDb mydb = MyDb();
    await mydb.open();
    final dataPhysicoChemical = await mydb.db.rawQuery(
        "SELECT * FROM tb_parameters WHERE parameter_category ='PHYSICO CHEMICAL' AND is_active = 1");
    List<Map> _physicoChemical = [];

    for (var i = 0; i < dataPhysicoChemical.length; i++) {
      _physicoChemical.add({
        'parameter_id': dataPhysicoChemical[i]['parameter_id'].toString(),
        'parameter_name': dataPhysicoChemical[i]['parameter_name'].toString(),
        'amount': dataPhysicoChemical[i]['amount'].toString(),
        // 'package_id': dataPhysicoChemical[i]['package_id'].toString(),
        'is_checked': false
      });
    }
    return _physicoChemical;
  }

  static Future<String> geArnumber() async {
    MyDb mydb = MyDb();
    await mydb.open();
    String concatenate = ('-');
    var _branchCodeArnumber;
    _branchCodeArnumber =
        await mydb.db.rawQuery('SELECT branch_id FROM tb_settings');
    DateTime now = DateTime.now();
    var formattedDate = DateFormat('MMddyyyyHHmmss').format(now).toString();
    String _ArNumber =
        _branchCodeArnumber[0]['branch_id'] + concatenate + formattedDate;
    print(_ArNumber);
    return _ArNumber;
  }

  static Future<List<Map>> getRwtList() async {
    MyDb mydb = MyDb();
    await mydb.open();
    final rwtListForUpload = await mydb.db.rawQuery(
        "SELECT * FROM tb_rwt_scratch_data WHERE rwt_input_ended IS NOT NULL");
    // ignore: no_leading_underscores_for_local_identifiers
    List<Map> _rwtDataList = [];

    for (var i = 0; i < rwtListForUpload.length; i++) {
      _rwtDataList.add({
        'rwt_no': rwtListForUpload[i]['rwt_no'].toString(),
        'company_name': rwtListForUpload[i]['company_name'].toString(),
        'client_name': rwtListForUpload[i]['client_name'].toString(),
        'contact_person_name':
            rwtListForUpload[i]['contact_person_name'].toString(),
        'registered_owner_name':
            rwtListForUpload[i]['registered_owner_name'].toString(),
        'date_of_sampling': rwtListForUpload[i]['date_of_sampling'].toString(),
        'is_checked': false
      });
    }
    return _rwtDataList;
  }

  static Future<List<Map>> getrwtContinue() async {
    MyDb mydb = MyDb();
    await mydb.open();
    final selectRwtList = await mydb.db
        .rawQuery("SELECT * FROM tb_rwt_scratch_data WHERE rwt_input_started");
    // ignore: no_leading_underscores_for_local_identifiers
    List<Map> _rwtDataList = [];

    for (var i = 0; i < selectRwtList.length; i++) {
      _rwtDataList.add({
        'rwt_no': selectRwtList[i]['rwt_no'].toString(),
        'company_name': selectRwtList[i]['company_name'].toString(),
        'registered_owner_name':
            selectRwtList[i]['registered_owner_name'].toString(),
        'address': selectRwtList[i]['address'].toString(),
        'cellphone_no': selectRwtList[i]['cellphone_no'].toString(),
        'rwt_input_started': selectRwtList[i]['rwt_input_started'].toString(),
        'email_address': selectRwtList[i]['email_address'].toString(),
      });
    }
    return _rwtDataList;
  }

  static Future<Map> getRwtParametersData(String rwtNo) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> dataArray;
    String _columns = "";
    List<String> _columnsList = [];
    int error_count = 0;
    Map _rwtClientData = {};
    List<String> _parameterList = [];
    final selectparametersList = await mydb.db
        .rawQuery("SELECT * FROM tb_rwt_scratch_data WHERE rwt_no='$rwtNo'");

    // ignore: unnecessary_null_comparison
    if (selectparametersList[0]['total_amount'].toString() == null ||
        selectparametersList[0]['total_amount'].toString() == "") {
      error_count += 1;
    }

    final selectParameters = await mydb.db.rawQuery(
        "SELECT test_parameters_json FROM tb_rwt_scratch_parameters WHERE rwt_no='$rwtNo'");
    if (selectParameters.length > 0) {
      String _strParameters =
          selectParameters[0]['test_parameters_json'].toString();

      List<String> _rwtParameters = _strParameters.split(',');

      for (var k = 0; k < _rwtParameters.length; k++) {
        _parameterList.add(_rwtParameters[k]);
      }
    } else {
      error_count += 1;
    }

    // final getAllColumnNames = await mydb.db
    //     .rawQuery("PRAGMA table_info('tb_rwt_scratch_parameters')", null);
    // if (getAllColumnNames.length > 0) {
    //   for (var i = 0; i < getAllColumnNames.length; i++) {
    //     if (getAllColumnNames[i]['type'].toString() == "INT") {
    //       _columns += getAllColumnNames[i]['name'].toString();
    //       _columnsList.add(getAllColumnNames[i]['name'].toString());
    //     }
    //   }
    //   if (_columns != null && _columns.length > 0) {
    //     _columns = _columns.substring(0, _columns.length - 1);
    //   }
    //   final selectParameters = await mydb.db.rawQuery(
    //       "SELECT $_columns FROM tb_rwt_scratch_parameters WHERE rwt_no='$rwtNo'");
    //   if (selectParameters.length > 0) {
    //     for (var k = 0; k < _columnsList.length; k++) {
    //       if (selectParameters[0][_columnsList[k]].toString() == "1") {
    //         _parameterList.add(_columnsList[k]);
    //       }
    //     }
    //   } else {
    //     error_count += 1;
    //   }
    // } else {
    //   error_count += 1;
    // }

    if (error_count == 0) {
      _rwtClientData = {
        'rwt_no': selectparametersList[0]['rwt_no'].toString(),
        'special_instructions':
            selectparametersList[0]['special_instructions'].toString(),
        'total_amount': selectparametersList[0]['total_amount'].toString(),
        'package_tests': selectparametersList[0]['package_tests'].toString(),
        'amount_paid': selectparametersList[0]['amount_paid'].toString(),
        'payment_type': selectparametersList[0]['payment_type'].toString(),
        'payment_remarks':
            selectparametersList[0]['payment_remarks'].toString(),
        'parameters': _parameterList
      };
      dataArray = {
        'code': '1',
        'message': 'Test Parameters Data retrieved successful ',
        'data': _rwtClientData
      };
    } else {
      dataArray = {
        'code': '0',
        'message': 'Test Parameters Data retrieved failed',
      };
    }

    print(dataArray);
    return dataArray;
  }

  static Future<Map> getRwtSamplesdata(String rwtNo) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> dataArray;
    final selectRwtList = await mydb.db
        .rawQuery("SELECT * FROM tb_rwt_scratch_samples WHERE rwt_no='$rwtNo'");

    List<Map> _rwtSDataList = [];

    if (selectRwtList.isNotEmpty == true) {
      for (var i = 0; i < selectRwtList.length; i++) {
        _rwtSDataList.add({
          'rwt_no': selectRwtList[i]['rwt_no'].toString(),
          'water_sampling_id': selectRwtList[i]['water_sampling_id'].toString(),
          'date_of_sampling': selectRwtList[i]['date_of_sampling'].toString(),
          'time_of_sampling': selectRwtList[i]['time_of_sampling'].toString(),
          'sample_source': selectRwtList[i]['sample_source'].toString(),
          'sampling_point': selectRwtList[i]['sampling_point'].toString(),
          'sampling_location': selectRwtList[i]['sampling_location'].toString(),
          'is_completed': selectRwtList[i]['is_completed'].toString()
        });
      }

      dataArray = {
        'code': '1',
        'message': 'Sample Data retrieved successful ',
        'data': _rwtSDataList
      };
    } else {
      dataArray = {
        'code': '0',
        'message': 'Sample Data retrieved failed',
      };
    }
    return dataArray;
  }

  static Future<Map> getRwtClientData(String rwtNo) async {
    MyDb mydb = MyDb();
    await mydb.open();
    final selectRwtClientData = await mydb.db
        .rawQuery("SELECT * FROM tb_rwt_scratch_data WHERE rwt_no='$rwtNo'");

    final selectAdress = await mydb.db.rawQuery(
        "SELECT address1,address2,address3 FROM tb_water_clients WHERE client_id='${selectRwtClientData[0]['client_id'].toString()}'");

    // ignore: no_leading_underscores_for_local_identifiers3
    Map _Clientdata;
    _Clientdata = {
      'rwt_no': selectRwtClientData[0]['rwt_no'].toString(),
      'company_name': selectRwtClientData[0]['company_name'].toString(),
      'registered_owner_name':
          selectRwtClientData[0]['registered_owner_name'].toString(),
      'contact_person_name':
          selectRwtClientData[0]['contact_person_name'].toString(),
      'address': selectRwtClientData[0]['address'].toString(),
      'telephone_no': selectRwtClientData[0]['telephone_no'].toString(),
      'fax_no': selectRwtClientData[0]['fax_no'].toString(),
      'cellphone_no': selectRwtClientData[0]['cellphone_no'].toString(),
      'rwt_input_started':
          selectRwtClientData[0]['rwt_input_started'].toString(),
      'email_address': selectRwtClientData[0]['email_address'].toString(),
      'submitted_by': selectRwtClientData[0]['submitted_by'].toString(),
      'is_paid_remarks': selectRwtClientData[0]['is_paid_remarks'].toString(),
      'branch_id': selectRwtClientData[0]['branch_code'].toString(),
      'address_options': selectAdress[0]
    };
    print(_Clientdata);
    return _Clientdata;
  }

  // ignore: non_constant_identifier_names
  static Future<Map> searchCompany(String searchID, String searchType) async {
    Map<String, dynamic> dataArray;
    try {
      MyDb mydb = MyDb();
      await mydb.open();
      String columnName = '';
      if (searchType == "CLIENT ID") {
        columnName = "client_id";
      } else if (searchType == "COMPANY NAME") {
        columnName = "client_company_name";
      } else if (searchType == "CLIENT NAME") {
        columnName = "contact_person_name";
      } else {
        dataArray = {
          'code': '0',
          'message': 'Search type not Selected',
        };
      }
      final selectSearchClientData = await mydb.db.rawQuery(
          "SELECT * FROM tb_water_clients WHERE $columnName LIKE '%$searchID%'");
      // ignore: no_leading_underscores_for_local_identifiers
      List<Map> _searchClientData = [];

      if (selectSearchClientData.isNotEmpty == true) {
        for (var i = 0; i < selectSearchClientData.length; i++) {
          _searchClientData.add({
            'client_id': selectSearchClientData[i]['client_id'].toString(),
            'client_company_name':
                selectSearchClientData[i]['client_company_name'].toString(),
            'contact_person_name':
                selectSearchClientData[i]['contact_person_name'].toString(),
            'registered_owner_name':
                selectSearchClientData[i]['registered_owner_name'].toString(),
            'address1': selectSearchClientData[i]['address1'].toString(),
            'address2': selectSearchClientData[i]['address2'].toString(),
            'address3': selectSearchClientData[i]['address3'].toString(),
            'cellphone_no':
                selectSearchClientData[i]['cellphone_no'].toString(),
            'telephone_no':
                selectSearchClientData[i]['telephone_no'].toString(),
            'fax_no': selectSearchClientData[i]['fax_no'].toString(),
            'email_address':
                selectSearchClientData[i]['email_address'].toString(),
            'branch_id': selectSearchClientData[i]['branch_id'].toString(),
            'is_active': selectSearchClientData[i]['is_active'].toString(),
          });
          print(selectSearchClientData);
        }

        dataArray = {
          'code': '1',
          'message': 'Client Data retrieved successful ',
          'data': _searchClientData
        };
      } else {
        dataArray = {
          'code': '0',
          'message': 'Client Data retrieved failed',
        };
      }
      return dataArray;
    } on Exception catch (e) {
      dataArray = {
        'code': '0',
        'message': e.toString(),
      };
      return dataArray;
    }
  }

  static Future<Map> getDeleteRW(String rwtNo) async {
    Map<String, dynamic> dataArray;
    MyDb mydb = MyDb();
    await mydb.open();
    try {
      var delete1 = await mydb.db
          .rawQuery("DELETE FROM tb_rwt_scratch_data WHERE rwt_no ='$rwtNo'");
      var delete2 = await mydb.db.rawQuery(
          "DELETE FROM tb_rwt_scratch_parameters WHERE rwt_no ='$rwtNo'");
      var delete3 = await mydb.db.rawQuery(
          "DELETE FROM tb_rwt_scratch_samples WHERE rwt_no ='$rwtNo'");
      print(delete1);
      print(delete2);
      print(delete3);

      dataArray = {'code': '1', 'message': 'Client Data Delete successful'};
      return dataArray;
    } on Exception catch (e) {
      dataArray = {
        'code': '0',
        'message': e.toString(),
      };
      print(dataArray);
      return dataArray;
    }
  }
}
