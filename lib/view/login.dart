
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatme/controller/auth_controller.dart';
import 'package:chatme/view/home.dart';
import 'package:chatme/view/signup.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_authController.user != null) {
        return Home();
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('login'.tr),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'email'.tr,
                    ),
                    controller: _emailController,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'password'.tr,
                    ),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    child: Text('log_in'.tr),
                    onPressed: () async {
                      _authController.login(
                          _emailController.text, _passwordController.text);
                    },
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    child: Text('sign_up'.tr),
                    onPressed: () {
                      Get.to(const SignUp());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
