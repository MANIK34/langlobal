import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities.dart';
import '../shipment/shipmentSubmit.dart';

class ShipmentPage extends StatefulWidget {
  var fulfillmentInfo;

  ShipmentPage(this.fulfillmentInfo, {Key? key}) : super(key: key);

  @override
  _ShipmentPage createState() => _ShipmentPage(fulfillmentInfo);
}

class _ShipmentPage extends State<ShipmentPage> {
  var fulfillmentInfo;

  _ShipmentPage(this.fulfillmentInfo);

  int listIndex = 0;
  String orderDate = "";
  String shipmentDate = "";
  bool _isDetailView = false;
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  BuildContext? _context;
  var trackingId;
  Utilities _utilities = Utilities();
  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();

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
    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 80,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () {
          if(!Utilities.ActiveConnection){
            _showToast("No internet connection found!");
          }else{
            callDocumentPrintApi("");
          }
        },
        child: Text("Print Label",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final backToListing = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 80,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () {
          setState(() {
            _isDetailView = false;
          });
        },
        child: Text("Back to Listing",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final generateLabels = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.blueGrey,
      child: MaterialButton(
        minWidth: 100,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShipmentSubmitPage(fulfillmentInfo)),
          );
        },
        child: Text("Generate Labels",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      bottomSheet: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(visible: !_isDetailView, child: generateLabels),
            Visibility(
              visible: _isDetailView,
              child: Row(
                children: <Widget>[
                  submitButton,
                  SizedBox(
                    width: 10,
                  ),
                  backToListing,
                ],
              ),
            )
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
                                    'Shipment:',
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
                                Visibility(
                                  visible: !_isDetailView,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1, //<-- SEE HERE
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                const SizedBox(
                                                  width: 45,
                                                  child: Text("S.No",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text("Ship Via:",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text("Tracking#",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Spacer(),
                                                const SizedBox(
                                                  child: Text("Ship\nDate",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 0, right: 0),
                                            child: Container(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                primary: false,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    fulfillmentInfo['shipments']
                                                        .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int indexx) {
                                                  orderDate = fulfillmentInfo[
                                                          'shipments'][indexx]
                                                      ['shipDate'];
                                                  orderDate = orderDate
                                                      .toString()
                                                      .substring(0, 10);
                                                  DateTime tempDate =
                                                      new DateFormat(
                                                              "yyyy-MM-dd")
                                                          .parse(orderDate);
                                                  DateFormat formatter =
                                                      DateFormat('MM/dd/yyyy');
                                                  orderDate = formatter
                                                      .format(tempDate);
                                                  return Container(
                                                    color: indexx % 2 == 0
                                                        ? Color(0xffd3d3d3)
                                                        : Colors.white,
                                                    height: 35,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 35,
                                                          child: Text(
                                                            (indexx + 1)
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                              fulfillmentInfo['shipments']
                                                                          [
                                                                          indexx]
                                                                      [
                                                                      'shipVia']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      10)),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _isDetailView =
                                                                  true;
                                                            });
                                                            trackingId = fulfillmentInfo[
                                                                            'shipments']
                                                                        [indexx]
                                                                    [
                                                                    'trackingId']
                                                                .toString();
                                                          },
                                                          child: SizedBox(
                                                            width: 90,
                                                            child: Text(
                                                                fulfillmentInfo['shipments']
                                                                            [
                                                                            indexx]
                                                                        [
                                                                        'trackingNumber']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    fontSize:
                                                                        10)),
                                                          ),
                                                        ),
                                                        SizedBox(width: 6,),
                                                        SizedBox(
                                                            child: Text(
                                                                orderDate,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        10))),

                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Visibility(
                            visible: _isDetailView,
                            child: shipDetailInfo(listIndex)),
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

  Widget shipDetailInfo(int index) {
    return (Padding(
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
              height: 10,
            ),
            Text(
              fulfillmentInfo['shipments'][index]['trackingNumber'].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: <Widget>[
                  Text('Ship Via:'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                      fulfillmentInfo['shipments'][index]['shipVia'].toString(),
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
                  Text('Package:'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                      fulfillmentInfo['shipments'][index]['package'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 5,
                  ),
                  Spacer(),
                  Text('Weight (Oz):'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(fulfillmentInfo['shipments'][index]['weight'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Price: ',
                    style: TextStyle(),
                  ),
                  Text(
                    "\$" +
                        fulfillmentInfo['shipments'][index]['price'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Spacer(),
                  Text('Ship Date:'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(orderDate,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 15,
                  ),
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
                            'Carrier: ',
                            style: TextStyle(),
                          ),
                          Text(
                            fulfillmentInfo['shipments'][index]['carrier']
                                .toString(),
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
    ));
  }

  void callDocumentPrintApi(String fileName) async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    String? companyName = myPrefs.getString("companyName");
    // String? fileName = myPrefs.getString("companyLogo");
    var url = "https://api.langlobal.com/fulfillment/v1/Shipment/" +
        trackingId.toString();
    print("URL :::: "+url.toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode = jsonResponse['returnCode'];
        if (returnCode == "1") {
          print("jsonResponse :::: " + jsonResponse.toString());
          var base64Image = jsonResponse['base64String'];
          Uint8List bytx = Base64Decoder().convert(base64Image);
          await Printing.layoutPdf(onLayout: (_) => bytx);
        } else {
          _showToast("No Label Found!");
        }
      } catch (e) {
        print('returnCode' + e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    Navigator.of(_context!).pop();
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
