import 'dart:convert';

import 'package:gms_admin/models/main_model.dart';
import 'package:http/http.dart' as http;

class DataService {
  Future<void> collectAllData(
      List<MainModel> mainModels, DateTime selectedDate) async {
    final response = await http.post(
        "https://xtoinfinity.tech/GCUdupi/admin/gms_php/getAllData.php",
        body: {"date": selectedDate.toString()});
    final jsonResponse = json.decode(response.body);
    final allData = jsonResponse['data'];
    allData.map((e) => mainModels.add(MainModel.fromJson(e))).toList();
    return;
  }
}
