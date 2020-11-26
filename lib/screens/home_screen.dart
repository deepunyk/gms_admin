import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_admin/models/main_model.dart';
import 'package:gms_admin/screens/collection_screen.dart';
import 'package:gms_admin/screens/map_screen.dart';
import 'package:gms_admin/screens/report_screen.dart';
import 'package:gms_admin/screens/send_screen.dart';
import 'package:gms_admin/screens/statistics_screen.dart';
import 'package:gms_admin/screens/truck_location_screen.dart';
import 'package:gms_admin/widgets/grid_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int curIndex = 3;
  final List GRID_DATA = [
    {
      "title": "Collection",
      "image": "assets/images/clipboard.png",
      "onTap": () {
        Get.to(CollectionScreen());
      },
    },
    {
      "title": "Reports",
      "image": "assets/images/exclamation.png",
      "onTap": () {
        Get.to(ReportScreen());
      },
    },
    {
      "title": "Location",
      "image": "assets/images/map.png",
      "onTap": () {
        Get.to(TruckLocationScreen());
      },
    },
    {
      "title": "Statistics",
      "image": "assets/images/stats.png",
      "onTap": () {
        Get.to(StatisticsScreen());
      },
    },
    {
      "title": "Send",
      "image": "assets/images/send.png",
      "onTap": () {
        Get.to(SendScreen());
      },
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    fbm.subscribeToTopic('admin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("GMS Udupi"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80.0),
                  bottomRight: Radius.circular(80.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 10.0,
                    offset: Offset(2.0, 2.0),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "assets/images/profile.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "Mr. XYZ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "District Administrator",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
              children: GRID_DATA.map((grid) {
                return GridCard(grid: grid);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
