import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/requestParams/cartonProvisioning.dart';
import 'model/requestParams/imeIsList.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Utilities  {
  static String? baseUrl = "https://api.langlobal.com/";
  static String? token = "";
  static String? companyID="";
  static String? userId= "";
  static List<ImeiList> ImeisList = <ImeiList>[];
  static List<CartonProvisioningList> cartonProList = <CartonProvisioningList>[];

  static bool ActiveConnection = false;
  String T = "";

  writeToken() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    token = myPrefs.getString("token");
    companyID = myPrefs.getString("companyID");
  }

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ActiveConnection = true;
        T = "Turn off the data and repress again";
        print('Connection Active');
      }
    } on SocketException catch (_) {
      ActiveConnection = false;
      T = "Turn On the data and repress again";
      print('Connection Not Active');
    }
  }

  void callAppErrorLogApi(var errorMessage, var className, var methodName) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    userId=myPrefs.getString("userId");
    var token=myPrefs.getString("token");
    var url = "${Utilities.baseUrl}common/v1/apperrorlog";

    Map<String, String> headers = {'Content-type': 'application/json','Authorization': 'Bearer ' + token!};
    var body = json.encode({
      "moduleName": "Login",
      "errorMessage": errorMessage,
      "methodName": methodName,
      "userID": userId,
      "pageUrl": "",
      "stackTrace": "",
      "className":className,
      "uiSource":"A",

    });
    var jsonRequest = json.decode(body);
    print("requestParams$body");
    print("requestUrl $url");
    print("requestToken $token");
    var response =
    await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
        }
      } catch (e) {
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    print("app Error API Response :: ${response.body}");


  }
}
