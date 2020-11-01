import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_admin/services/alert_service.dart';
import 'package:gms_admin/widgets/custom_loading.dart';

class SendScreen extends StatefulWidget {
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  TextEditingController controller = TextEditingController();
  bool isLoad = false;

  addAlert() async {
    isLoad = true;
    setState(() {});
    String message = controller.text;
    if (message.length < 3) {
      Get.rawSnackbar(message: "Please enter a valid message");
    } else {
      AlertService alertService = AlertService();
      await alertService.addAlert(message);
      Get.rawSnackbar(message: "Your message has been sent to all the users");
      controller.clear();
    }
    isLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? CustomLoading()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Send Alert",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextField(
                    decoration:
                        InputDecoration.collapsed(hintText: "Enter something"),
                    textCapitalization: TextCapitalization.sentences,
                    controller: controller,
                    minLines: 6,
                    maxLines: 6,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: Get.height * 0.04),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      addAlert();
                    },
                    child: Text(
                      "SEND",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
