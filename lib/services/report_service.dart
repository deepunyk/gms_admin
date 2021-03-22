import 'dart:convert';

import 'package:gms_admin/data/custom_constants.dart';
import 'package:gms_admin/models/report_model.dart';
import 'package:http/http.dart' as http;

class ReportService {
  Future<List<Report>> getAllReports() async {
    List<Report> reports = [];
    try {
      final response =
          await http.get("${CustomConstants.url}gms_php/getReports.php");
      final jsonResponse = json.decode(response.body);
      final allData = jsonResponse['data'];
      allData.map((e) => reports.add(Report.fromJson(e))).toList();
    } catch (e) {}
    reports = reports.reversed.toList();
    return reports;
  }
}
