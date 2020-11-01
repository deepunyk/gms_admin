import 'package:cloud_firestore/cloud_firestore.dart';

class AlertService {
  Future<void> addAlert(String message) async {
    await FirebaseFirestore.instance
        .collection("notification")
        .add({"title": "Message from GMS", "body": message, "to": "alerts"});
    return;
  }
}
