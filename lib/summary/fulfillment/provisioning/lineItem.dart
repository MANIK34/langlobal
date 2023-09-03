import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/summary/fulfillment/provisioning/nonSerializedInventoryPage.dart';
import 'package:langlobal/summary/fulfillment/provisioning/serializedInventory.dart';
import 'package:langlobal/summary/fulfillment/provisioning/confirmationPage.dart';

import '../../../dashboard/DashboardPage.dart';
import '../salesOrderPage.dart';

class LineItemPage extends StatefulWidget {

  var fulfillmentInfo;
  var orderDateTime;

  LineItemPage(this.fulfillmentInfo , this.orderDateTime, {Key? key}) : super(key: key);

  @override
  _LineItemPage createState() => _LineItemPage(this.fulfillmentInfo,this.orderDateTime);
}

class _LineItemPage extends State<LineItemPage> {
  var fulfillmentInfo;
  var orderDateTime;

  _LineItemPage(this.fulfillmentInfo,this.orderDateTime);

  String orderDate = "";
  String shipmentDate="";
  bool _isLoading = false;
  String  dummy="";
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
    final backToLookup = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 100,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SalesOrderPage(fulfillmentInfo)),
          );
        },
        child: Text("Back To Lookup",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final confirmation = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 100,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfirmationPage(fulfillmentInfo)),
          );
        },
        child: Text("Confirmation",
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
            SizedBox(width: 10,),
            Visibility(
              visible: orderDateTime,
              child: confirmation,
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text('Fulfillment Provisioning',textAlign: TextAlign.center,
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
                    MaterialPageRoute(builder: (context) => SalesOrderPage(fulfillmentInfo)),
                  );
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
                                      const SizedBox(
                                        width: 45,
                                        child:   Text("S.No",style: TextStyle(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight
                                                .bold
                                        )),
                                      ),
                                      const SizedBox(
                                        width: 130,
                                        child:   Text("Category",style: TextStyle(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight
                                                .bold
                                        )),
                                      ),
                                      const SizedBox(
                                        width: 100,
                                        child:   Text("Sku#",style: TextStyle(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight
                                                .bold
                                        )),
                                      ),
                                      Spacer(),
                                      const SizedBox(
                                        width: 30,
                                        child:   Text("Qty",style: TextStyle(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight
                                                .bold
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.only(left: 0,right: 0),
                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: fulfillmentInfo['lineItems'].length,
                                      itemBuilder: (BuildContext context, int indexx) {
                                        return Container(
                                          color: indexx % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                                          height: 30,
                                          child:  Row(
                                            children: [
                                              SizedBox(
                                                width: 35,
                                                child: Text((indexx + 1)
                                                    .toString(),textAlign: TextAlign.center,),
                                              ),
                                              SizedBox(width: 22,),
                                              GestureDetector(
                                                child: SizedBox(
                                                  width: 125,
                                                  child: Text(fulfillmentInfo['lineItems'][indexx]['category'],),
                                                ),
                                                onTap: (){},
                                              ),
                                              SizedBox(width: 5,),
                                              GestureDetector(
                                                onTap: (){

                                                },
                                                child: SizedBox(
                                                  width: 100,
                                                  child: GestureDetector(
                                                    child:  Text(fulfillmentInfo['lineItems'][indexx]['sku'].toString(),
                                                        style: TextStyle(
                                                            decoration: TextDecoration.underline,
                                                            color: Colors.blue,
                                                            fontSize: 13)),
                                                    onTap: (){
                                                      if(fulfillmentInfo['lineItems'][indexx]['isESNRequired']){
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => SerializedInventoryPage(fulfillmentInfo,indexx)),
                                                        );
                                                      }else{
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => NonSerializedInventoryPage(fulfillmentInfo,indexx)),
                                                        );
                                                      }
                                                    },
                                                  )
                                                ),
                                              ),
                                              Spacer(),
                                              SizedBox(
                                                  width: 30,
                                                  child: Text(fulfillmentInfo['lineItems'][indexx]['qty'].toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13))),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),),
                              ],
                            ),
                          ),),
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
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                  Text(
                    fulfillmentInfo['fulfillmentNumber'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                  Text(
                    fulfillmentInfo['orderStatus'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
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
