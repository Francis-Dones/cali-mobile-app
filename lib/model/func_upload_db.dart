// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:convert';

import 'package:cali_mobile_app/model/db_agua_lab.dart';
import 'package:cali_mobile_app/model/func_upload_api.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class uploadRWtClass {
  static dynamic jsonDecode(String source,
          {Object? reviver(Object? key, Object? value)?}) =>
      json.decode(source, reviver: reviver);

  static Future<Map> uploadApiRwtFunc(
      String dataRwtNo, String userId, String mobileTtransDate) async {
    Map<String, dynamic> returnArray;
    try {
      MyDb mydb = MyDb();
      await mydb.open();
      int error_count = 0;

      final _loggedUser = await SessionManager().get("loggedUser");
      Map<String, dynamic> _userDetails = _loggedUser;

      String _userId = _userDetails["employee_id"];

      final selectrwt = await mydb.db.rawQuery(
          "SELECT * FROM tb_rwt_scratch_data WHERE rwt_no = '$dataRwtNo'");
      Map<String, dynamic> _rwtDataList;
      Map<String, dynamic> _sample_details;
      Map<String, dynamic> _test_parameters;
      Map<String, dynamic> _uploadData;

      List<Map> _rwtDataSamples = [];
      List<String> _rwtParameters = [];
      String _columns = "";
      List<String> _columnsList = [];
      String _whereString = "";

      if (selectrwt.isNotEmpty) {
        final selectrwtsamples = await mydb.db.rawQuery(
            "SELECT * FROM tb_rwt_scratch_samples WHERE rwt_no = '$dataRwtNo'");

        if (selectrwtsamples.isNotEmpty) {
          for (var i = 0; i < selectrwtsamples.length; i++) {
            _rwtDataSamples.add({
              'sample_source': selectrwtsamples[i]['sample_source'].toString(),
              'sampling_point':
                  selectrwtsamples[i]['sampling_point'].toString(),
              'sampling_location':
                  selectrwtsamples[i]['sampling_location'].toString(),
              'time_of_sampling':
                  selectrwtsamples[i]['time_of_sampling'].toString(),
            });
          }

          final selectParameters = await mydb.db.rawQuery(
              "SELECT * FROM tb_rwt_scratch_parameters WHERE rwt_no = '$dataRwtNo'");

          // final selectParameters = await mydb.db.rawQuery("SELECT " +
          //     _columns +
          //     " FROM tb_rwt_scratch_parameters WHERE rwt_no = '$dataRwtNo'");

          if (selectParameters.isNotEmpty) {
            // for (var k = 0; k < _columnsList.length; k++) {
            //   if (selectParameters[0][_columnsList[k]].toString() == "1") {
            //     _rwtParameters.add(_columnsList[k]);
            //   }
            // }

            String _strParameters =
                selectParameters[0]['test_parameters_json'].toString();

            _rwtParameters = _strParameters.split(',');
          } else {
            error_count += 1;
          }
        } else {
          error_count += 1;
        }
      } else {
        error_count += 1;
      }

      _rwtDataList = {
        // 'user_id': userId,
        // 'branch_code': selectrwt[0]['branch_id'].toString(),
        // 'mobile_trans_date': mobileTtransDate,
        // 'device_code': await initPlatformState(),

        'client_id': selectrwt[0]['client_id'].toString(),
        'client_company_name': selectrwt[0]['company_name'].toString(),
        'registered_owner_name':
            selectrwt[0]['registered_owner_name'].toString(),
        'contact_person_name': selectrwt[0]['contact_person_name'].toString(),
        'telephone_no': selectrwt[0]['telephone_no'].toString(),
        'cellphone_no': selectrwt[0]['cellphone_no'].toString(),
        'fax_no': selectrwt[0]['fax_no'].toString(),
        'email_address': selectrwt[0]['email_address'].toString(),
        'address': selectrwt[0]['address'].toString(),

        // 'date_of_sampling': selectrwt[0]['date_of_sampling'].toString(),
        // 'rwt_input_started': selectrwt[0]['rwt_input_started'].toString(),
        // 'rwt_input_ended': selectrwt[0]['rwt_input_ended'].toString(),
        // 'package_tests': selectrwt[0]['package_tests'].toString(),
        // 'special_instructions': selectrwt[0]['special_instructions'].toString(),
        // 'sampler_received_by': selectrwt[0]['sampler_received_by'].toString(),
        // 'e_signature_client': '',
        // 'submitted_by': selectrwt[0]['submitted_by'].toString(),
        // 'acknowledgement_receipt_no': selectrwt[0]['rwt_no'].toString(),
        // 'total_amount': selectrwt[0]['total_amount'].toString(),
        // 'is_paid': selectrwt[0]['is_paid'].toString(),
        // 'is_paid_remarks': selectrwt[0]['is_paid_remarks'].toString(),
        // 'samples': _rwtDataSamples,
        // 'parameters': _rwtParameters
      };

      _sample_details = {
        'date_of_sampling': selectrwt[0]['date_of_sampling'].toString(),
        'sampler_id': selectrwt[0]['sampler_received_by'].toString(),
        'sample': _rwtDataSamples,
      };

      _test_parameters = {
        "package_test": selectrwt[0]['package_tests'].toString(),
        "special_instructions": selectrwt[0]['special_instructions'].toString(),
        "type_of_test": selectrwt[0]['type_of_test'].toString(),
        "total_amount": selectrwt[0]['total_amount'].toString(),
        "payment_type": selectrwt[0]['payment_type'].toString(),
        "amount_paid": selectrwt[0]['amount_paid'].toString(),
        "payment_remarks": selectrwt[0]['payment_remarks'].toString(),
        "test_parameters": _rwtParameters
      };

      _uploadData = {
        "employee_id": _userId,
        "client_info": _rwtDataList,
        "sample_details": _sample_details,
        "test_parameters": _test_parameters,
        'mobile_trans_date_time': mobileTtransDate,
        "input_started": selectrwt[0]['rwt_input_started'].toString(),
        "input_ended": selectrwt[0]['rwt_input_ended'].toString(),
        "branch_id": selectrwt[0]['branch_code'].toString(),
        "acknowledgement_receipt": selectrwt[0]['rwt_no'].toString(),
        'device_id': "",
        // 'device_id': "V21023",
      };

      print(_uploadData);

      if (error_count == 0) {
        var _uploadRwtApi =
            await uploadApiRwtClass.uploadRwtDataApi(_uploadData);

        if (_uploadRwtApi['code'] == "1") {
          returnArray = {
            'code': '1',
            'message': _uploadRwtApi['message'],
            'rwt_no': _uploadRwtApi['data']
          };

          var delete1 = await mydb.db.rawQuery(
              "DELETE FROM tb_rwt_scratch_parameters WHERE rwt_no = '$dataRwtNo'");
          var delete2 = await mydb.db.rawQuery(
              "DELETE FROM tb_rwt_scratch_samples WHERE rwt_no = '$dataRwtNo'");
          var delete3 = await mydb.db.rawQuery(
              "DELETE FROM tb_rwt_scratch_data WHERE rwt_no = '$dataRwtNo'");
        } else {
          returnArray = {
            'code': '0',
            'message': _uploadRwtApi['message'],
            'rwt_no': _uploadRwtApi['data']
          };
        }
      } else {
        returnArray = {
          'code': '0',
          'message': "Error on getting rwt data",
          'rwt_no': dataRwtNo
        };
      }
    } on Exception catch (e) {
      returnArray = {'code': '0', 'message': e.toString(), 'rwt_no': dataRwtNo};
    }
    return returnArray;
  }
}
