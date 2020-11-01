import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_admin/models/main_model.dart';
import 'package:gms_admin/screens/collection_screen.dart';
import 'package:gms_admin/screens/map_screen.dart';
import 'package:gms_admin/screens/report_screen.dart';
import 'package:gms_admin/screens/send_screen.dart';
import 'package:gms_admin/services/data_service.dart';
import 'package:gms_admin/widgets/collected_section.dart';
import 'package:gms_admin/widgets/collecting_section.dart';
import 'package:gms_admin/widgets/custom_loading.dart';
import 'package:gms_admin/widgets/pending_section.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int curIndex = 0;
  List<Widget> screens = [CollectionScreen(), ReportScreen(), SendScreen()];

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
                Icons.send,
              ),
              label: "Send"),
        ],
      ),
      body: screens[curIndex],
    );
  }
}
