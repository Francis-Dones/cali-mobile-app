import 'dart:convert';

import 'package:cali_mobile_app/model/globalvariableAPI.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class syncDataApi2 {
  static Future<Map> getsyncData2() async {
    Map<String, dynamic> returnArray;
    String saveURLdomainCALI = await globaldomain.sync2_globalFunction();
    try {
      // var uri = Uri.parse(
      //     'http://ww2.voxdeisystems.com/$_saveURLdomainCALI/api/sync_data_2');

      var uri =
          Uri.parse('https://192.168.60.22/cebu_agua_lab_api/api/sync_data_2');

      var param = {'branch_code': 'CALI001', 'employee_id': '001'};

      final response = await http.post(uri, body: jsonEncode(param), headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      });

      Map data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['code'] == 1) {
          returnArray = {
            'code': '1',
            'message': data['success_message'],
            'data': data['data']
          };
        } else {
          returnArray = {
            'code': '0',
            'message': data['error_message'],
            'data': data['data']
          };
        }
      } else {
        returnArray = {
          'code': '0',
          'message': 'Sync data 2failed',
          'data': response.statusCode.toString()
        };
      }
      return returnArray;
    } on Exception catch (e) {
      returnArray = {'code': '0', 'message': e.toString(), 'data': ''};
      return returnArray;
    }
  }
}
