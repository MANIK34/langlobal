import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/locationLookup/locationLookupDetailPage.dart';
import 'package:langlobal/warehouseAllocation/skuLookup/skuLookupDetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkuLookupPage extends StatefulWidget {
  String heading = '';

  SkuLookupPage(this.heading, {Key? key}) : super(key: key);

  @override
  _SkuLookupPage createState() => _SkuLookupPage(this.heading);
}

enum SingingCharacter { SKU, Model }

class _SkuLookupPage extends State<SkuLookupPage> {
  String heading = '';

  _SkuLookupPage(this.heading);

  SingingCharacter? _character = SingingCharacter.SKU;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController fromDateInput = TextEditingController();
  TextEditingController toDateInput = TextEditingController();
  String filterType = "";
  String labelText="SKU";
  BuildContext? _context;
  @override
  void initState() {
    // TODO: implement initState
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
        maxLength: 40,
        controller: memoController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if (memoController.text.toString() == "") {
            _showToast("SKU can't be empty");
          } else {
            buildShowDialog(context);
            callGetSkuApi();
          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          alignLabelWithHint: true,
          hintText: labelText,
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
          if (memoController.text.toString() == "") {
            _showToast("SKU can't be empty");
          } else {
            buildShowDialog(context);
            callGetSkuApi();
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
            children: [
              const Text(
                'SKU Lookup',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              ExpandTapWidget(
                tapPadding: EdgeInsets.all(55.0),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage('')),
                  );
                },
                child: /*const Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),*/
                GestureDetector(
                    child: Container(
                        width: 85,
                        height: 80,
                        child: Center(
                          child: ElevatedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
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
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 120,
                            child: ListTile(
                              horizontalTitleGap: 2,
                              title: const Text('SKU'),
                              leading: Radio<SingingCharacter>(
                                value: SingingCharacter.SKU,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    labelText="SKU";
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 150,
                            child:  ListTile(
                              horizontalTitleGap: 2,
                              title: const Text('Model#'),
                              leading: Radio<SingingCharacter>(
                                value: SingingCharacter.Model,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    labelText="Model#";
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ),

                        ],
                      ),
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
  void callGetSkuApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");
    String searchBy="";
    if(labelText=="SKU"){
      searchBy="sku";
    }else{
      searchBy="modelnumber";
    }
    var url = "https://api.langlobal.com/inventory/v1/Customers/"+companyID!+"?"+searchBy+"="+memoController.text.toString();
    print("url ::::: "+url);
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var response =
    await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SkuLookupDetailPage(jsonResponse),
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
