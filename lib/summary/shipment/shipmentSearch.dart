import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/summary/fulfillment/salesOrderPage.dart';
import 'package:langlobal/summary/shipment/shipmentSubmit.dart';
import 'package:langlobal/summary/shipment/trackingDetail.dart';
import 'package:langlobal/utilities.dart';
import 'package:flutter/services.dart';

import '../../dashboard/DashboardPage.dart';

class ShipmentSearchPage extends StatefulWidget {
  String heading = '';

  ShipmentSearchPage(this.heading, {Key? key}) : super(key: key);

  @override
  _ShipmentSearchPage createState() =>
      _ShipmentSearchPage(this.heading);
}

class _ShipmentSearchPage extends State<ShipmentSearchPage> {
  String heading = '';

  _ShipmentSearchPage(this.heading);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController skuController = TextEditingController();


  TextEditingController fromDateInput = TextEditingController();
  TextEditingController toDateInput = TextEditingController();
  var trackingInfo;
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

    final memoField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        maxLength: 30,
        controller: memoController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if(memoController.text.toString()==""){
            _showToast("Tracking Number can't be empty");
          }else{
            setState(() {
              _isLoading = true;
            });
            callShipmentSearchApi();

          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Tracking Number",
          alignLabelWithHint: true,
          hintText: "Tracking Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(memoController.text.toString()==""){
            _showToast("Tracking Number can't be empty");
          }else{
            setState(() {
              _isLoading = true;
            });
            callShipmentSearchApi();
          }
        },
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final newShipmentButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShipmentSubmitPage(null,true)),
          );
        },
        child: Text("New Shipment Label",
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
              const Text('Shipment Label Lookup',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
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
                memoField,
                const SizedBox(height: 60.0),
                submitButton,
                const SizedBox(
                  height: 15.0,
                ),
                newShipmentButton
              ],
            ),
          ),
        ));
  }

  void callShipmentSearchApi() async {
    //https://api.langlobal.com/shipment/v1/trackinginfo/449044304137821
    var url = Utilities.baseUrl!+"shipment/v1/trackinginfo/"+memoController.text.toString();
    print("trackinginfo URL  >> "+url);
    Map<String, String> headers = {
      'Authorization': 'Bearer ${Utilities.token}'
    };

    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        trackingInfo= jsonResponse['trackingInfo'];
        print('returnCode'+ returnCode.toString());
        if(returnCode=="1"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrackingDetailPage(trackingInfo,)),
          );
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
}
