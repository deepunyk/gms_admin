import 'package:flutter/material.dart';
import 'package:gms_admin/models/main_model.dart';
import 'package:gms_admin/widgets/display_model_card.dart';

class CollectingSection extends StatefulWidget {
  final List<MainModel> mainModels;

  CollectingSection(this.mainModels);
  @override
  _CollectingSectionState createState() => _CollectingSectionState();
}

class _CollectingSectionState extends State<CollectingSection> {
  List<MainModel> collectingModel = [];

  filterData() {
    collectingModel.clear();
    widget.mainModels.map((mainModel) {
      if (mainModel.startTime != null &&
          mainModel.startTime == mainModel.endTime) {
        collectingModel.add(mainModel);
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
    return collectingModel.length == 0
        ? SizedBox.shrink()
        : Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                "Collecting",
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
                    return DisplayModelCard(collectingModel[index]);
                  },
                  itemCount: collectingModel.length,
                ),
              )
            ],
          );
  }
}
