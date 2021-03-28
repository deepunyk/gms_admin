import 'package:flutter/material.dart';
import 'package:gms_admin/widgets/display_model_card.dart';
import 'package:gms_core/models/main_model.dart';

class CollectedSection extends StatefulWidget {
  final List<MainModel> mainModels;

  CollectedSection(this.mainModels);

  @override
  _CollectedSectionState createState() => _CollectedSectionState();
}

class _CollectedSectionState extends State<CollectedSection> {
  List<MainModel> collectedModel = [];

  filterData() {
    collectedModel.clear();
    widget.mainModels.map((mainModel) {
      if (mainModel.startTime != null &&
          mainModel.startTime != mainModel.endTime) {
        collectedModel.add(mainModel);
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
    return collectedModel.length == 0
        ? SizedBox.shrink()
        : Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                "Collected",
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
                    return DisplayModelCard(collectedModel[index]);
                  },
                  itemCount: collectedModel.length,
                ),
              )
            ],
          );
  }
}
