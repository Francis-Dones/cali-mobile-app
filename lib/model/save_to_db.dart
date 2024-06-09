// ignore_for_file: unused_import
import 'dart:convert';

import 'package:cali_mobile_app/model/db_agua_lab.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

// ignore: camel_case_types
class saveToDatabase {
  static Future<Map> saveDataToDatabase(dynamic data) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> returnArray;
    try {
      var dataUsers = data['data_users'];
      var dataBranch = data['data_branch'];
      var dateNow = data['date_now'];
      int error_count = 0;

      var slist1 = await mydb.db.rawQuery('Delete from tb_settings');

      var slist = await mydb.db.rawQuery('Delete from tb_users');

      for (var i = 0; i < dataUsers.length; i++) {
        var insertUser = await mydb.db.rawInsert(
            "INSERT INTO tb_users(employee_id, password, first_name, middle_name, last_name, gender, is_active, description, branch_id, user_type, user_name, user_roles, user_expiration, employee_position, prc_no, cert_no) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
            [
              dataUsers[i]['employee_id'],
              dataUsers[i]['password'],
              dataUsers[i]['first_name'],
              dataUsers[i]['middle_name'],
              dataUsers[i]['last_name'],
              dataUsers[i]['gender'],
              dataUsers[i]['is_active'],
              dataUsers[i]['description'],
              dataUsers[i]['branch_id'],
              dataUsers[i]['user_type'],
              dataUsers[i]['user_name'],
              dataUsers[i]['user_roles'],
              dataUsers[i]['user_expiration'],
              dataUsers[i]['employee_position'],
              dataUsers[i]['prc_no, cert_no']
            ]);

        if (insertUser == -1) {
          error_count += 1;
        }
      }

      for (var j = 0; j < dataBranch.length; j++) {
        var insertUser1 = await mydb.db.rawInsert(
            "INSERT INTO tb_settings(branch_id, branch_name, address, telephone_no, fax_no, cellphone_no, email_address, tin_no, description, logo_small, logo_big, doh_accreditation_no, doh_validity, amount, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
            [
              dataBranch[j]['branch_id'],
              dataBranch[j]['branch_name'],
              dataBranch[j]['address'],
              dataBranch[j]['telephone_no'],
              dataBranch[j]['fax_no'],
              dataBranch[j]['cellphone_no'],
              dataBranch[j]['email_address'],
              dataBranch[j]['tin_no'],
              dataBranch[j]['description'],
              dataBranch[j]['logo_small'],
              dataBranch[j]['logo_big'],
              dataBranch[j]['doh_accreditation_no'],
              dataBranch[j]['doh_validity'],
              dataBranch[j]['amount'],
              dataBranch[j]['is_active']
            ]);

        if (insertUser1 == -1) {
          error_count += 1;
        }
      }

      if (error_count == 0) {
        returnArray = {
          'code': '1',
          'message': 'sync data success',
        };
      } else {
        returnArray = {
          'code': '0',
          'message': 'sync data unsuccessful',
        };
      }
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
