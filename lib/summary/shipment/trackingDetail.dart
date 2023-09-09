import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/summary/shipment/shipmentSearch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/DashboardPage.dart';
import '../../model/requestParams/accountNumber.dart';
import '../../utilities.dart';

class TrackingDetailPage extends StatefulWidget {

  var trackingInfo;

  TrackingDetailPage(this.trackingInfo , {Key? key}) : super(key: key);

  @override
  _TrackingDetailPage createState() => _TrackingDetailPage(this.trackingInfo);
}

class _TrackingDetailPage extends State<TrackingDetailPage> {
  var trackingInfo;


  _TrackingDetailPage(this.trackingInfo);
  Utilities utilities = Utilities();
  String orderDate = "";
  String shipmentDate="";
  String shipDate="";
  bool _isLoading = false;
  String  dummy="";
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  BuildContext? _context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try{
      orderDate=trackingInfo['orderDate'];
      orderDate=orderDate.toString().substring(0,10);
      DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(orderDate);
      DateFormat formatter = DateFormat('MM/dd/yyyy');
      orderDate = formatter.format(tempDate);

      shipDate=trackingInfo['shipDate'];
      shipDate=shipDate.toString().substring(0,10);
      tempDate = new DateFormat("yyyy-MM-dd").parse(shipDate);
      formatter = DateFormat('MM/dd/yyyy');
      shipDate = formatter.format(tempDate);

      shipmentDate=trackingInfo['shipmentDate'];
      shipmentDate=shipmentDate.toString().substring(0,10);
      /*  tempDate = new DateFormat("MM/dd/yyyy").parse(shipmentDate);
    formatter = DateFormat('MM/dd/yyyy');*/
      shipmentDate = formatter.format(tempDate);
    }catch(e){
      utilities.callAppErrorLogApi(e.toString(),"trackingDetail.dart","callTrackingDetailApi");
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
    final backToLookup = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 100,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          callVoidShipmentApi();
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
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShipmentSearchPage('Shipment Label Lookup')),
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
              padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child:  Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10,90),
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
                                        width: 100,
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
                                      itemCount: trackingInfo['trackingLogs'].length,
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
                                                  width: 95,
                                                  child: Text(trackingInfo['trackingLogs'][indexx]['shipmentLogDate'].toString().substring(0,10)),
                                                ),
                                                onTap: (){},
                                              ),
                                              SizedBox(width: 5,),
                                              GestureDetector(
                                                onTap: (){

                                                },
                                                child: SizedBox(
                                                    width: 80,
                                                    child: GestureDetector(
                                                      child:  Text(trackingInfo['trackingLogs'][indexx]['action'],
                                                          style: TextStyle(
                                                              /*decoration: TextDecoration.underline,
                                                              color: Colors.blue,*/
                                                              fontSize: 13)),
                                                      onTap: (){

                                                      },
                                                    )
                                                ),
                                              ),
                                              Spacer(),
                                              SizedBox(
                                                  child: Text(trackingInfo['trackingLogs'][indexx]['location'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13))),
                                              SizedBox(width: 10,),
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
                    trackingInfo['trackingNumber'],
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
                          Text(trackingInfo['labelStatus'],style:
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
                          Text(trackingInfo['shipVia'],
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
                          Text(shipDate,style:
                          TextStyle(fontWeight: FontWeight.normal)),
                          Spacer(),
                          Text('Weight:(Oz): ',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(trackingInfo['weight'].toString(),style:
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
                          Text(trackingInfo['price'].toString(),style:
                          TextStyle(fontWeight: FontWeight.normal)),
                          Spacer(),
                          Text('Status: ',style:
                          TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(trackingInfo['orderSatus'],style:
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
                                        trackingInfo['package'],
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
                            trackingInfo['orderType'],
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                          Text(
                            trackingInfo['orderNumber'],
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                          Text(
                            trackingInfo['orderSatus'],
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
                          Text(trackingInfo['customerOrderNumber'],
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
                          Text(orderDate,style:
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
                                        'Shipment Date: ',style:
                                      TextStyle(fontWeight: FontWeight.bold)
                                      ),
                                      Text(
                                        shipmentDate,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
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

  void callVoidShipmentApi() async {
    buildShowDialog(context);

    List<AccountNumber> accountNumberList = <AccountNumber>[];
    AccountNumber _list= AccountNumber(value: "");
    accountNumberList.add(_list);

    var _cartonList = accountNumberList.map((e) {
      return {
        "value": e.value,
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("accountNumber$jsonstringmap");

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");

    var url = Utilities.baseUrl!+"api/v1/carrier/Fedex/voidshipment";
    print("void url ::::"+url.toString());

    var body = json.encode({
      "trackingNumber": trackingInfo['trackingNumber'],
      "deletionControl": '',
      "senderCountryCode": '',
      "accountNumber": jsonstringmap,
    });
    body = body.replaceAll("\"[", "[");
    body = body.replaceAll("]\"", "]");
    body = body.replaceAll("\\\"", "\"");
    print("void :: $body");

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
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShipmentSearchPage('Shipment Label Lookup')),
          );
        } else {
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode' + e.toString());
        utilities.callAppErrorLogApi(e.toString(),"login.dart","callLoginApi");
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      utilities.callAppErrorLogApi(response.body.toString(),"TrackingDetail.dart","callVoidShipmentApi");
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
