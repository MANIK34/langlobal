import 'package:shared_preferences/shared_preferences.dart';

import 'model/requestParams/cartonProvisioning.dart';
import 'model/requestParams/imeIsList.dart';

class Utilities {
  static String? baseUrl = "https://api.langlobal.com/";
  static String? token = "";
  static String? companyID="";
  static List<ImeiList> ImeisList = <ImeiList>[];
  static List<CartonProvisioningList> cartonProList = <CartonProvisioningList>[];

  writeToken() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    token = myPrefs.getString("token");
    companyID = myPrefs.getString("companyID");
  }
}
