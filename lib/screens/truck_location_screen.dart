import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gms_admin/models/truck_location_model.dart';
import 'package:gms_admin/services/data_service.dart';
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

  Future<void> createUserIcon() async {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    userIcon = await BitmapDescriptor.fromAssetImage(
      configuration,
      'assets/images/truck_marker.png',
    );
    return;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  getData() async {
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
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(locations.first.latitude, locations.first.longitude),
          zoom: 16)));
      polyLines.add(Polyline(
        width: 4,
        color: Colors.blue,
        polylineId: PolylineId("truck"),
        points: locations
            .map(
              (e) => LatLng(e.latitude, e.longitude),
            )
            .toList(),
        endCap: Cap.buttCap,
        startCap: Cap.roundCap,
      ));
      //await createUserIcon();
      final Uint8List curImg = await getBytesFromAsset(
        "assets/images/current_marker.png",
        150,
      );

      final Uint8List startImg = await getBytesFromAsset(
        "assets/images/start_marker.png",
        150,
      );

      markers.add(
        Marker(
          markerId: MarkerId("${locations.first.id}"),
          position: LatLng(locations.first.latitude, locations.first.longitude),
          icon: BitmapDescriptor.fromBytes(startImg),
          infoWindow: InfoWindow(
              title: "${DateFormat.jm().format(locations.first.uploadTime)}"),
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId("${locations.last.id}"),
          position: LatLng(locations.last.latitude, locations.last.longitude),
          icon: BitmapDescriptor.fromBytes(curImg),
          infoWindow: InfoWindow(
              title: "${DateFormat.jm().format(locations.last.uploadTime)}"),
        ),
      );
    }
    isLoad = false;
    setState(() {});
  }

  filterData() async {
    isSetting = true;
    setState(() {});
    List<TruckLocation> tempLocations = [];
    markers.clear();
    polyLines.clear();
    locations.map((e) {
      if (e.uploadTime.isAfter(dateValues.start) &&
          e.uploadTime.isBefore(dateValues.end)) {
        tempLocations.add(e);
      }
    }).toList();
    if (tempLocations.length > 0) {
      polyLines.add(Polyline(
        width: 4,
        color: Colors.blue,
        polylineId: PolylineId("truck"),
        points: tempLocations
            .map(
              (e) => LatLng(e.latitude, e.longitude),
            )
            .toList(),
        endCap: Cap.buttCap,
        startCap: Cap.roundCap,
      ));
      //await createUserIcon();
      final Uint8List curImg = await getBytesFromAsset(
        "assets/images/current_marker.png",
        150,
      );

      final Uint8List startImg = await getBytesFromAsset(
        "assets/images/start_marker.png",
        150,
      );

      markers.add(
        Marker(
          markerId: MarkerId("${tempLocations.first.id}"),
          position: LatLng(
              tempLocations.first.latitude, tempLocations.first.longitude),
          icon: BitmapDescriptor.fromBytes(startImg),
          infoWindow: InfoWindow(
              title:
                  "${DateFormat.jm().format(tempLocations.first.uploadTime)}"),
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId("${tempLocations.last.id}"),
          position:
              LatLng(tempLocations.last.latitude, tempLocations.last.longitude),
          icon: BitmapDescriptor.fromBytes(curImg),
          infoWindow: InfoWindow(
              title:
                  "${DateFormat.jm().format(tempLocations.last.uploadTime)}"),
        ),
      );
    }
    isSetting = false;

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
                  child: SfRangeSlider(
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
                )
            ],
          ),
          if (isLoad) CustomLoading()
        ],
      ),
    );
  }
}
