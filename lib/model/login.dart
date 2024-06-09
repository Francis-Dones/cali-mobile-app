// ignore_for_file: unused_import
import 'dart:convert';
import 'dart:ffi';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cali_mobile_app/view/main_menu.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db_agua_lab.dart';

// ignore: camel_case_types
class loginUser {
  // ignore: non_constant_identifier_names

  // static Future<String> initPlatformState() async {
  //   String deviceCode;
  //   String platformVersion;
  //   String imei;
  //   String serial;
  //   String androidID;
  //   Map idMap;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     deviceCode = await AndroidMultipleIdentifier.serialCode;
  //   } on PlatformException {
  //     try {
  //       deviceCode = await DeviceInformation.deviceIMEINumber;
  //     } on PlatformException {
  //       deviceCode = 'Unknown';
  //     }
  //   }
  //   return deviceCode;
  // }

  static Future<Map> loginUserFunc(
      String user_id, String password, String user_name) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> returnArray;
    // var delete1 = await mydb.db.rawQuery('Delete from tb_rwt_scratch_data');
    // var delete2 = await mydb.db.rawQuery('Delete from tb_rwt_scratch_parameters');
    // var delete3 = await mydb.db.rawQuery('Delete from tb_rwt_scratch_samples');
    try {
      var sessionManager = SessionManager();
      var selectusers = await mydb.db
          .rawQuery("SELECT * FROM tb_users WHERE employee_id = '$user_id'");

      // ignore: prefer_is_empty
      if (selectusers.length > 0) {
        var getPassword = selectusers[0]['password'];
        if (password == getPassword) {
          Map<String, dynamic> _userDetails = {
            'user_expiration': selectusers[0]['user_expiration'].toString(),
            'employee_id': selectusers[0]['employee_id'].toString(),
            'first_name': selectusers[0]['first_name'].toString(),
            'middle_name': selectusers[0]['middle_name'].toString(),
            'last_name': selectusers[0]['last_name'].toString(),
            'gender': selectusers[0]['gender'].toString(),
            'branch_id': selectusers[0]['branch_id'].toString(),
            'user_type': selectusers[0]['user_type'].toString(),
            'prc_no': selectusers[0]['prc_no'].toString(),
            'cert_no': selectusers[0]['cert_no'].toString(),
            'user_roles': selectusers[0]['user_roles'].toString(),
            'password': selectusers[0]['password'].toString(),
            ' is_active': selectusers[0]['is_active'].toString(),
            // 'device_code': await initPlatformState(),
          };
          await sessionManager.set("loggedUser", jsonEncode(_userDetails));

          DateTime now = DateTime.now();
          // ignore: non_constant_identifier_names
          String Datenow = DateFormat('yyyy-MM-dd').format(now.toLocal());
          DateTime dtnow = DateTime.parse("$Datenow");
          DateTime dtexpirationuserID1 = DateTime.parse("2024-05-04");
          var dateexpi = selectusers[0]['user_expiration'];
          DateTime dtexpirationuserID = DateTime.parse('$dateexpi');
          if (dtnow.isBefore(dtexpirationuserID)) {
            returnArray = {
              'code': '1',
              'message': 'Login Successfull',
            };
          } else {
            returnArray = {
              'code': '0',
              'message': 'User ID Expired',
            };
          }
        } else {
          returnArray = {
            'code': '0',
            'message': 'incorrect password',
          };
        }
      } else {
        returnArray = {
          'code': '0',
          'message': 'User ID not found!',
        };
      }
      print(returnArray);
      return returnArray;
    } on Exception catch (e) {
      returnArray = {
        'code': '0',
        'message': e.toString(),
      };
      return returnArray;
    }
  }
}
