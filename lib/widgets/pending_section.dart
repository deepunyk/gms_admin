import 'package:flutter/material.dart';
import 'package:gms_admin/widgets/display_model_card.dart';
import 'package:gms_core/models/main_model.dart';

class PendingSection extends StatefulWidget {
  final List<MainModel> mainModels;

  PendingSection(this.mainModels);

  @override
  _PendingSectionState createState() => _PendingSectionState();
}

class _PendingSectionState extends State<PendingSection> {
  List<MainModel> pendingModel = [];

  filterData() {
    pendingModel.clear();
    widget.mainModels.map((mainModel) {
      if (mainModel.startTime == null) {
        pendingModel.add(mainModel);
      }
    }).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterData();
  }

  @override
  Widget build(BuildContext context) {
    return pendingModel.length == 0
        ? SizedBox.shrink()
        : Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                "Pending Collections",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return DisplayModelCard(pendingModel[index]);
                  },
                  itemCount: pendingModel.length,
                ),
              )
            ],
          );
  }
}
