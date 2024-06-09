import 'dart:convert';

import 'package:http/http.dart' as http;

// ignore: camel_case_types
class versionApplication {
  static Future<Map> getVersion(int _version) async {
    Map<String, dynamic> returnArray;

    try {
      var uri = Uri.parse(
          'https://ww2.voxdeisystems.com/caliwater_version/api/checkVersionCali');
      var param = {"appVersion": _version};

      final response = await http.post(uri, body: jsonEncode(param), headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      });

      Map data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        returnArray = {
          'code': '1',
          'message': 'Application version is up to date',
          'data': data
        };
      } else {
        returnArray = {
          'code': '0',
          'message': 'Application version is not updated',
          'data': data
        };
      }
      return data;
    } on Exception catch (e) {
      returnArray = {'code': '0', 'message': e.toString(), 'data': ''};
      return returnArray;
    }
  }
}
