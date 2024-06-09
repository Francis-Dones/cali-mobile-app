// ignore_for_file: unused_import
import 'dart:convert';

import 'package:cali_mobile_app/model/db_agua_lab.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

// ignore: camel_case_types
class saveToDatabase2 {
  static Future<Map> saveDataToDatabase(dynamic data) async {
    MyDb mydb = MyDb();
    await mydb.open();
    Map<String, dynamic> returnArray;
    try {
      var parameters = data['parameters'];
      var sampleSource = data['sample_source'];
      var samplingPoint = data['sampling_point'];
      var testPackages = data['test_packages'];
      var clientData = data['client_data'];

      var dateNow = data['date_now'];
      int error_count = 0;

      var delete_parameters =
          await mydb.db.rawQuery('Delete from tb_parameters');
      var delete_sample_source =
          await mydb.db.rawQuery('Delete from tb_sample_source');
      var delete_tb_sampling_point =
          await mydb.db.rawQuery('Delete from tb_sampling_point');
      var delete_test_packages =
          await mydb.db.rawQuery('Delete from tb_test_packages');
      var delete_water_clients =
          await mydb.db.rawQuery('Delete from tb_water_clients');

      for (var m = 0; m < sampleSource.length; m++) {
        var insertQueryg = await mydb.db.rawInsert(
            "INSERT INTO tb_sample_source(recno, sample_source, is_active, branch_id) VALUES (?, ?, ?, ?);",
            [
              sampleSource[m]['recno'],
              sampleSource[m]['sample_source'],
              sampleSource[m]['is_active'],
              sampleSource[m]['branch_id']
            ]);

        if (insertQueryg == -1) {
          error_count += 1;
        }
      }

      for (var e = 0; e < clientData.length; e++) {
        var insertdata = await mydb.db.rawInsert(
            "INSERT INTO tb_water_clients(recno, client_id, client_company_name, contact_person_name, registered_owner_name, address1, address2, address3, telephone_no, cellphone_no, fax_no, email_address, is_active, branch_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
            [
              clientData[e]['recno'],
              clientData[e]['client_id'],
              clientData[e]['client_company_name'],
              clientData[e]['contact_person_name'],
              clientData[e]['registered_owner_name'],
              clientData[e]['address1'],
              clientData[e]['address2'],
              clientData[e]['address3'],
              clientData[e]['telephone_no'],
              clientData[e]['cellphone_no'],
              clientData[e]['fax_no'],
              clientData[e]['email_address'],
              clientData[e]['is_active'],
              clientData[e]['branch_id']
            ]);

        if (insertdata == -1) {
          error_count += 1;
        }
      }

      for (var h = 0; h < samplingPoint.length; h++) {
        var insertQuery1 = await mydb.db.rawInsert(
            "INSERT INTO tb_sampling_point(recno, sampling_point, is_active, branch_id) VALUES (?, ?, ?, ?);",
            [
              samplingPoint[h]['recno'],
              samplingPoint[h]['sampling_point'],
              samplingPoint[h]['is_active'],
              samplingPoint[h]['branch_id']
            ]);

        if (insertQuery1 == -1) {
          error_count += 1;
        }
      }

      for (var f = 0; f < testPackages.length; f++) {
        var insertQuery2 = await mydb.db.rawInsert(
            "INSERT INTO tb_test_packages(recno, package_id, package_name, test_parameters_included, amount, branch_id, is_active) VALUES (?, ?, ?, ?, ?, ?, ?);",
            [
              testPackages[f]['recno'],
              testPackages[f]['package_id'],
              testPackages[f]['package_name'],
              testPackages[f]['test_parameters_included'],
              testPackages[f]['amount'],
              testPackages[f]['is_active'],
              testPackages[f]['branch_id']
            ]);

        if (insertQuery2 == -1) {
          error_count += 1;
        }
      }

      for (var j = 0; j < parameters.length; j++) {
        var insertQuery3 = await mydb.db.rawInsert(
            "INSERT INTO tb_parameters(recno, parameter_id, parameter_name, parameter_category, parameter_group, parameter_type_water, parameter_mal, parameter_unit, parameter_method_of_analysis, amount, is_active, branch_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
            [
              parameters[j]['recno'],
              parameters[j]['parameter_id'],
              parameters[j]['parameter_name'],
              parameters[j]['parameter_category'],
              parameters[j]['parameter_group'],
              parameters[j]['parameter_type_water'],
              parameters[j]['parameter_mal'],
              parameters[j]['parameter_unit'],
              parameters[j]['parameter_method_of_analysis'],
              parameters[j]['amount'],
              parameters[j]['is_active'],
              parameters[j]['branch_id']
            ]);

        if (insertQuery3 == -1) {
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
