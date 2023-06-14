import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/model/requestParams/cartonProvisioning.dart';
import 'package:langlobal/summary/fulfillment/provisioning/lineItem.dart';
import 'package:langlobal/summary/fulfillment/provisioning/nonSerializedInventoryPage.dart';
import 'package:langlobal/summary/fulfillment/provisioning/serializedInventory.dart';
import 'package:langlobal/summary/fulfillment/provisioning/confirmationPage.dart';
import 'package:langlobal/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/requestParams/imeIsList.dart';
import '../salesOrderPage.dart';

class ConfirmationPage extends StatefulWidget {
  var fulfillmentInfo;

  ConfirmationPage(this.fulfillmentInfo, {Key? key}) : super(key: key);

  @override
  _ConfirmationPage createState() => _ConfirmationPage(this.fulfillmentInfo);
}

class _ConfirmationPage extends State<ConfirmationPage> {
  var fulfillmentInfo;

  _ConfirmationPage(this.fulfillmentInfo);

  String orderDate = "";
  String shipmentDate = "";
  bool _isLoading = false;
  String dummy = "";
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  BuildContext? _context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderDate = fulfillmentInfo['fulfillmentDate'];
    orderDate = orderDate.toString().substring(0, 10);
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(orderDate);
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    orderDate = formatter.format(tempDate);

    shipmentDate = fulfillmentInfo['requestedShipDate'];
    shipmentDate = shipmentDate.toString().substring(0, 10);
    tempDate = new DateFormat("yyyy-MM-dd").parse(shipmentDate);
    formatter = DateFormat('MM/dd/yyyy');
    shipmentDate = formatter.format(tempDate);
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
    final backToLookup = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 200,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          callProvisoningApi();
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            backToLookup,
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fulfillment Provisioning',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
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
                            MaterialPageRoute(
                                builder: (context) =>
                                    SalesOrderPage(fulfillmentInfo)),
                          );
                        },
                      ),
                    )),
                onTap: () {
                  Navigator.of(context).pop();
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
                        orderInfo(),
                        Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Line Items:',
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
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 45,
                                        child: Text("S.No",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(
                                        width: 100,
                                        child: Text("Sku#",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Spacer(),
                                      Text("Ordered\nQty",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("Assigned\nQty",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0, right: 0),
                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          fulfillmentInfo['lineItems'].length,
                                      itemBuilder:
                                          (BuildContext context, int indexx) {
                                        return Container(
                                          color: indexx % 2 == 0
                                              ? Color(0xffd3d3d3)
                                              : Colors.white,
                                          height: 30,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 35,
                                                child: Text(
                                                  (indexx + 1).toString(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 22,
                                              ),
                                              SizedBox(
                                                  width: 200,
                                                  child: GestureDetector(
                                                    child: Text(fulfillmentInfo['lineItems'][indexx]['sku'].toString(),
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            color: Colors.blue,
                                                            fontSize: 13)),
                                                    onTap: () {
                                                      if (fulfillmentInfo[
                                                                  'lineItems']
                                                              [indexx]
                                                          ['isESNRequired']) {
                                                         Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => SerializedInventoryPage(fulfillmentInfo,indexx)),
                                                        );
                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NonSerializedInventoryPage(
                                                                      fulfillmentInfo,
                                                                      indexx)),
                                                        );
                                                      }
                                                    },
                                                  )),
                                              Text(
                                                  fulfillmentInfo['lineItems']
                                                          [indexx]['qty']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13)),
                                              Spacer(),
                                              Text(
                                                  fulfillmentInfo['lineItems']
                                                              [indexx]
                                                          ['assignedQty']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13)),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget orderInfo() {
    return (Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fulfillmentInfo['orderType'],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                fulfillmentInfo['fulfillmentNumber'],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                fulfillmentInfo['orderStatus'],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Divider(
            thickness: 4,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                      Text('Customer Order:'),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(fulfillmentInfo['customerOrderNumber'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
                      Text('Order Date:'),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(orderDate,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              const Text(
                                'Req. Shipment Date: ',
                                style: TextStyle(),
                              ),
                              Text(
                                shipmentDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
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
      ],
    ));
  }

  void callProvisoningApi() async {
    buildShowDialog(context);
    List<ImeiList> ImeisList = <ImeiList>[];
    var jsonstringmap;
    if(Utilities.ImeisList.length>0){
      for (int i = 0; i < Utilities.ImeisList.length; i++) {
        ImeiList obj = ImeiList(
          imei: Utilities.ImeisList[i].imei,
          itemCompanyGUID: Utilities.ImeisList[i].itemCompanyGUID,
          trackingNumber: Utilities.ImeisList[i].trackingNumber,
        );
        ImeisList.add(obj);
      }
      var _cartonList = ImeisList.map((e) {
        return {
          "imei": e.imei,
          "itemCompanyGUID": e.itemCompanyGUID,
          "trackingNumber": e.trackingNumber
        };
      }).toList();
      jsonstringmap = json.encode(_cartonList);
      print("_cartonList$jsonstringmap");
    }

    var jsonstringmap2;
    List<CartonProvisioningList> cartonProList= <CartonProvisioningList>[];
    if(Utilities.cartonProList.length>0){
      for (int i = 0; i < Utilities.cartonProList.length; i++) {
        CartonProvisioningList obj= CartonProvisioningList(cartonID: Utilities.cartonProList[i].cartonID,
            assignedQty: Utilities.cartonProList[i].assignedQty, itemCompanyGUID:  Utilities.cartonProList[i].itemCompanyGUID,
            quantity: Utilities.cartonProList[i].quantity,warehouseLocation: "",trackingNumber: Utilities.cartonProList[i].trackingNumber);
        cartonProList.add(obj);
      }
      var _cartonList2 = cartonProList.map((e){
        return {
          "cartonID": e.cartonID,
          "assignedQty": e.assignedQty,
          "itemCompanyGUID": e.itemCompanyGUID,
          "quantity": e.quantity,
          "warehouseLocation": e.warehouseLocation,
          "trackingNumber": e.trackingNumber
        };
      }).toList();
      jsonstringmap2 = json.encode(_cartonList2);
      print("_cartonList2$jsonstringmap2");
    }

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");

    var url = "https://api.langlobal.com/fulfillment/v1/provisoning";

    var body = json.encode({
      "source": "Mobile",
      "companyID": companyID!,
      "poid": fulfillmentInfo['fulfillmentID'],
      "userID": userID,
      "imeIs": jsonstringmap,
      "cartons": jsonstringmap2,
    });
    body = body.replaceAll("\"[", "[");
    body = body.replaceAll("]\"", "]");
    body = body.replaceAll("\\\"", "\"");
    print("StockInHandPage$body");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    print("requestParams$body");
    var response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {

      var jsonResponse = json.decode(response.body);

      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
          print("Submitted.......");
          Utilities.ImeisList = [];
          Utilities.cartonProList = [];
          Navigator.of(_context!).pop();
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LineItemPage(fulfillmentInfo, false)),
          );
        } else {
          Navigator.of(_context!).pop();
          _showToast(jsonResponse['returnMessage']);
        }

      } catch (e) {
        Navigator.of(_context!).pop();
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    debugPrint(response.body);
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
}
