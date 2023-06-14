import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/summary/fulfillment/provisioning/nonSerializedInventoryPage.dart';
import 'package:langlobal/summary/fulfillment/provisioning/serializedInventory.dart';
import 'package:langlobal/summary/fulfillment/provisioning/confirmationPage.dart';
import 'package:langlobal/summary/shipment/shipmentSubmit.dart';
 

class TrackingDetailPage extends StatefulWidget {

  var fulfillmentInfo;

  TrackingDetailPage(this.fulfillmentInfo , {Key? key}) : super(key: key);

  @override
  _TrackingDetailPage createState() => _TrackingDetailPage(this.fulfillmentInfo);
}

class _TrackingDetailPage extends State<TrackingDetailPage> {
  var fulfillmentInfo;


  _TrackingDetailPage(this.fulfillmentInfo);

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
    /*orderDate=fulfillmentInfo['fulfillmentDate'];
    orderDate=orderDate.toString().substring(0,10);
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(orderDate);
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    orderDate = formatter.format(tempDate);

    shipmentDate=fulfillmentInfo['requestedShipDate'];
    shipmentDate=shipmentDate.toString().substring(0,10);
    tempDate = new DateFormat("yyyy-MM-dd").parse(shipmentDate);
    formatter = DateFormat('MM/dd/yyyy');
    shipmentDate = formatter.format(tempDate);*/
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
        },
        child: Text("Request for Void",
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
            MaterialPageRoute(builder: (context) => ShipmentSubmitPage()),
          );
        },
        child: Text("Tracking",
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
            confirmation
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text('Shipment Label Lookup',textAlign: TextAlign.center,
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
                                        width: 80,
                                        child:   Text("Date",style: TextStyle(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight
                                                .bold
                                        )),
                                      ),
                                      const SizedBox(
                                        width: 70,
                                        child:   Text("Action",style: TextStyle(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight
                                                .bold
                                        )),
                                      ),
                                      Spacer(),
                                      const SizedBox(
                                        child:   Text("Location",style: TextStyle(
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
                                      itemCount: 2,
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
                                                  child: Text(''),
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
                                                      child:  Text("",
                                                          style: TextStyle(
                                                              decoration: TextDecoration.underline,
                                                              color: Colors.blue,
                                                              fontSize: 13)),
                                                      onTap: (){

                                                      },
                                                    )
                                                ),
                                              ),
                                              Spacer(),
                                              SizedBox(
                                                  width: 30,
                                                  child: Text("",
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tracking#",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                ],
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
                          Text('Label Status:',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('status',style:
                          TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Text('Ship  Via:', style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text( 'Ship  Via',
                              style:
                              TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Text('Ship Date:',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('date',style:
                          TextStyle(fontWeight: FontWeight.normal)),
                          Spacer(),
                          Text('Weight:(Oz): ',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('',style:
                          TextStyle(fontWeight: FontWeight.normal)),

                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Text('Price:',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('0.0',style:
                          TextStyle(fontWeight: FontWeight.normal)),
                          Spacer(),
                          Text('Status: ',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('',style:
                          TextStyle(fontWeight: FontWeight.normal)),

                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 5
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
                                        'Package: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
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

                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Assignments:',
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Type",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                          Text(
                            "Order#",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                          Text(
                            "Status",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Text('Customer Order#:',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text( '',
                              style:
                              TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Text('Order Date:',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('',style:
                          TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                                        'Shipmnet Date: ',style:
                                      TextStyle(fontWeight: FontWeight.bold)
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
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Logs:',
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
          ],
        )
    );
  }
}
