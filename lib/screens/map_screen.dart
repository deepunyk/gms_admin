import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gms_admin/models/main_model.dart';
import 'package:gms_admin/widgets/custom_loading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool isLoad = true;
  List<MainModel> mainModels = [];
  LatLng userLocation = LatLng(13.333767, 74.743146);
  BitmapDescriptor userIcon;
  Set<Marker> markers = {};
  Set<Polygon> polygons = {};
  MainModel currentModel;
  bool isUploading = false;
  bool isCheck = false;

  createUserIcon() async {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    userIcon = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/userLocation.png');
    markers.add(Marker(
      markerId: MarkerId("user"),
      position: userLocation,
      icon: userIcon,
      anchor: Offset(0.5, 0.5),
    ));
    isLoad = false;
    setState(() {});
  }

  addPolygon() {
    mainModels.map((mm) {
      int code = 0;
      if (mm.startTime != null) {
        if (mm.startTime == mm.endTime) {
          code = 1;
        } else {
          code = 2;
        }
      }
      polygons.add(Polygon(
          polygonId: PolygonId(mm.wardId),
          fillColor: code == 0
              ? Colors.red.withOpacity(0.15)
              : code == 1
                  ? Colors.yellow.withOpacity(0.15)
                  : Colors.green.withOpacity(0.15),
          strokeWidth: 1,
          points: mm.latitude.map((lat) {
            return LatLng(double.parse(lat),
                double.parse(mm.longitude[mm.latitude.indexOf(lat)]));
          }).toList()));
    }).toList();
  }

  collectData() async {
    //createUserIcon();
    addPolygon();
    mainModels.map((mainModel) {
      if (mainModel.startTime != null &&
          mainModel.startTime == mainModel.endTime) {
        currentModel = mainModel;
      }
    }).toList();
    isLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isCheck) {
      mainModels = ModalRoute.of(context).settings.arguments;
      isCheck = false;
      collectData();
    }

    return Scaffold(
      body: isLoad
          ? CustomLoading()
          : Stack(
              children: <Widget>[
                GoogleMap(
                  markers: markers,
                  polygons: polygons,
                  initialCameraPosition: CameraPosition(
                      zoom: 16, tilt: 0, bearing: 0, target: userLocation),
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ],
            ),
    );
  }
}
