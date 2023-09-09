import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:langlobal/model/requestParams/shipmentToInfo.dart';
import 'package:langlobal/summary/shipment/shipmentLookup.dart';
import 'package:langlobal/summary/shipment/shipmentSubmit2.dart';
import 'package:langlobal/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/DashboardPage.dart';
import '../../model/requestParams/shipmentFromInfo.dart';

class ShipmentSubmitPage extends StatefulWidget {

  var fulfillmentInfo;
  var isNewLabel;
  ShipmentSubmitPage(this.fulfillmentInfo,this.isNewLabel, {Key? key})
      : super(key: key);

  @override
  _ShipmentSubmitPage createState() =>
      _ShipmentSubmitPage(this.fulfillmentInfo,this.isNewLabel);
}

class _ShipmentSubmitPage extends State<ShipmentSubmitPage> {

  var fulfillmentInfo;
  var isNewLabel;
  _ShipmentSubmitPage(this.fulfillmentInfo,this.isNewLabel);

  String orderDate = "";
  String shipmentDate = "";
  bool _isLoading = false;
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', color: Colors.black);
  List<String> shipViaList = [];
  late String? _shipViaList = null;
  String shipVia = "";

  List<String> packageList = [];
  late String? _packageList = null;
  String package = "";

  BuildContext? _context;
  TextEditingController weightController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  TextEditingController fullNameController1 = TextEditingController();
  TextEditingController addressController1 = TextEditingController();
  TextEditingController cityController1 = TextEditingController();
  TextEditingController zipController1 = TextEditingController();
  TextEditingController stateController1 = TextEditingController();

  Utilities _utilities = Utilities();

  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();

    super.initState();
    shipViaList.add('Select ship via');
    packageList.add('Select package');
    try{
      fullNameController1.text=fulfillmentInfo['customer']['fullName'];
      addressController1.text=fulfillmentInfo['customer']['address']+fulfillmentInfo['customer']['address2'];
      cityController1.text=fulfillmentInfo['customer']['city'];
      zipController1.text=fulfillmentInfo['customer']['zip'];
      stateController1.text=fulfillmentInfo['customer']['state'];
    }catch(e){

    }

    if(!Utilities.ActiveConnection){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _showToast('No internet connection found!');
      });
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        buildShowDialog(context);
      });
      callGetShipViaApi();
    }
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

  @override
  Widget build(BuildContext context) {
    final shipViaDropdown = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Select Ship Via",
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 26.0,
          isExpanded: true,
          value: _shipViaList,
          onChanged: (value) {
            setState(() {
              _shipViaList = value!;
              shipVia = value!;
            });
          },
          items: shipViaList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(
                map,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );

    final packageDropdown = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Select Package",
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 26.0,
          isExpanded: true,
          value: _packageList,
          onChanged: (value) {
            setState(() {
              _packageList = value!;
              package = value!;
            });
          },
          items: packageList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(
                map,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
    final submit = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }else{
            callShipmentLabelApi();
          }
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final weightField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: weightController,
        style: style,
        textAlign: TextAlign.left,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Weight",
          alignLabelWithHint: true,
          hintText: "Weight",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));


    final fullNameField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],

        controller: fullNameController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Full Name",
          alignLabelWithHint: true,
          hintText: "Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
    final addressField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: addressController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Address",
          alignLabelWithHint: true,
          hintText: "Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
    final cityField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: cityController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "City",
          alignLabelWithHint: true,
          hintText: "City",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final zipField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: zipController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Zip",
          alignLabelWithHint: true,
          hintText: "Zip",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
    final stateField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: stateController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "State",
          alignLabelWithHint: true,
          hintText: "State",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));



    final fullNameField1 = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],

        controller: fullNameController1,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Full Name",
          alignLabelWithHint: true,
          hintText: "Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
    final addressField1 = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: addressController1,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Address",
          alignLabelWithHint: true,
          hintText: "Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
    final cityField1 = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: cityController1,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "City",
          alignLabelWithHint: true,
          hintText: "City",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final zipField1 = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: zipController1,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Zip",
          alignLabelWithHint: true,
          hintText: "Zip",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
    final stateField1 = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: stateController1,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {

        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "State",
          alignLabelWithHint: true,
          hintText: "State",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));


    return Scaffold(
      /*bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            backToLookup,

          ],
        ),
      ),*/
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Shipment Label',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
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
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: false,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                  height: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: SizedBox(
                                      height: 40,
                                      child: shipViaDropdown,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: SizedBox(
                                      height: 40,
                                      child: packageDropdown,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
                                    child: SizedBox(
                                      height: 45,
                                      child: weightField,
                                    )),
                              ],
                            ),
                          ),),
                        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1, //<-- SEE HERE
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Ship From: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),),
                                Divider(
                                  thickness: 2,
                                  color: Colors.black,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: SizedBox(
                                      height: 45,
                                      child: fullNameField,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: SizedBox(
                                      height: 45,
                                      child: addressField,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(width: 200,
                                        child: SizedBox(
                                          height: 45,
                                          child: cityField,
                                        ),),
                                        const SizedBox(width: 5,),
                                        SizedBox(width: 100,
                                          child: SizedBox(
                                            height: 45,
                                            child: zipField,
                                          ),),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
                                    child: SizedBox(
                                      height: 45,
                                      child: stateField,
                                    )),
                              ],
                            ),
                          ),),
                        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1, //<-- SEE HERE
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Ship To: ',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),),
                                Divider(
                                  thickness: 2,
                                  color: Colors.black,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child:  SizedBox(
                                      height: 45,
                                      child: fullNameField1,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child:  SizedBox(
                                      height: 45,
                                      child: addressField1,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(width: 200,
                                          child: SizedBox(
                                            height: 45,
                                            child: cityField1,
                                          ),),
                                        const SizedBox(width: 5,),
                                        SizedBox(width: 100,
                                          child:  SizedBox(
                                            height: 45,
                                            child: zipField1,
                                          ),),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
                                    child:  SizedBox(
                                      height: 45,
                                      child: stateField1,
                                    )),
                              ],
                            ),
                          ),),
                        Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10,top: 10,bottom: 40),
                            child: submit),

                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
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


  void callGetShipViaApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    String? companyName = myPrefs.getString("companyName");
    // String? fileName = myPrefs.getString("companyLogo");
    var url = "https://api.langlobal.com/common/v1/shipvia";
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      for(int m=0;m<jsonResponse.length;m++){
        shipViaList.add(jsonResponse[m]['shipByText']);
      }
    } else {
      print(response.statusCode);
    }
    callGetPackagesApi();
    debugPrint("Ship Via:"+response.body);
  }

  void callGetPackagesApi() async {

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    String? companyName = myPrefs.getString("companyName");
    var url = "https://api.langlobal.com/common/v1/Packages?IsNational=false&carrierName=fedex";
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      for(int m=0;m<jsonResponse.length;m++){
        packageList.add(jsonResponse[m]['shipShapeValue']);
      }
    } else {
      print(response.statusCode);
    }

    debugPrint("Packages:"+response.body);
    callGetShipmentInfoApi();
  }

  void callGetShipmentInfoApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    var url = "https://api.langlobal.com/common/v1/shipmentinfo";
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      addressController.text=jsonResponse['shipmentAddress']['shipFromAddress'];
      cityController.text=jsonResponse['shipmentAddress']['shipFromCity'];
      zipController.text=jsonResponse['shipmentAddress']['shipFromZip'];
      stateController.text=jsonResponse['shipmentAddress']['shipFromState'];
      try{
        fullNameController.text=jsonResponse['shipmentAddress']['shipFromContactName'];
      }catch (e) {
      }

    } else {
      print(response.statusCode);
    }
    Navigator.of(_context!).pop();
    debugPrint("Packages:"+response.body);
    setState(() {

    });
  }

  void callShipmentLabelApi() async {
    buildShowDialog(context);

    ShipmentFromInfo fromInfo = ShipmentFromInfo(shipFromAddress: addressController.text.toString(),
    shipFromCity: cityController.text.toString(),shipFromContactName: fullNameController.text.toString(),
    shipFromCountry: "USA",shipFromPhone: "",shipFromState: stateController.text.toString(),
    shipFromZip: zipController.text.toString());

    ShipmentToInfo toInfo = ShipmentToInfo(contactName: fullNameController1.text.toString(),
    contactPhone: "",shipToAddress2: addressController1.text.toString(),
    shipToAddress: addressController1.text.toString(),shipToAttn: "",shipToCity: cityController1.text.toString(),
    shipToState: stateController1.text.toString(),shipToZip: zipController1.text.toString());

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");

    var url = "https://api.langlobal.com/fulfillment/v1/ShipmentLabel";
    var body;
    if(isNewLabel){
      body = json.encode({
        "fulfillmentNumber": '',
        "customerName": '',
        "shipVia": shipVia,
        "shipPackage": package,
        "weight": weightController.text.toString(),
        "poid": 0,
        "userId": userID!,
        "companyID": companyID!,
        "shipmentFromInfo": fromInfo,
        "shipmentToInfo": toInfo,
        "labelType":'custom'

      });
    }else{
      body = json.encode({
        "fulfillmentNumber": fulfillmentInfo['fulfillmentNumber'],
        "customerName": fulfillmentInfo['customer']['fullName'],
        "shipVia": shipVia,
        "shipPackage": package,
        "weight": weightController.text.toString(),
        "poid": fulfillmentInfo['fulfillmentID'],
        "userId": userID!,
        "companyID": companyID!,
        "shipmentFromInfo": fromInfo,
        "shipmentToInfo": toInfo,
        "labelType":'fulfillment'
      });
    }

    body = body.replaceAll("\"[", "[");
    body = body.replaceAll("]\"", "]");
    body = body.replaceAll("\\\"", "\"");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    print("requestParams$body");
    var response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var returnCode = jsonResponse['returnCode'];
      if (returnCode == "1") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShipmentLookup(fulfillmentInfo)),
        );
      }else{
        _utilities.callAppErrorLogApi(response.body.toString(),"ShipmentSubmit.dart","callShipmentLabelApi");
      }

    } else {
      print(response.statusCode);
    }
    Navigator.of(_context!).pop();
    debugPrint(response.body);
  }
}


