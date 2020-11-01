import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_admin/models/report_model.dart';
import 'package:gms_admin/services/report_service.dart';
import 'package:gms_admin/widgets/custom_error_widget.dart';
import 'package:gms_admin/widgets/custom_loading.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Report> reports = [];
  bool isLoad = true;

  getReports() async {
    isLoad = true;
    setState(() {});
    reports.clear();
    ReportService reportService = ReportService();
    reports = await reportService.getAllReports();
    isLoad = false;
    setState(() {});
  }

  reportCard(int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: 16),
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: Get.width * 0.08,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User Name: ${reports[index].userName}"),
                  Text("House Name: ${reports[index].houseName}"),
                  Text("Zone Name: ${reports[index].wardName}"),
                ],
              ),
            ),
            SizedBox(
              width: Get.width * 0.04,
            ),
            Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        String googleUrl =
                            'https://www.google.com/maps/search/?api=1&query=${reports[index].latitude},${reports[index].longitude}';
                        if (await canLaunch(googleUrl)) {
                          await launch(googleUrl);
                        } else {
                          throw 'Could not open the map.';
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => launch("tel:${reports[index].phone}"),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReports();
  }

  @override
  Widget build(BuildContext context) {
    DateTime prevDate;

    return isLoad == true
        ? CustomLoading()
        : reports.length == 0
            ? CustomErrorWidget(
                title: "No reports found",
                iconData: Icons.not_interested,
              )
            : Container(
                child: SmartRefresher(
                  enablePullDown: true,
                  header: ClassicHeader(),
                  onRefresh: getReports,
                  controller: _refreshController,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemBuilder: (context, index) {
                      if (prevDate == null) {
                        prevDate = reports[index].complaintDate;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: Text(
                                  "${DateFormat.yMMMEd().format(reports[index].complaintDate)}"),
                            ),
                            reportCard(index)
                          ],
                        );
                      } else {
                        final reportDay = DateTime(
                            reports[index].complaintDate.year,
                            reports[index].complaintDate.month,
                            reports[index].complaintDate.day);
                        final prevDay = DateTime(
                            prevDate.year, prevDate.month, prevDate.day);
                        bool check = reportDay == prevDay;
                        if (!check) {
                          prevDate = reports[index].complaintDate;
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!check)
                              Container(
                                child: Text(
                                    "${DateFormat.yMMMEd().format(reports[index].complaintDate)}"),
                              ),
                            reportCard(index)
                          ],
                        );
                      }
                    },
                    itemCount: reports.length,
                  ),
                ),
              );
  }
}
