import 'dart:convert';

import 'package:cali_mobile_app/model/globalvariableAPI.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class updateUserApi {
  static Future<Map> updateUserAccountApi(
      Map<String, dynamic> _updateUserList) async {
    Map<String, dynamic> returnArray;
    String _saveURLdomainCALI = await globaldomain.insert_Domain();
    try {
      // var uri = Uri.parse(
      //     'http://ww2.voxdeisystems.com/$_saveURLdomainCALI/api/update_user_account');

      var uri = Uri.parse(
          'http://192.168.60.22/cebu_agua_lab_api_test/api/update_user_account');
      var param = _updateUserList;
      final response = await http.post(uri, body: jsonEncode(param), headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      });

      Map data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['result'] == 0) {
          returnArray = {
            'code': '0',
            'message': data['error_message'],
            'data': ''
          };
        } else {
          returnArray = {
            'code': '1',
            'message': 'Update User Account successful',
            'data': data['data']
          };
        }
      } else {
        returnArray = {
          'code': '0',
          'message': ' failed Upadte User Account',
          'data': ''
        };
      }
      return returnArray;
    } on Exception catch (e) {
      returnArray = {'code': '0', 'message': e.toString(), 'data': ''};
      return returnArray;
    }
  }
}
