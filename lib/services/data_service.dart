import 'dart:convert';

import 'package:gms_admin/data/custom_constants.dart';
import 'package:gms_admin/models/truck_location_model.dart';
import 'package:gms_admin/models/main_model.dart';
import 'package:http/http.dart' as http;

class DataService {
  Future<void> collectAllData(
      List<MainModel> mainModels, DateTime selectedDate) async {
    try {
      final response = await http.post(
          "${CustomConstants.url}gms_php/getAllData.php",
          body: {"date": selectedDate.toString()});
      final jsonResponse = json.decode(response.body);
      final allData = jsonResponse['data'];
      allData.map((e) => mainModels.add(MainModel.fromJson(e))).toList();
    } catch (e) {}
    return;
  }

  Future<void> getLocationData(
      List<TruckLocation> locations, DateTime selectedDate) async {
    try {
      final response = await http
          .post("${CustomConstants.url}gms_php/getTruckLocation.php", body: {
        "date": selectedDate.toString(),
      });
      final jsonResponse = json.decode(response.body);
      final allData = jsonResponse['data'];
      allData.map((e) => locations.add(TruckLocation.fromJson(e))).toList();
    } catch (e) {
      print(e.toString());
    }
    return;
  }
}
