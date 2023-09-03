import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:langlobal/bluetooth_demo.dart';
import 'package:langlobal/changeCompany/ChangeCompany.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/login.dart';
import 'package:langlobal/warehouseAllocation/skuLookup/skuLookupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../locationLookup/locationLookupPage.dart';
import '../summary/fulfillment/orderSearchPage.dart';
import '../transientSearch/transientOrderSearch.dart';
import '../utilities/testprint.dart';
import '../warehouseAllocation/cartonLookup/cartonLookupPage.dart';
import '../warehouseAllocation/inventoryLookup/inventoryLookupPage.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:developer' as developer;

class DrawerElement extends StatefulWidget {
  @override
  _DrawerElement createState() => _DrawerElement();
}

class _DrawerElement extends State<DrawerElement> {
  String userName = "";
  String userType = "";
  bool visibleCompany = false;
  final double coverHeight = 280;
  final double profileHeight = 144;
  String companyLogo = "http://via.placeholder.com/350x150";
  String bluetoothDeviceName = 'Connect Bluetooth Device.';
  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  TestPrint testPrint = TestPrint();
  String deviceName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    getUserInfo();
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
      print("device size ::::" + _devices.length.toString());
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
    _initNetworkInfo();
  }

  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    setState(() {
      if (wifiName == null || wifiName == "") {
        wifiName = "WiFi turned off";
      }
      _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IPv4: $wifiIPv4\n'
          'Wifi IPv6: $wifiIPv6\n'
          'Wifi Broadcast: $wifiBroadcast\n'
          'Wifi Gateway: $wifiGatewayIP\n'
          'Wifi Submask: $wifiSubmask\n';

      _connectionStatus = ' $wifiName';
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: Stack(
      children: <Widget>[
        Container(
          child: ListView(
            padding: const EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 0, top: 50),
                        width: 160,
                        height: 45,
                        child: buildProfileImage(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              userName,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                            Spacer(),
                            Text(
                              '9/1/2023 3:10 pm',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.black),
              Container(
                height: 40,
                color: Colors.blue,
                child: Align(
                  child:  Text(
                    'Favorite',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.center,
                ),
              ),
              Divider(
                height: 10,
              ),
              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage('')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 0),
                      child: const Text(
                        'Home',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(color: Colors.black),
              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TransientOrderSearchPage('3')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: const Text(
                        'Transient Receive',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(color: Colors.black),

              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {

                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: const Text(
                        'Triage',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(color: Colors.black),

              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrderSearchPage('3')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: const Text(
                        'Fulfillment',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(
                height: 8,
              ),
              Container(
                height: 40,
                color: Colors.blue,
                child: Align(
                  child:  Text(
                    'Lookup',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.center,
                ),
              ),
              Divider(
                height: 8,
              ),

              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationLookupPage('')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: const Text(
                        'Location Lookup',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(color: Colors.black),
              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SkuLookupPage('')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: const Text(
                        'SKU Lookup',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(color: Colors.black),
              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InventoryLookupPage('')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: const Text(
                        'IMEI Lookup',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(color: Colors.black),
              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderSearchPage('')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: const Text(
                        'Fulfillment Lookup',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(color: Colors.black),
              SizedBox(
                height: 20,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartonLookupPage('')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: const Text(
                        'Carton Lookup',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
              Divider(color: Colors.black),
              Visibility(
                visible: visibleCompany,
                child: SizedBox(
                  height: 20,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeCompanyPage('')),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 5),
                        child: const Text(
                          'Change Company',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal),
                        ),
                      )),
                ),
              ),
              Divider(color: Colors.black),
              const Padding(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Ver: '),
                    Text(
                      '1.0.2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 35,),
                    const FaIcon(
                      FontAwesomeIcons.wifi,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(width: 35,),
                    const FaIcon(
                      FontAwesomeIcons.bluetooth,
                      color: Colors.black,
                      size: 20,
                    ),
                  ],
                ),
              ),
              /*Padding(
                padding: EdgeInsets.only(left: 15, top: 5),
                child: Row(
                  children: <Widget>[
                    Text('Wifi: '),
                    Text(
                      _connectionStatus,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BluetoothDemo()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                    child: Row(
                      children: <Widget>[
                        Text('Bluetooth: '),
                        Text(
                          bluetoothDeviceName!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.black,
                          size: 14,
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  )),*/
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: ListTile(
                  minLeadingWidth: 2,
                  leading: const FaIcon(
                    FontAwesomeIcons.lock,
                    color: Colors.black,
                    size: 16,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    _showMyDialog();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to logout from app?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage('')),
                );
                // exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  void getUserInfo() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    userType = myPrefs.getString("userType")!;
    try {
      bluetoothDeviceName = myPrefs.getString("bluetoothDevice")!;
    } catch (e) {
      bluetoothDeviceName = 'Connect Bluetooth Device.';
    }
    setState(() {
      userName = myPrefs.getString("userName")!;
      companyLogo = myPrefs.getString("companyLogo")!;
      if (userType == "LANGlobal") {
        visibleCompany = true;
      } else {
        visibleCompany = false;
      }
      print(userName);
      print(companyLogo);
    });
  }

  Widget buildCoverImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(companyLogo),
      );

  Widget buildProfileImage() => Container(
        color: Colors.white,
        child: Image.network(
          companyLogo,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            return Center(child: child);
          },
        ),
      );
}
//Copyrights © 2022 | All Rights Reserved by Department of Finance.\n
