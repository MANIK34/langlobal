import 'dart:convert';
import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/select_company.dart';
import 'package:langlobal/utilities.dart';
import 'package:langlobal/utilities/testprint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard/DashboardPage.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  String bookName = '';

  LoginPage(this.bookName, {Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage(this.bookName);
}

class _LoginPage extends State<LoginPage> {
  String bookName = '';

  _LoginPage(this.bookName);

  bool ActiveConnection = false;
  String T = "";

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Int8List? _bytes;
  Utilities utilities = Utilities();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  TestPrint testPrint = TestPrint();
  String deviceName='';
  String bluetoothDeviceName="Select Device";

  @override
  void initState() {
    //checkUserConnection();
    utilities.checkUserConnection();
    initPlatformState();
    super.initState();
  }
  Future<void> initPlatformState() async {
    // TODO here add a permission request using permission_handler
    // if permission is not granted, kzaki's thermal print plugin will ask for location permission
    // which will invariably crash the app even if user agrees so we'd better ask it upfront

    // var statusLocation = Permission.location;
    // if (await statusLocation.isGranted != true) {
    //   await Permission.location.request();
    // }
    // if (await statusLocation.isGranted) {
    // ...
    // } else {
    // showDialogSayingThatThisPermissionIsRequired());
    // }
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
      print("device size ::::"+_devices.length.toString());
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }

  }
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
          print('Connection Active');
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
        print('Connection Not Active');
      });
    }
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
          }else if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          } else {
            setState(() {
              _isLoading = true;
            });
            callLoginApi();
           // utilities.callAppErrorLogApi('NULL pointer exception.');
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
          //checkUserConnection();
          if (emailController.text == "") {
            _showToast("Username can't be empty");
          } else if (passwordController.text == "") {
            _showToast("Password can't be empty");
          }else if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          } else {
            setState(() {
              _isLoading = true;
            });
            callLoginApi();
          }

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
    //http://api.sanvitti.com // https://api.langlobal.com
    var url = "${Utilities.baseUrl}auth/v1/authenticateuser";
    print("url :::: "+url);
    print("Baseurl :::: "+Utilities.baseUrl!);
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

          utilities.writeToken();
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
        utilities.callAppErrorLogApi(e.toString(),"login.dart","callLoginApi");
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    print("statusCode :: "+response.statusCode.toString());
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
}
