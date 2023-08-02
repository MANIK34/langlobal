import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/requestParams/cartonProvisioning.dart';
import 'model/requestParams/imeIsList.dart';

class Utilities  {
  static String? baseUrl = "https://api.langlobal.com/";
  static String? token = "";
  static String? companyID="";
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
}
