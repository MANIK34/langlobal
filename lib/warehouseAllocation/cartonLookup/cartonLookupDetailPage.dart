import 'dart:convert';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/utilities/testprint.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../dashboard/DashboardPage.dart';
import '../../locationLookup/locationLookupDetailPage.dart';
import '../../utilities.dart';
import '../inventoryLookup/inventoryLookupDetail.dart';
import 'cartonLookupPage.dart';

class CartonLookupDetailPage extends StatefulWidget {
  var cartonContent;

  CartonLookupDetailPage(this.cartonContent, {Key? key}) : super(key: key);

  @override
  _CartonLookupDetailPage createState() =>
      _CartonLookupDetailPage(this.cartonContent);
}

class _CartonLookupDetailPage extends State<CartonLookupDetailPage> {
  var cartonContent;

  _CartonLookupDetailPage(this.cartonContent);

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool autoFocus = false;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  TestPrint testPrint = TestPrint();

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list
  var esnValue;
  bool _visibleImei = false;
  BuildContext? _context;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text = esnValue.toString();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return Text(esnValue.toString());
  }

  Utilities _utilities = Utilities();

  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();
    super.initState();
    var imeiList = cartonContent['imeiList'];
    for (int m = 0; m < imeiList.length; m++) {
      esnValue = imeiList[m]['imei'];
      textFeildList.add(customField());
    }
    if (textFeildList.isNotEmpty) {
      _visibleImei = true;
    }
    initPlatformState();
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
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final printButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }else{
            callGetCartonLookupPrintApi();
          }
        },
        child: Text("Print",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonLookupPage('')),
          );
        },
        child: Text("New Lookup",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Expanded(child: printButton),
            Expanded(child: validateButton),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Carton Lookup',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            /*ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
              ),
            )*/

            const Spacer(),
            GestureDetector(
                child: Image.asset(
                  'assets/icon_back.png',
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                }),
            const SizedBox(width: 20,),
            GestureDetector(
                child:  const FaIcon(
                  FontAwesomeIcons.home,
                  color: Colors.white,
                  size: 16,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardPage('')),
                  );
                }),
          ],
        ),
      ),
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1, //<-- SEE HERE
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Carton ID:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        cartonContent['cartonID'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if(!Utilities.ActiveConnection){
                                            _showToast("No internet connection found!");
                                          }else{
                                            callGetCartonLookupApi(
                                                cartonContent['location']
                                                    .toString());
                                          }

                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Text('Location:'),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                cartonContent['location']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline)),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          cartonContent['locationType']
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Aisle:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['aisle'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Bay:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['bay'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Level:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['level'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Carton Contents',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2.0,
                          color: Colors.black,
                        ),
                       /* Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(width: 10),
                            const Text(
                              'Device:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: DropdownButton(
                                items: _getDeviceItems(),
                                onChanged: (BluetoothDevice? value) =>
                                    setState(() => _device = value),
                                value: _device,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.brown),
                              onPressed: () {
                                initPlatformState();
                              },
                              child: const Text(
                                'Refresh',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      _connected ? Colors.red : Colors.green),
                              onPressed: _connected ? _disconnect : _connect,
                              child: Text(
                                _connected ? 'Disconnect' : 'Connect',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),*/
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1, //<-- SEE HERE
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        cartonContent['category'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        cartonContent['condition'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cartonContent['sku'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        cartonContent['productName'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Visibility(
                                  visible: true,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            const Text('Qty Assigned:'),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              cartonContent['qtyPerCarton']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _visibleImei,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                              child: Column(
                                children: <Widget>[
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'IMEI',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2.0,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: textFeildList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: 30,
                                        color: index % 2 == 0
                                            ? Color(0xffd3d3d3)
                                            : Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "" +
                                                  (index + 1).toString() +
                                                  ". ",
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  if(!Utilities.ActiveConnection){
                                                    _showToast("No internet connection found!");
                                                  }else{
                                                    callGetIMEISApi(
                                                        cartonContent['imeiList']
                                                        [index]['imei']);
                                                  }
                                                },
                                                child: Text(
                                                  cartonContent['imeiList']
                                                      [index]['imei'],
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.blue),
                                                )),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void callGetIMEISApi(String imei) async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");
    var url = "https://api.langlobal.com/inventory/v1/Customers/IMEIS/" +
        companyID! +
        "?esn=" +
        imei;
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      print(response.body);
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InventoryLookupDetailPage(jsonResponse),
              ));
        } else {
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print("error message ::" + e.toString());
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(_context!).pop();
      print(response.statusCode);
    }
  }

  void callGetCartonLookupApi(String location) async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    var url =
        "https://api.langlobal.com/inventoryallocation/v1/locationlookup/" +
            location;
    Map<String, String> headers = {'Authorization': 'Bearer ${token!}'};
    print(url.toString());
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LocationLookupDetailPage(jsonResponse['locationContent'])),
          );
        } else {
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(_context!).pop();
      print(response.statusCode);
    }
    debugPrint(response.body);
  }

  void callGetCartonLookupPrintApi() async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");

    String url = "${Utilities.baseUrl}inventoryallocation/v1/cartonlookup/${cartonContent['cartonID']}?action=print";

    Map<String, String> headers = {'Authorization': 'Bearer ${token!}'};
    print(url.toString());
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
          print("jsonResponse :::: " + jsonResponse.toString());
          var base64Image = jsonResponse['base64String'];
          Uint8List bytx = Base64Decoder().convert(base64Image);
          testPrint.sample(bytx);

        //  await Printing.layoutPdf(onLayout: (_) => bytx);


         /* Uint8List decodedbytes = base64.decode(base64Image);

          String _dataURI = 'data:image/png;base64,' + base64Image;

          UriData? _data = Uri.parse(_dataURI).data;
          Image? _image =
          Image.memory(_data!.contentAsBytes().buffer.asUint8List());

          decodedbytes = _data!.contentAsBytes().buffer.asUint8List(_data!.contentAsBytes().offsetInBytes, _data!.contentAsBytes().lengthInBytes);

          print("image Generated :::: ");*/
        } else {
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    Navigator.of(_context!).pop();
    //  debugPrint(response.body);
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          return const Center(
            child: CircularProgressIndicator(),
          );
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
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    } else {
      show('No device selected.');
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
      ),
    );
  }
}
