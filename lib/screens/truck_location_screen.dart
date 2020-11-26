import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gms_admin/models/truck_location_model.dart';
import 'package:gms_admin/services/data_service.dart';
import 'package:gms_admin/utils/truck_location_util.dart';
import 'package:gms_admin/widgets/custom_loading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class TruckLocationScreen extends StatefulWidget {
  @override
  _TruckLocationScreenState createState() => _TruckLocationScreenState();
}

class _TruckLocationScreenState extends State<TruckLocationScreen> {
  List<TruckLocation> locations = [];
  bool isLoad = true;
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> polyLines = {};
  Set<Marker> markers = {};
  BitmapDescriptor userIcon;
  SfRangeValues dateValues;
  bool isSetting = false;
  List<bool> selections = [true, false];
  TruckLocationUtil truckLocationUtil = TruckLocationUtil();

  DateTime selectedDate = DateTime.now();

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

  Future addPath() async {
    await truckLocationUtil.addPath(
        controller: _controller,
        locations: locations,
        markers: markers,
        polyLines: polyLines);
    setState(() {});
    return;
  }

  getData() async {
    selections = [true, false];
    locations.clear();
    markers.clear();
    polyLines.clear();
    DataService dataService = DataService();
    await dataService.getLocationData(locations, selectedDate);
    if (locations.length == 0) {
      Get.rawSnackbar(message: "No data was collected on this date");
    } else {
      dateValues =
          SfRangeValues(locations.first.uploadTime, locations.last.uploadTime);
      await addPath();
    }
    isLoad = false;
    setState(() {});
  }

  filterData() async {
    isSetting = true;
    setState(() {});
    await truckLocationUtil.filterData(
        polyLines: polyLines,
        markers: markers,
        locations: locations,
        dateValues: dateValues);
    isSetting = false;
    setState(() {});
  }

  addStops() {
    truckLocationUtil.addStops(
        markers: markers, locations: locations, polyLines: polyLines);
    setState(() {});
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
      appBar: AppBar(
        title: Text("Truck Location"),
      ),
      body: Stack(
        children: [
          Column(
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
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      markers: markers,
                      initialCameraPosition: CameraPosition(
                          zoom: 16,
                          tilt: 0,
                          bearing: 0,
                          target: locations.length == 0
                              ? LatLng(13.338661, 74.748399)
                              : LatLng(locations.first.latitude,
                                  locations.first.longitude)),
                      mapType: MapType.normal,
                      polylines: polyLines,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ],
                ),
              ),
              if (locations.length > 2)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          ToggleButtons(
                            children: [
                              Icon(Icons.map_outlined),
                              Icon(Icons.add_location),
                            ],
                            isSelected: selections,
                            onPressed: (index) async {
                              print(index);
                              if (index == 0) {
                                selections[0] = true;
                                selections[1] = false;
                                addPath();
                              } else {
                                selections[0] = false;
                                selections[1] = true;
                                addStops();
                              }
                            },
                          ),
                        ],
                      ),
                      SfRangeSlider(
                        min: locations.first.uploadTime,
                        max: locations.last.uploadTime,
                        values: dateValues,
                        interval: 2,
                        dateFormat: DateFormat.jm(),
                        dateIntervalType: DateIntervalType.hours,
                        showTicks: true,
                        showLabels: true,
                        showTooltip: true,
                        minorTicksPerInterval: 1,
                        onChanged: (dynamic value) {
                          setState(() {
                            dateValues = value;
                            if (!isSetting) {
                              filterData();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
          if (isLoad) CustomLoading()
        ],
      ),
    );
  }
}
