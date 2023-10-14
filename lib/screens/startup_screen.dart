import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constants/response_codes.dart';
import '../constants/response_messages.dart';
import '../dto/response_dto.dart';
import '../utility/app_utility.dart';

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    getAppDetails();
  }

  Future<void> getAppDetails() async {
    final Uri url =
        Uri.parse('http://192.168.29.110:8090/app-mgmt/v1/getAppDetails');
    final Map<String, String> headers = {
      'appVersion': '1.0.0',
    };

    try {
      final response =
          await http.get(url, headers: headers).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final status = jsonResponse['status'];
        if (status == 'SUCCESS') {
          final responseDTO = ResponseDTO.fromJson(jsonResponse);
          if (responseDTO.statusCode == ResponseCodes.UPDATE_REQUIRED_CODE) {
            showMessage(ResponseMessages.UPDATE_REQUIRED_MESSAGE);
            exitForUpdate(AppUtility.APP_EXIT_DELAY);
          }
        } else {
          showMessage(ResponseMessages.STARTUP_FAILURE);
          exitAfterDelay(AppUtility.APP_EXIT_DELAY);
        }
      } else {
        // Handle other HTTP status codes
        showMessage(ResponseMessages.STARTUP_FAILURE);
        exitAfterDelay(AppUtility.APP_EXIT_DELAY);
      }
    } catch (e) {
      // Handle network or other errors
      showMessage(ResponseMessages.STARTUP_FAILURE);
      exitAfterDelay(AppUtility.APP_EXIT_DELAY);
    }
  }

  void showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void exitAfterDelay(int delay) {
    Future.delayed(Duration(seconds: delay), () {
      SystemNavigator.pop(); // Use this to exit the app.
    });
  }

  void exitForUpdate(int delay) {
    Future.delayed(Duration(seconds: delay), () {
      SystemNavigator.pop(); // Use this to exit the app.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFFC9A0E1), // Make sure to define 'lightPurple' color.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'resources/images/brandLogo.png', // Make sure the path is correct.
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
