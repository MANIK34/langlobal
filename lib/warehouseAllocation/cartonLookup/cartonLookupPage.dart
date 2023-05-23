import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/warehouseAllocation/cartonLookup/cartonLookupDetailPage.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CartonLookupPage extends StatefulWidget {
  String heading = '';

  CartonLookupPage(this.heading, {Key? key}) : super(key: key);

  @override
  _CartonLookupPage createState() =>
      _CartonLookupPage(this.heading);
}

class _CartonLookupPage extends State<CartonLookupPage> {
  String heading = '';

  _CartonLookupPage(this.heading);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController skuController = TextEditingController();


  TextEditingController fromDateInput = TextEditingController();
  TextEditingController toDateInput = TextEditingController();

 // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
 // BluetoothDevice? _device;
  String tips = 'no device connect';
  String? base64Image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDateInput.text = "";
    toDateInput.text = "";
   // WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  /*Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected=await bluetoothPrint.isConnected??false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {

    final cartonIdField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        maxLength: 20,
        controller: memoController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if(memoController.text.toString()==""){
            _showToast("Carton Id can't be empty");
          }else{
            setState(() {
              _isLoading = true;
            });
            callGetCartonLookupApi(false);
          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Carton ID",
          alignLabelWithHint: true,
          hintText: "Carton ID",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));


    final searchButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          /*StreamBuilder<bool>(
            stream: bluetoothPrint.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data == true) {
                return FloatingActionButton(
                  child: Icon(Icons.stop),
                  onPressed: () => bluetoothPrint.stopScan(),
                  backgroundColor: Colors.red,
                );
              } else {
                return FloatingActionButton(
                    child: Icon(Icons.search),
                    onPressed: () => bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
              }
            },
          );*/
          if(memoController.text.toString()==""){
            _showToast("Carton ID can't be empty");
          }else{
            setState(() {
              _isLoading = true;
            });
            callGetCartonLookupApi(false);
          }
        },
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final printButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(memoController.text.toString()==""){
            _showToast("Carton ID can't be empty");
          }else{
            setState(() {
              _isLoading = true;
            });
            callGetCartonLookupApi(true);
          }
        },
        child: Text("Print",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text('Carton Lookup',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
              ),
              /*ExpandTapWidget(
                tapPadding: EdgeInsets.all(55.0),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage('')),
                  );
                },
                child: const Text('Cancel',textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
                ),
              )*/

              GestureDetector(
                  child: Container(
                      width: 85,
                      height: 80,
                      child: Center(
                        child: ElevatedButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DashboardPage('')),
                            );
                          },
                        ),
                      )),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage('')),
                    );
                  }),
            ],
          ),
        ),
        drawer: DrawerElement(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 10, 36.0, 0.0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 15.0,
                ),
                cartonIdField,
                const SizedBox(height: 60.0),
                searchButton,
                const SizedBox(
                  height: 15.0,
                ),
                Text('OR'),
                const SizedBox(
                  height: 15.0,
                ),
                printButton
              ],
            ),
          ),
        ));
  }

  void callGetCartonLookupApi(bool isPrint) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    var url;
    if(!isPrint){
      url = "https://api.langlobal.com/inventoryallocation/v1/cartonlookup/"+
          memoController.text.toString();
    }else{
      url = "https://api.langlobal.com/inventoryallocation/v1/cartonlookup/"+
          memoController.text.toString()+"?action=print";
    }
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
          if(isPrint){
            var base64Image=jsonResponse['base64String'];
            Uint8List bytx=Base64Decoder().convert(base64Image);
            await Printing.layoutPdf(onLayout: (_) => bytx);
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartonLookupDetailPage(jsonResponse['cartonContent'])),
            );
          }
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    debugPrint(response.body);
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
  }

  void showBluetoothPrinterDialog() async{
    /*showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.only(
                    topRight: Radius
                        .circular(
                        50.0),
                    topLeft: Radius
                        .circular(
                        50.0))),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .center,
              mainAxisSize:
              MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 30,),
                const Text(
                  'Select Bluetooth Device',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold,
                      color:
                      Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!.map((d) => ListTile(
                      title: Text(d.name??''),
                      subtitle: Text(d.address??''),
                      onTap: () async {
                        setState(() {
                          _device = d;
                          connectDevice();
                          print(_device?.name);
                          Navigator.of(context).pop();
                        });
                      },
                    )).toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          floatingActionButton: StreamBuilder<bool>(
            stream: bluetoothPrint.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data == true) {
                return FloatingActionButton(
                  child: Icon(Icons.stop),
                  onPressed: () => bluetoothPrint.stopScan(),
                  backgroundColor: Colors.red,
                );
              } else {
                return FloatingActionButton(
                    child: Icon(Icons.search),
                    onPressed: () => bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
              }
            },
          ),
        );
      },
    );*/
  }

 /* void connectDevice() async{
    await bluetoothPrint.connect(_device!);
    if(_connected){
      Map<String, dynamic> config = Map();
      List<LineText> list = [];
      ByteData data = await rootBundle.load("assets/images/bluetooth_print.png");
      List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      //String base64Image = base64Encode(imageBytes);
      list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));
      await bluetoothPrint.printReceipt(config, list);
    }else{
      _showToast("Device is not connected!");
    }
  }*/
}
