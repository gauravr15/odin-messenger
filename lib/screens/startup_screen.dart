import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:odin_messenger/dto/api_info_dto.dart';
import '../constants/response_codes.dart';
import '../constants/response_messages.dart';
import '../dto/response_dto.dart';
import '../utility/app_utility.dart';
import '../utility/app_properties.dart';

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  Map<String, APIInfoResponseDTO> actionToApiInfo = {};

  @override
  void initState() {
    super.initState();
    getAppDetails();
  }

  Future<void> getAppDetails() async {
    final String? baseUrl = AppProperties.getProperty('dev.baseUrl');
    final String? environment = AppProperties.getProperty('app.environment');
    final String? appVersion = AppProperties.getProperty('app.version');

    if (baseUrl == null || environment == null || appVersion == null) {
      showMessage("Configuration properties not found");
      return;
    }

    final Uri url = Uri.parse('$baseUrl');
    final Map<String, String> headers = {
      'appVersion': appVersion,
      'env': environment,
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
          } else {
            final apiInfoList = jsonResponse['data'];
            // Create a map of action to APIInfoResponseDTO
            for (final apiInfo in apiInfoList) {
              final apiInfoResponseDTO = APIInfoResponseDTO.fromJson(apiInfo);
              actionToApiInfo[apiInfoResponseDTO.action] = apiInfoResponseDTO;
            }
          }
        } else {
          showMessage(ResponseMessages.STARTUP_FAILURE);
          exitAfterDelay(AppUtility.APP_EXIT_DELAY);
        }
      } else {
        showMessage(ResponseMessages.STARTUP_FAILURE);
        exitAfterDelay(AppUtility.APP_EXIT_DELAY);
      }
    } catch (e) {
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
      backgroundColor: Color(0xFFC9A0E1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'resources/images/brandLogo.png',
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
