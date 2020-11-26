import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_admin/models/truck_location_model.dart';
import 'package:gms_admin/services/data_service.dart';
import 'package:gms_admin/utils/statistics_util.dart';
import 'package:gms_admin/widgets/custom_error_widget.dart';
import 'package:gms_admin/widgets/custom_loading.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<TruckLocation> locations = [];
  bool isLoad = true;
  bool isSetting = false;
  List<bool> selections = [true, false];
  StatisticsUtil statisticsUtil = StatisticsUtil();

  DateTime selectedDate = DateTime.now();
  double totalDistance = 0.0;
  Duration totalTime;
  int totalStops = 0;
  int totalDumps = 0;
  Duration totalDumpingTime = Duration(minutes: 0);
  Duration totalCollectionTime = Duration(minutes: 0);

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 10),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      isLoad = true;
      setState(() {});
      getData();
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future addStops() async {
    totalStops = await statisticsUtil.addStops(locations: locations);
    return;
  }

  getData() async {
    selections = [true, false];
    locations.clear();
    totalDistance = 0;
    DataService dataService = DataService();
    await dataService.getLocationData(locations, selectedDate);
    if (locations.length >= 10) {
      for (var i = 0; i < locations.length - 1; i++) {
        totalDistance += calculateDistance(
            locations[i].latitude,
            locations[i].longitude,
            locations[i + 1].latitude,
            locations[i + 1].longitude);
      }
      await addStops();
      totalDumps = statisticsUtil.getDumpingCount(locations)[0];
      totalDumpingTime = statisticsUtil.getDumpingCount(locations)[1];
      totalTime =
          locations.last.uploadTime.difference(locations.first.uploadTime);
      totalCollectionTime = totalTime - totalDumpingTime;
    }
    isLoad = false;
    setState(() {});
  }

  statsCard(String title, String subtitle) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 14),
              width: double.infinity,
              height: 0.5,
              color: Theme.of(context).primaryColor,
            ),
            Text(subtitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? CustomLoading()
          : Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.only(bottom: 0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          selectDate(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Selected Date: ${DateFormat.yMMMEd().format(selectedDate)}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  locations.length < 10
                      ? Expanded(
                          child: CustomErrorWidget(
                            title: "Not enough data to display statistics",
                            iconData: Icons.data_usage,
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // Text(
                                //   "Start Time: ${DateFormat.jm().format(locations.first.uploadTime)}",
                                //   style: TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // Text(
                                //   "End Time: ${DateFormat.jm().format(locations.last.uploadTime)}",
                                //   style: TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // Text(
                                //   "Total Distance: ${totalDistance.toStringAsFixed(2)}kms",
                                //   style: TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // Text(
                                //   "Total Dumping Time: ${totalDumpingTime.inHours}hours ${totalDumpingTime.inMinutes % (totalDumpingTime.inHours * 60 == 0 ? 60 : totalDumpingTime.inHours * 60)}minutes",
                                //   style: TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // Text(
                                //   "Total Collection Time: ${totalCollectionTime.inHours}hours ${totalCollectionTime.inMinutes % (totalCollectionTime.inHours * 60 == 0 ? 60 : totalCollectionTime.inHours * 60)}minutes",
                                //   style: TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // Text(
                                //   "Total Time: ${totalTime.inHours}hours ${totalTime.inMinutes % (totalTime.inHours * 60 == 0 ? 60 : totalTime.inHours * 60)}minutes",
                                //   style: TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // Text(
                                //   "Total Stops: $totalStops",
                                //   style: TextStyle(
                                //     fontSize: 16,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // Text(
                                //   "Total Dumps: $totalDumps",
                                //   style: TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),

                                statsCard(
                                    "Start Time",
                                    DateFormat.jm()
                                        .format(locations.first.uploadTime)
                                        .toString()),
                                statsCard(
                                    "End Time",
                                    DateFormat.jm()
                                        .format(locations.last.uploadTime)
                                        .toString()),
                                statsCard("Total Distance",
                                    "${totalDistance.toStringAsFixed(2)}kms"),

                                statsCard("Total Dumping Time",
                                    "${totalDumpingTime.inHours}hours ${totalDumpingTime.inMinutes % (totalDumpingTime.inHours * 60 == 0 ? 60 : totalDumpingTime.inHours * 60)}mins"),
                                statsCard("Total Collection Time",
                                    "${totalCollectionTime.inHours}hours ${totalCollectionTime.inMinutes % (totalCollectionTime.inHours * 60 == 0 ? 60 : totalCollectionTime.inHours * 60)}mins"),
                                statsCard("Total Time",
                                    "${totalTime.inHours}hours ${totalTime.inMinutes % (totalTime.inHours * 60 == 0 ? 60 : totalTime.inHours * 60)}mins"),

                                statsCard("Total Stops", totalStops.toString()),
                                statsCard("Total Dumps", totalDumps.toString()),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
