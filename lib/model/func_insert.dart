// ignore_for_file: unused_import
import 'dart:convert';

import 'package:cali_mobile_app/model/func_updateUser_api.dart';
import 'package:cali_mobile_app/view/new_rwt.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'db_agua_lab.dart';

// ignore: camel_case_types

class saveRwt {
  static Future<Map> createRwt(Map arrayClientData) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> dataArray;

    var deleteOldData = await mydb.db.rawQuery(
        "DELETE FROM tb_rwt_scratch_data WHERE rwt_no ='" +
            arrayClientData['ar_number'] +
            "'");
    try {
      int errorCount = 0;
      var inserClient = await mydb.db.rawInsert(
          "INSERT INTO tb_rwt_scratch_data (rwt_no, client_id, company_name, registered_owner_name, contact_person_name, address, fax_no, telephone_no, cellphone_no, email_address, rwt_input_started) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
          [
            arrayClientData['ar_number'],
            arrayClientData['client_id'],
            arrayClientData['company_name'],
            arrayClientData['registered_owner_name'],
            arrayClientData['contact_person'],
            arrayClientData['address'],
            arrayClientData['fax_number'],
            arrayClientData['telephone_number'],
            arrayClientData['cellphone_number'],
            arrayClientData['email_address'],
            arrayClientData['input_started'],
          ]);
      if (inserClient == -1) {
        errorCount += 1;
      }

      var _branchCodeArnumber1;
      _branchCodeArnumber1 =
          await mydb.db.rawQuery('SELECT * FROM tb_rwt_scratch_data');
      print(_branchCodeArnumber1);

      if (errorCount == 0) {
        dataArray = {
          'code': '1',
          'message': 'Client data save successful',
        };
      } else {
        dataArray = {
          'code': '0',
          'message': 'Client data save unsuccessful',
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

  static Future<Map> updateRwtClientData(Map arrayClientData) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> dataArray;

    // var deleteOldData =
    //     await mydb.db.rawQuery("DELETE FROM tb_rwt_scratch_data WHERE rwt_no ='" + arrayClientData['ar_number'] + "'");

    try {
      int errorCount = 0;
      var updateRwtclientdata = await mydb.db.rawUpdate(
          "UPDATE tb_rwt_scratch_data SET " +
              "company_name = '" +
              arrayClientData['company_name'] +
              "', registered_owner_name = '" +
              arrayClientData['registered_owner_name'] +
              "', contact_person_name = '" +
              arrayClientData['contact_person_name'] +
              "', address = '" +
              arrayClientData['address'] +
              "', fax_no = '" +
              arrayClientData['fax_number'] +
              "', telephone_no = '" +
              arrayClientData['telephone_number'] +
              "', cellphone_no = '" +
              arrayClientData['cellphone_number'] +
              "', email_address = '" +
              arrayClientData['email_address'] +
              "' WHERE rwt_no ='" +
              arrayClientData['rwt_no'] +
              "'");

      if (updateRwtclientdata == -1) {
        errorCount += 1;
      }
      if (updateRwtclientdata == -1) {
        errorCount += 1;
      }

      var _branchCodeArnumber1;
      _branchCodeArnumber1 =
          await mydb.db.rawQuery('SELECT * FROM tb_rwt_scratch_data');
      print(_branchCodeArnumber1);

      if (errorCount == 0) {
        dataArray = {
          'code': '1',
          'message': 'Client data save successful',
        };
      } else {
        dataArray = {
          'code': '0',
          'message': 'Client data save unsuccessful',
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

  static Future<Map> saveSampleData(
      List<Map> arraySampleData, String arNumber, String dateOfSampling) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> dataArray;

    // var slist = await mydb.db.rawQuery('Delete from tb_rwt_scratch_samples');
    try {
      int errorCount = 0;
      var deleteOldData = await mydb.db.rawQuery(
          "DELETE FROM tb_rwt_scratch_samples WHERE rwt_no ='" +
              arNumber +
              "'");
      for (var i = 0; i < arraySampleData.length; i++) {
        var _sampleSource;
        var _samplingPoint;
        if (arraySampleData[i]['otherSampleSourceIsActive'] == false) {
          _sampleSource = arraySampleData[i]['sampleSource'];
        } else {
          _sampleSource = arraySampleData[i]['otherSampleSource'];
        }

        if (arraySampleData[i]['otherSamplingPointIsActive'] == false) {
          _samplingPoint = arraySampleData[i]['samplingPoint'];
        } else {
          _samplingPoint = arraySampleData[i]['otherSamplingPoint'];
        }

        var insertSample = await mydb.db.rawInsert(
            "INSERT INTO tb_rwt_scratch_samples (rwt_no, water_sampling_id, date_of_sampling, time_of_sampling, sample_source, sampling_point, sampling_location, is_completed) VALUES (?, ?, ?, ?, ?, ?, ?, ?);",
            [
              arNumber,
              arraySampleData[i]['samplingID'],
              dateOfSampling,
              arraySampleData[i]['timeOfSampling'],
              _sampleSource,
              _samplingPoint,
              arraySampleData[i]['samplingLocation'],
              0,
            ]);
        if (insertSample == -1) {
          errorCount += 1;
        }
      }

      var updateRwt = await mydb.db.rawUpdate(
          "UPDATE tb_rwt_scratch_data SET date_of_sampling = '$dateOfSampling' WHERE rwt_no ='" +
              arNumber +
              "' ");

      if (updateRwt == -1) {
        errorCount += 1;
      }

      var _branchCodeArnumber1;
      _branchCodeArnumber1 =
          await mydb.db.rawQuery('SELECT * FROM tb_rwt_scratch_samples');
      print(_branchCodeArnumber1);

      if (errorCount == 0) {
        dataArray = {
          'code': '1',
          'message': 'Sample Data save successful',
          'data': _branchCodeArnumber1
        };
      } else {
        dataArray = {
          'code': '0',
          'message': 'Sample Data save unsuccessful',
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

  static Future<Map> saveTypeofTest(List<Map> arraySampleData,
      List<String> parameters, Map<dynamic, dynamic> typeOftestData) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> dataArray;
    try {
      int errorCount = 0;
      // String _columns = parameters.join(",");
      // List<String> _questionMark = [];
      // List<int> _num1 = [];
      double _totalAmount = double.parse(typeOftestData['total_amount']);
      var _arrayParameters = parameters.join(',');

      // for (var j = 0; j < parameters.length; j++) {
      //   _questionMark.add("?");
      //   _num1.add(1);
      // }
      // String _questionMarkCount = _questionMark.join(",");
      // String _num1Count = _num1.join(",");

      var deleteOldData = await mydb.db.rawQuery(
          "DELETE FROM tb_rwt_scratch_parameters WHERE rwt_no ='" +
              typeOftestData['rwt_no'] +
              "'");

      for (var i = 0; i < arraySampleData.length; i++) {
        var insertSample = await mydb.db.rawInsert(
            "INSERT INTO tb_rwt_scratch_parameters(rwt_no, water_sampling_id, test_parameters_json) VALUES (?, ?, ?);",
            [
              typeOftestData['rwt_no'],
              arraySampleData[i]['samplingID'],
              _arrayParameters
            ]);
        if (insertSample == -1) {
          errorCount += 1;
        }
      }

      var _typeoftestSelection = await mydb.db.rawQuery(
          "SELECT parameter_category FROM tb_parameters where parameter_id ='${parameters[0]}'");

      // ignore: prefer_interpolation_to_compose_strings
      var updateRwt = await mydb.db.rawUpdate(
          "UPDATE tb_rwt_scratch_data SET special_instructions = '${typeOftestData['special_instruction']}', total_amount = $_totalAmount, package_tests = '${typeOftestData['test_package']}', branch_code = '${typeOftestData['branch_id']}', type_of_test = '${_typeoftestSelection[0]['parameter_category'].toString()}', amount_paid = '${typeOftestData['amount_paid']}', payment_type = '${typeOftestData['payment_type']}', payment_remarks = '${typeOftestData['payment_remarks']}' WHERE rwt_no ='${typeOftestData['rwt_no']}'");

      if (updateRwt == -1) {
        errorCount += 1;
      }

      var selecttypeOftestdata;
      selecttypeOftestdata = await mydb.db.rawQuery(
          "SELECT * FROM tb_rwt_scratch_parameters WHERE rwt_no ='${typeOftestData['rwt_no']}'");
      print(selecttypeOftestdata);

      if (errorCount == 0) {
        dataArray = {
          'code': '1',
          'message': 'Sample Data save successful',
        };
      } else {
        dataArray = {
          'code': '0',
          'message': 'Sample Data save unsuccessful',
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

  static Future<Map> saveAcknowledgementData(
      Map<dynamic, dynamic> acknowledgementData) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> dataArray;

    try {
      int errorCount = 0;
      int isPaid = 1;

      // ignore: prefer_interpolation_to_compose_strings
      var updateAcknowledgementData = await mydb.db.rawUpdate(
          "UPDATE tb_rwt_scratch_data SET " "submitted_by = '" +
              acknowledgementData['submitedby'] +
              "', " +
              "payment_remarks = '" +
              acknowledgementData['payment_remarks'] +
              "', " +
              "sampler_received_by = '" +
              acknowledgementData['reciveBy'] +
              "', " +
              "rwt_input_ended = '" +
              acknowledgementData['dateInputEnd'] +
              "', " +
              "is_paid = 1" +
              " WHERE rwt_no = '" +
              acknowledgementData['rwtNO'] +
              "' ");

      if (updateAcknowledgementData == -1) {
        errorCount += 1;
      }

      var selecttypeOftestdata;
      selecttypeOftestdata =
          await mydb.db.rawQuery('SELECT * FROM tb_rwt_scratch_data');
      print(selecttypeOftestdata);

      if (errorCount == 0) {
        dataArray = {
          'code': '1',
          'message': 'Sample Data save successful',
        };
      } else {
        dataArray = {
          'code': '0',
          'message': 'Sample Data save unsuccessful',
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

  static Future<Map> updateUserAccount(
      Map<String, dynamic> UserAccountUpdate) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> dataArray;

    // var deleteOldData =
    //     await mydb.db.rawQuery("DELETE FROM tb_rwt_scratch_data WHERE rwt_no ='" + arrayClientData['ar_number'] + "'");
    try {
      int errorCount = 0;
      Map<String, dynamic> _updateUsersList;

      _updateUsersList = {
        'employee_id': UserAccountUpdate['employee_id'].toString(),
        'new_password': UserAccountUpdate['new_password'].toString(),
        'old_password': UserAccountUpdate['old_password'].toString(),
        'device_id': UserAccountUpdate['device_id'].toString(),
        'branch_id': UserAccountUpdate['branch_id'],
      };

      var _apiReturn;
      var _update_user_Api =
          await updateUserApi.updateUserAccountApi(_updateUsersList);

      if (_update_user_Api['code'] == "1") {
        _apiReturn = _update_user_Api['data'];
        var updateRwtclientdata = await mydb.db.rawUpdate(
            // ignore: prefer_interpolation_to_compose_strings
            "UPDATE tb_users SET password = '" +
                UserAccountUpdate['new_password'] +
                "' WHERE employee_id ='" +
                UserAccountUpdate['employee_id'] +
                "'");

        if (updateRwtclientdata == -1) {
          errorCount += 1;
        }

        if (errorCount == 0) {
          _updateUsersList = {
            'code': '1',
            'data': _update_user_Api['data'],
            'message': 'Client save Password successful',
          };
        } else {
          _updateUsersList = {
            'code': '0',
            'message': 'Client save Password unsuccessful',
          };
        }
        var _selectAccountUsers;
        _selectAccountUsers = await mydb.db.rawQuery("SELECT * FROM tb_users");
        print(_selectAccountUsers);
      } else {
        _updateUsersList = {
          'code': '0',
          'message': 'Client save Password unsuccessful',
        };
      }

      return _updateUsersList;
    } on Exception catch (e) {
      dataArray = {
        'code': '0',
        'message': e.toString(),
      };
      return dataArray;
    }
  }
}
