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
import '../utility/custom_toast.dart';

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
      CustomToast.show(context, "Configuration properties not found");
      return;
    }

    final Uri url = Uri.parse('$baseUrl');
    final Map<String, String> headers = {
      'appVersion': appVersion,
      'env': environment,
      'lang': 'EN',
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
            CustomToast.show(context, ResponseMessages.UPDATE_REQUIRED_MESSAGE);
            exitForUpdate(AppUtility.APP_EXIT_DELAY);
          } else {
            final apiInfoList = jsonResponse['data'];
            if (apiInfoList != null && apiInfoList is List) {
              for (final apiInfo in apiInfoList) {
                if (apiInfo != null && apiInfo is Map) {
                  final apiInfoResponseDTO = APIInfoResponseDTO.fromJson(
                      apiInfo.cast<String, dynamic>());
                  actionToApiInfo[apiInfoResponseDTO.action] =
                      apiInfoResponseDTO;
                }
              }
            }

            final appUpdateApiInfo = actionToApiInfo["APP_UPDATE"];
            if (appUpdateApiInfo != null) {
              final appUpdateResponse = await http.get(
                Uri.parse(appUpdateApiInfo.uri),
                headers: headers,
              );
              print("evaluating response");
              if (appUpdateResponse.statusCode == 200) {
                final appUpdateResponseData = appUpdateResponse.body;
                // Log the response data to check its content
                print("Response Data: $appUpdateResponseData");

                if (appUpdateResponseData != null &&
                    appUpdateResponseData.isNotEmpty) {
                  try {
                    final responseObject = ResponseDTO.fromJson(
                        json.decode(appUpdateResponseData));

                    if (responseObject.statusCode ==
                        ResponseCodes.UPDATE_REQUIRED_CODE) {
                      if (responseObject.message != null &&
                          responseObject.message!.isNotEmpty) {
                        CustomToast.show(context, responseObject.message!);
                      } else {
                        print("Update message is null or empty");
                        CustomToast.show(
                            context, ResponseMessages.UPDATE_REQUIRED_MESSAGE);
                      }
                      exitForUpdate(AppUtility.APP_EXIT_DELAY);
                    } else if (responseObject.statusCode! >=
                        ResponseCodes.SUCCESS_CODE) {
                      print("Success");
                      // CustomToast.show(context, ResponseMessages.SUCCESS_MESSAGE);
                    }
                  } catch (e) {
                    print("Failed to decode JSON: $e");
                    CustomToast.show(
                        context, "Failed to process server response");
                  }
                } else {
                  print("Empty or null response received");
                  CustomToast.show(context, "Empty or null response received");
                }
              } else {
                print("Failed to fetch app update data");
                if (appUpdateResponse.body.isEmpty) {
                  print("Empty response");
                  CustomToast.show(context, "Server Error: Empty Response");
                } else {
                  print("Startup failure");
                  CustomToast.show(context, ResponseMessages.STARTUP_FAILURE);
                }
              }
            }
          }
        } else {
          print("i am from 1");
          CustomToast.show(context, ResponseMessages.STARTUP_FAILURE);
          exitAfterDelay(AppUtility.APP_EXIT_DELAY);
        }
      } else {
        print("i am from 2");
        CustomToast.show(context, ResponseMessages.STARTUP_FAILURE);
        exitAfterDelay(AppUtility.APP_EXIT_DELAY);
      }
    } catch (e) {
      print("i am from 3 $e");
      CustomToast.show(context, ResponseMessages.STARTUP_FAILURE);
      exitAfterDelay(AppUtility.APP_EXIT_DELAY);
    }
  }

  void showUpdatePrompt(String message) {
    // Implement update prompt logic here
    // Show an alert or prompt to the user to update the app using the provided message
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
