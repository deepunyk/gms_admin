import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_admin/data/custom_constants.dart';
import 'package:gms_admin/utils/conn_utils.dart';

class AuthService {
  Future<bool> signIn(String phone, String password) async {
    Dio dio = new Dio();

    print("$phone $password");
    try {
      Response response = await dio.post(
        "${CustomConstants.url}signIn",
        data: {
          'admin_password': password,
          "admin_phone": phone,
        },
      );

      print(response.data);

      if (response.data['success'] &&
          response.data['message'] == "Signin successfull") {
        GetStorage box = GetStorage();
        box.write("token", response.data['token']);
        box.write("admin_id", response.data['admin_id'].toString());
        box.write("admin_name", response.data['admin_name'].toString());
        box.write("admin_photo", response.data['admin_photo'].toString());
        box.write("admin_phone", response.data['admin_phone'].toString());
        box.write(
            "admin_designation", response.data['admin_designation'].toString());
        box.write("isAdmin", response.data['isAdmin'].toString());
        return true;
      } else {
        Get.rawSnackbar(message: "Invalid Credentials");
        return false;
      }
    } catch (e) {
      Get.rawSnackbar(message: "Oops! Something went wrong");
      return false;
    }
  }
}
