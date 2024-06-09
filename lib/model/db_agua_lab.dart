// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';

class MyDb {
  late Database db;

  Future open() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db_agua_lab.db');
    //join is from path package
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table

      await db.execute("CREATE TABLE IF NOT EXISTS tb_users (" +
          "employee_id VARCHAR (100)," +
          "password VARCHAR (100)," +
          "first_name VARCHAR (100)," +
          "middle_name VARCHAR (100)," +
          "last_name VARCHAR (100)," +
          "gender VARCHAR (100)," +
          "is_active INT," +
          "description TEXT," +
          "branch_id VARCHAR (100)," +
          "user_type TEXT," +
          "user_name TEXT," +
          "user_roles TEXT," +
          "user_expiration TEXT," +
          "employee_position TEXT," +
          "prc_no TEXT," +
          "cert_no TEXT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_settings(" +
          "branch_id TEXT PRIMARY KEY," +
          "branch_name TEXT," +
          "address TEXT," +
          "telephone_no TEXT," +
          "fax_no TEXT," +
          "cellphone_no TEXT," +
          "email_address TEXT," +
          "tin_no TEXT," +
          "description TEXT," +
          "logo_small TEXT," +
          "logo_big TEXT," +
          "doh_accreditation_no TEXT," +
          "doh_validity TEXT," +
          "amount INT," +
          "is_active INT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_rwt_scratch_data(" +
          "mobile_trans_date TEXT," +
          "server_trans_date TEXT," +
          "branch_code TEXT," +
          "device_code TEXT," +
          "rwt_no TEXT PRIMARY KEY," +
          "contact_person_name TEXT," +
          "company_name TEXT," +
          "registered_owner_name TEXT," +
          "address TEXT," +
          "telephone_no TEXT," +
          "cellphone_no TEXT," +
          "client_id TEXT," +
          "fax_no TEXT," +
          "type_of_test TEXT," +
          "email_address TEXT," +
          "date_of_sampling TEXT," +
          "package_tests TEXT," +
          "special_instructions TEXT," +
          "total_amount REAL," +
          "amount_paid REAL," +
          "payment_type TEXT," +
          "payment_remarks TEXT," +
          "submitted_by TEXT," +
          "sampler_received_by TEXT," +
          "is_paid_remarks TEXT," +
          "is_paid INT," +
          "rwt_input_started TEXT," +
          "rwt_input_ended TEXT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_rwt_scratch_samples(" +
          "rwt_no TEXT," +
          "water_sampling_id TEXT PRIMARY KEY," +
          "date_of_sampling TEXT," +
          "time_of_sampling TEXT," +
          "sample_source TEXT," +
          "sampling_point TEXT," +
          "sampling_location TEXT," +
          "is_completed INT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_rwt_scratch_parameters(" +
          "rwt_no TEXT," +
          "water_sampling_id TEXT PRIMARY KEY," +
          "test_parameters_json TEXT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_water_clients(" +
          "recno TEXT PRIMARY KEY," +
          "client_id TEXT," +
          "client_company_name TEXT," +
          "contact_person_name TEXT," +
          "registered_owner_name TEXT," +
          "address1 TEXT," +
          "address2 TEXT," +
          "address3 TEXT," +
          "telephone_no  TEXT," +
          "cellphone_no  TEXT," +
          "fax_no  TEXT," +
          "email_address TEXT," +
          "branch_id TEXT," +
          "is_active INT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_sample_source(" +
          "recno TEXT PRIMARY KEY," +
          "sample_source TEXT KEY," +
          "branch_id TEXT," +
          "is_active INT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_sampling_point(" +
          "recno TEXT PRIMARY KEY," +
          "sampling_point TEXT KEY," +
          "branch_id TEXT," +
          "is_active INT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_test_packages(" +
          "recno TEXT PRIMARY KEY," +
          "package_id TEXT," +
          "package_name TEXT," +
          "test_parameters_included TEXT," +
          "amount INT," +
          "is_active INT," +
          "branch_id TEXT" +
          ")");

      await db.execute("CREATE TABLE IF NOT EXISTS tb_parameters(" +
          "recno TEXT PRIMARY KEY," +
          "parameter_id TEXT," +
          "parameter_name TEXT," +
          "parameter_category TEXT," +
          "parameter_group TEXT," +
          "parameter_type_water TEXT," +
          "parameter_mal TEXT," +
          "parameter_unit TEXT," +
          "parameter_method_of_analysis TEXT," +
          "amount INT," +
          "is_active INT," +
          "branch_id TEXT" +
          ")");
    });
  }
}
