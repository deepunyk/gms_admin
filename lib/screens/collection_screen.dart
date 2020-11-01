import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_admin/models/main_model.dart';
import 'package:gms_admin/screens/map_screen.dart';
import 'package:gms_admin/services/data_service.dart';
import 'package:gms_admin/widgets/collected_section.dart';
import 'package:gms_admin/widgets/collecting_section.dart';
import 'package:gms_admin/widgets/custom_loading.dart';
import 'package:gms_admin/widgets/pending_section.dart';
import 'package:intl/intl.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<MainModel> mainModels = [];
  bool isLoad = true;
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
      getData();
    }
  }

  getData() async {
    isLoad = true;
    setState(() {});
    mainModels.clear();
    DataService dataService = DataService();
    await dataService.collectAllData(mainModels, selectedDate);
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
    return isLoad
        ? CustomLoading()
        : Stack(
            children: [
              SingleChildScrollView(
                child: Column(
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
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
                    PendingSection(mainModels),
                    CollectingSection(mainModels),
                    CollectedSection(mainModels),
                    SizedBox(
                      height: Get.height * 0.2,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Get.to(MapScreen(), arguments: mainModels);
                    },
                    child: Text(
                      "SHOW IN MAPS",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
