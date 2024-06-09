import 'dart:convert';

// ignore: unused_import
import 'package:cali_mobile_app/model/func_upload_api.dart';
import 'package:cali_mobile_app/model/globalvariableAPI.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class uploadApiRwtClass {
  static Future<Map> uploadRwtDataApi(Map<String, dynamic> _rwtDataList) async {
    Map<String, dynamic> returnArray;
    String _saveURLdomainCALI = await globaldomain.insert_Domain();
    String _saveURLdomain = await globaldomain.uploadApi_globalFunction();
    print(_rwtDataList);
    try {
      // var uri = Uri.parse(
      //     'http://ww2.voxdeisystems.com/$_saveURLdomainCALI/api/upload_rwt');

      var uri = Uri.parse(
          'http://192.168.60.22/cebu_agua_lab_api_test/api/upload_rwt');

      var param = _rwtDataList;
      final response = await http.post(uri, body: jsonEncode(param), headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      });

      Map data = jsonDecode(response.body);
      print(data);

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
          'message': 'Upload RWT failed',
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
