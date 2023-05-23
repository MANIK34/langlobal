import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogsPage extends StatefulWidget {

  var fulfillmentInfo;

  LogsPage(this.fulfillmentInfo, {Key? key}) : super(key: key);

  @override
  _LogsPage createState() => _LogsPage(fulfillmentInfo);
}

class _LogsPage extends State<LogsPage> {
  var fulfillmentInfo;

  _LogsPage(this.fulfillmentInfo);

  String orderDate = "";
  String shipmentDate="";
  bool _isLoading = false;
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderDate=fulfillmentInfo['fulfillmentDate'];
    orderDate=orderDate.toString().substring(0,10);
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(orderDate);
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    orderDate = formatter.format(tempDate);

    shipmentDate=fulfillmentInfo['requestedShipDate'];
    shipmentDate=shipmentDate.toString().substring(0,10);
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
        minWidth: 100,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () {},
        child: Text("Print Label",
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
        onPressed: () {},
        child: Text("Generate Labels",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
    /*  bottomSheet: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            generateLabels
          ],
        ) ,
      ),*/
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
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Shipment Status:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("",
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
                                      Text('Ship Via:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Package:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("",
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
                                      Text('Weight (Oz):'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Tracking#:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                'No. of Packages: ',
                                                style: TextStyle(),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Price: ',
                                                style: TextStyle(),
                                              ),
                                              Text(
                                                "",
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
                                SizedBox(
                                  height: 40,
                                  child: submitButton,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  generateLabels
                ],
              ),
            )),
      ),
    );
  }

  Widget orderInfo(){
    return(
        Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fulfillmentInfo['orderType'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    fulfillmentInfo['fulfillemntNumber'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    fulfillmentInfo['orderStatus'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10,0,10,0),
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
                          Text( fulfillmentInfo['customerOrderNumber'],
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
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
                          Text(orderDate,style:
                          TextStyle(fontWeight: FontWeight.bold)),
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
        )
    );
  }
}
