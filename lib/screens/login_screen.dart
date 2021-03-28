import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_admin/screens/home_screen.dart';
import 'package:gms_admin/widgets/custom_auth_button.dart';
import 'package:gms_admin/widgets/custom_loading.dart';
import 'package:gms_core/models/user.dart';
import 'package:gms_core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoad = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  userSignIn() async {
    if (phoneController.text.trim().length == 10) {
      isLoad = true;
      setState(() {});
      AuthService authService = AuthService();
      final response = await authService.adminSignIn(
          phoneController.text.trim(), passwordController.text.trim());
      if (response != null) {
        GetStorage box = GetStorage();
        Admin admin = Admin.fromJson(response["data"]);
        box.write("id", admin.adminId);
        box.write("name", admin.name);
        box.write("photo", admin.photo);
        box.write("phone", admin.phone);
        box.write("designation", admin.designation);
        Get.offAll(HomeScreen());
      } else {
        isLoad = false;
        setState(() {});
      }
    } else {
      isLoad = false;
      setState(() {});
      Get.rawSnackbar(message: "Invalid credentials");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: isLoad
          ? CustomLoading()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Text(
                    "GMS",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 1.1),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Container(
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        hintText: "Enter your mobile number",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Container(
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password"),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  CustomAuthButton(
                    onTap: () => userSignIn(),
                    title: "SIGN IN",
                  )
                ],
              ),
            ),
    );
  }
}
