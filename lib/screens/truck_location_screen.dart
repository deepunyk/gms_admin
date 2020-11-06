import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gms_admin/models/truck_location_model.dart';
import 'package:gms_admin/services/data_service.dart';
import 'package:gms_admin/widgets/custom_loading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

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
    DataService dataService = DataService();
    await dataService.getLocationData(locations);
    print(locations.length);
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
    isLoad = false;
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
      body: isLoad
          ? CustomLoading()
          : GoogleMap(
              markers: markers,
              initialCameraPosition: CameraPosition(
                  zoom: 16,
                  tilt: 0,
                  bearing: 0,
                  target: LatLng(
                      locations.first.latitude, locations.first.longitude)),
              mapType: MapType.normal,
              polylines: polyLines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}
