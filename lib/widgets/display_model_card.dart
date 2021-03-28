import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_core/models/main_model.dart';
import 'package:intl/intl.dart';

class DisplayModelCard extends StatefulWidget {
  final MainModel mainModel;

  DisplayModelCard(this.mainModel);

  @override
  _DisplayModelCardState createState() => _DisplayModelCardState();
}

class _DisplayModelCardState extends State<DisplayModelCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Text(
              "${widget.mainModel.wardName}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (widget.mainModel.startTime != null)
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    height: 0.5,
                    width: Get.width * 0.8,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    "Started at: ${DateFormat.jm().format(widget.mainModel.startTime)}",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (widget.mainModel.startTime != widget.mainModel.endTime)
                    Text(
                        "Finished at: ${DateFormat.jm().format(widget.mainModel.endTime)}",
                        style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Vehicle ID: ${widget.mainModel.vehicleId}")
                ],
              )
          ],
        ),
      ),
    );
  }
}
