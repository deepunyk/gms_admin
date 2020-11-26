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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int curIndex = 3;
  List<Widget> screens = [
    CollectionScreen(),
    ReportScreen(),
    TruckLocationScreen(),
    StatisticsScreen(),
    SendScreen(),
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
        title: Text("GMS Udupi"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (val) {
          curIndex = val;
          setState(() {});
        },
        currentIndex: curIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: "Collections"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.feedback_outlined,
              ),
              label: "Reports"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.location_on,
              ),
              label: "Location"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.data_usage,
              ),
              label: "Statistics"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.send,
              ),
              label: "Send"),
        ],
      ),
      body: screens[curIndex],
    );
  }
}
