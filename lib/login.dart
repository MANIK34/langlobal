import 'dart:convert';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/select_company.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard/DashboardPage.dart';

class LoginPage extends StatefulWidget {
  String bookName = '';

  LoginPage(this.bookName, {Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage(this.bookName);
}

class _LoginPage extends State<LoginPage> {
  String bookName = '';

  _LoginPage(this.bookName);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Int8List? _bytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        maxLength: 20,
        controller: emailController,
        style: style,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Username",
          alignLabelWithHint: true,
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final passwordField = TextField(
        textAlign: TextAlign.start,
        keyboardType: TextInputType.visiblePassword,
        maxLength: 20,
        controller: passwordController,
        style: style,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if (emailController.text == "") {
            _showToast("Username can't be empty");
          } else if (passwordController.text == "") {
            _showToast("Password can't be empty");
          } else {
            setState(() {
              _isLoading = true;
            });
            callLoginApi();
          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Password",
          alignLabelWithHint: true,
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (emailController.text == "") {
            _showToast("Username can't be empty");
          } else if (passwordController.text == "") {
            _showToast("Password can't be empty");
          } else {
            setState(() {
              _isLoading = true;
            });
            callLoginApi();
          }
         // callGetCartonLookupApi(false);
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Login',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 5.0),
                            SizedBox(
                              height: 100.0,
                              child: Image.asset(
                                "assets/lan_global_icon.jpeg",
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 45.0),
                            emailField,
                            const SizedBox(
                              height: 15.0,
                            ),
                            passwordField,
                            const SizedBox(
                              height: 30.0,
                            ),
                            submitButton,
                            const SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ));
  }

  void callLoginApi() async {
  /*  final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
    } else if (connectivityResult == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
    } else if (connectivityResult == ConnectivityResult.other) {
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am not connected to any network.
    }*/

    //http://api.sanvitti.com // https://api.langlobal.com

    var url = "https://api.langlobal.com/auth/v1/authenticateuser";
    Map<String, String> headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "username": emailController.text.toString(),
      "password": passwordController.text.toString(),
      "source": "Mobile",
    });
    var jsonRequest = json.decode(body);
    print("requestParams$body");
    var response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        print('returnCode' + returnCode.toString());
        if (returnCode == "1") {
          var userInfo = jsonResponse['userInfo'];
          var companyInfo = userInfo['companyInfo'];
          var userId = userInfo['userID'];
          var userName = userInfo['userName'];
          var userType = userInfo['userType'];
          var token = jsonResponse['token'];
          SharedPreferences myPrefs = await SharedPreferences.getInstance();
          myPrefs.setString('token', token.toString());
          myPrefs.setString('userId', userId.toString());
          myPrefs.setString('userName', userName.toString());
          myPrefs.setString('userType', userType.toString());
          myPrefs.setString(
              'companyLogo', companyInfo['companyLogo'].toString());
          myPrefs.setString('companyID', "");
          _showToast("Login successfully!");
          if (userType == "LANGlobal") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SelectCompany('')),
            );
          } else {
            myPrefs.setString('companyID', companyInfo['companyID'].toString());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage(token)),
            );
          }
        } else {
          _showToast("Incorrect username or password");
        }
      } catch (e) {
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    print(response.body);
    setState(() {
      _isLoading = false;
    });
  }

  void _showToast(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
      action: SnackBarAction(
        label: "OK",
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ),
    ));

    // _scaffoldKey.currentState!.showSnackBar(SnackBar(
    //   content: Text(errorMessage),
    //   action: SnackBarAction(
    //     label: "OK",
    //     onPressed: _scaffoldKey.currentState!.hideCurrentSnackBar,
    //   ),
    // ));
  }

  void _getBytes(imageUrl) async {
    final ByteData data =
        await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
    setState(() {
      _bytes = data.buffer.asInt8List();
      print(_bytes);
    });
  }

/* Image.memory(
  Uint8List.fromList(_bytes!),
  width: 250,
  height: 250,
  fit: BoxFit.contain,
  ),*/
}

void openPdf() async {
  var url = "https://langlobal.com/label/638177496557943705.pdf";
  Uri myUri = Uri.parse(url);
  var data = await http.get(myUri);
  await Printing.layoutPdf(onLayout: (_) => data.bodyBytes);
}


void callGetCartonLookupApi(bool isPrint) async {
  SharedPreferences myPrefs = await SharedPreferences.getInstance();
  String? token = myPrefs.getString("token");
  String? companyID = myPrefs.getString("companyID");
  var url;
  url = "https://api.langlobal.com/inventoryallocation/v1/cartonlookup/"+
     "LGI20230322221005023"+"?action=print";
  Map<String, String> headers = {
    'Authorization': 'Bearer ${token!}'
  };
  print(url.toString());
  var response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    try {
      var returnCode=jsonResponse['returnCode'];
      if(returnCode=="1"){
        var base64Image=jsonResponse['base64String'];
        print("base_64"+ base64Image);
        Uint8List bytx=Base64Decoder().convert(base64Image);
        await Printing.layoutPdf(onLayout: (_) => bytx);
      }
    } catch (e) {
      print('returnCode'+e.toString());
      // TODO: handle exception, for example by showing an alert to the user
    }
  } else {
    print(response.statusCode);
  }
  debugPrint(response.body);

}
