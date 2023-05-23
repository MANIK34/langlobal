import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabPage extends StatefulWidget {
  var fulfillmentInfo;

  TabPage(this.fulfillmentInfo, {Key? key}) : super(key: key);

  @override
  _TabPage createState() => _TabPage(fulfillmentInfo);
}

class _TabPage extends State<TabPage> {
  var fulfillmentInfo;

  _TabPage(this.fulfillmentInfo);
   var customerInfo;
   String orderDate = "";
   String shipmentDate="";

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

    customerInfo=fulfillmentInfo['customer'];
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: false,
            child: Padding(
              padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child:  Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[
                        orderInfo(),
                        Padding(padding: EdgeInsets.only(left: 10,right: 10),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Customer Information',
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
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Name:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(fulfillmentInfo['customer']['fullName'],style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Address:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(fulfillmentInfo['customer']['address'],style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10,right: 10,),
                                  child:  Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  const Text(
                                                    'City: ',
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  Text(
                                                    fulfillmentInfo['customer']['city'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  const Text(
                                                    ' I ',
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  const Text(
                                                    'State: ',
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                  Text(
                                                    fulfillmentInfo['customer']['state'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),

                                    ],
                                  ),),
                                Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Zip:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(fulfillmentInfo['customer']['zip'],style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),),

                        Padding(padding: EdgeInsets.only(left: 10,right: 10),
                            child: Column(
                              children: <Widget>[
                                  Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Comments: "+fulfillmentInfo['comments'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            )),

                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
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
                          Text(orderDate, style:
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
