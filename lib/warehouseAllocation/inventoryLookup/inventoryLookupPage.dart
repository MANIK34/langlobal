import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/locationLookup/locationLookupDetailPage.dart';
import 'package:langlobal/warehouseAllocation/inventoryLookup/inventoryLookupDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities.dart';

class InventoryLookupPage extends StatefulWidget {
  String heading = '';

  InventoryLookupPage(this.heading, {Key? key}) : super(key: key);

  @override
  _InventoryLookupPage createState() =>
      _InventoryLookupPage(this.heading);
}

class _InventoryLookupPage extends State<InventoryLookupPage> {
  String heading = '';

  _InventoryLookupPage(this.heading);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController fromDateInput = TextEditingController();
  TextEditingController toDateInput = TextEditingController();
  BuildContext? _context;

  Utilities _utilities = Utilities();

  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();

    super.initState();
    fromDateInput.text = "";
    toDateInput.text = "";
  }

  @override
  Widget build(BuildContext context) {

    final cartonIdField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        maxLength: 20,
        controller: memoController,
        style: style,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if(memoController.text.toString()==""){
            _showToast("IMEI can't be empty");
          }else if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }
          else{
            buildShowDialog(context);
            callGetIMEISApi();
          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "IMEI",
          alignLabelWithHint: true,
          hintText: "IMEI",
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
          if(memoController.text.toString()==""){
            _showToast("IMEI can't be empty");
          }else if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }
          else{
            buildShowDialog(context);
            callGetIMEISApi();
          }
        },
        child: Text("Search",
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
              const Text('Serialized Inventory Lookup',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
              ),
              ExpandTapWidget(
                tapPadding: EdgeInsets.all(55.0),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage('')),
                  );
                },
                child: /*const Text('Cancel',textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
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
                    }),
              )
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
              ],
            ),
          ),
        ));
  }

  void callGetIMEISApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");
    var url = "https://api.langlobal.com/inventory/v1/Customers/IMEIS/"+companyID!+"?esn="+memoController.text.toString();
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var response =
    await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      print(response.body);
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InventoryLookupDetailPage(jsonResponse),
          ));
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print("error message ::"+e.toString());
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(_context!).pop();
      print(response.statusCode);
    }
  }

  buildShowDialog(BuildContext context) {

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context=context;
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
}
