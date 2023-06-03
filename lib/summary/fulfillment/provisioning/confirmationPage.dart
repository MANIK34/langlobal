import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/summary/fulfillment/provisioning/lineItem.dart';

import '../../../model/requestParams/cartonList2.dart';
import '../salesOrderPage.dart';

class ConfirmationPage extends StatefulWidget {
  var fulfillmentInfo;

  ConfirmationPage(this.fulfillmentInfo, {Key? key}) : super(key: key);

  @override
  _ConfirmationPage createState() => _ConfirmationPage(fulfillmentInfo);
}

class _ConfirmationPage extends State<ConfirmationPage> {
  var fulfillmentInfo;

  _ConfirmationPage(this.fulfillmentInfo);

  String orderDate = "";
  String shipmentDate="";
  bool _isLoading = false;
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = [];
  List<CartonList2> cartonList = <CartonList2>[];

  List<Widget> textFeildListQty = [];
  List<TextEditingController> controllersQty = [];

  var bg_color=Colors.grey.shade800;
  var txt_color=Colors.grey.shade400;

  List<String> trackingList=[];
  late String? _trackingList = null;
  String? trackingNumber;

  Widget customField({GestureTapCallback? removeWidget}) {

    TextEditingController controller = TextEditingController();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
      ],
      maxLength: 20,
      autofocus: true,
      showCursor: true,
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        if(controllers[textFeildList.length-1].text!=""){
          textFeildList.add(customField());
        }
      },
      decoration: InputDecoration(
        hintText: "Carton ID",
        counterText: "",
      ),
    );
  }

  Widget customFieldQty({GestureTapCallback? removeWidget}) {

    TextEditingController controller = TextEditingController();
    controllersQty.add(controller);
    for (int i = 0; i < controllersQty.length; i++) {
      print(
          controllersQty[i].text); //printing the values to show that it's working
    }
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
      ],
      maxLength: 20,
      autofocus: true,
      showCursor: true,
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        if(controllersQty[textFeildListQty.length-1].text!=""){
          textFeildListQty.add(customField());
        }
      },
      decoration: InputDecoration(
        hintText: "Qty",
        counterText: "",
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFeildList.add(customField());
    textFeildListQty.add(customFieldQty());
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

    trackingList.add("Value1");
    trackingList.add("Value2");

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
    final trackingDropdown = Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text("Select Tracking Number",style: TextStyle(
              fontSize: 12
          ),),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 26.0,
          isExpanded: true,
          value: _trackingList,
          onChanged: (value) {
            setState(() {
              _trackingList = value!;
              trackingNumber = value!;
            });
          },
          items: trackingList.map((String map) {
            return DropdownMenuItem<String>(
              value: map,
              child: Text(map,style: const TextStyle(fontSize: 12),),
            );
          }).toList(),
        ),
      ),
    );

    final backToLookup = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            bg_color=Colors.green.shade800;
            txt_color=Colors.white;
          });
        },
        child: Text("Validate",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 12,
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final sourceCartons = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: bg_color,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LineItemPage(fulfillmentInfo,false)),
          );
        },
        child: Text("Confirmation",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 12,
                color: txt_color, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Expanded(child: backToLookup),
            Expanded(child: sourceCartons),
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
            GestureDetector(
                child: Container(
                    width: 85,
                    height: 80,
                    child: Center(
                      child: ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
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
                                    'Assignments - Shipment Label:',
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
                                Row(
                                  children: <Widget>[
                                    Text('Tracking#:',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                    SizedBox(width: 200,
                                      height: 35,
                                      child: trackingDropdown,),

                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: <Widget>[
                                    const Text('Carrier: ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                    const Text('FedEX/UPS'),
                                    Spacer(),
                                    const Text('6/2/2023'),
                                  ],
                                ),

                              ],
                            )),
                        Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Assignments - Non Serialized Inventory:',
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
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                            child: Row(
                              children: <Widget>[
                                Text('S.NO.'),
                                SizedBox(width: 10,),
                                Text('Carton#'),
                                Spacer(),
                                Text('QTY'),
                                SizedBox(width: 35,),
                              ],
                            )
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: textFeildList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    children: [
                                      Text(
                                        ""+ (index+1).toString()+". ",
                                      ),
                                      SizedBox(width: 25,),
                                      SizedBox(width: 220,child: textFeildList[index]),
                                      Spacer(),
                                      SizedBox(width: 50,child: textFeildListQty[index]),
                                      SizedBox(width: 10,),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        ),
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
