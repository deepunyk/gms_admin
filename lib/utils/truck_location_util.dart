import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gms_admin/models/truck_location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class TruckLocationUtil {
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future addPath(
      {Set<Marker> markers,
      Set<Polyline> polyLines,
      List<TruckLocation> locations,
      Completer<GoogleMapController> controller}) async {
    markers.clear();
    polyLines.clear();

    final GoogleMapController _controller = await controller.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
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
    return;
  }

  Future filterData(
      {Set<Marker> markers,
      Set<Polyline> polyLines,
      List<TruckLocation> locations,
      SfRangeValues dateValues}) async {
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
    return;
  }

  Future addStops(
      {Set<Marker> markers,
      Set<Polyline> polyLines,
      List<TruckLocation> locations}) async {
    polyLines.clear();
    markers.clear();
    locations.map((e) {
      if (e != locations.last &&
          locations[locations.indexOf(e) + 1]
                  .uploadTime
                  .difference(e.uploadTime) >
              Duration(minutes: 2)) {
        markers.add(
          Marker(
            markerId: MarkerId("${e.id}"),
            position: LatLng(e.latitude, e.longitude),
            infoWindow:
                InfoWindow(title: "${DateFormat.jm().format(e.uploadTime)}"),
          ),
        );
      }
    }).toList();
    return;
  }
}
