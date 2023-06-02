import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocsPage extends StatefulWidget {
  var fulfillmentInfo;

  DocsPage(this.fulfillmentInfo, {Key? key}) : super(key: key);

  @override
  _DocsPage createState() => _DocsPage(fulfillmentInfo);
}

class _DocsPage extends State<DocsPage> {
  var fulfillmentInfo;

  _DocsPage(this.fulfillmentInfo);

  String orderDate = "";
  String shipmentDate="";
  bool _isLoading = false;
  BuildContext? _context;

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
                                    'Documents:',
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
                                        width: 120,
                                        child:   Text("Name",style: TextStyle(
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
                                      itemCount: fulfillmentInfo['documents'].length,
                                      itemBuilder: (BuildContext context, int indexx) {
                                        orderDate=fulfillmentInfo['documents'][indexx]['documentDate'];
                                        orderDate=orderDate.toString().substring(0,10);
                                        DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(orderDate);
                                        DateFormat formatter = DateFormat('MM/dd/yyyy');
                                        orderDate = formatter.format(tempDate);
                                        return Container(
                                          color: indexx % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                                          height: 35,
                                          child:  Row(
                                            children: [
                                              SizedBox(
                                                width: 35,
                                                child: Text((indexx + 1)
                                                    .toString(),textAlign: TextAlign.center,),
                                              ),
                                              SizedBox(width: 15,),
                                              GestureDetector(
                                                child: SizedBox(
                                                  width: 120,
                                                  child: Text(fulfillmentInfo['documents'][indexx]['fileName'].toString(),
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          decoration: TextDecoration.underline)),
                                                ),
                                                onTap: (){
                                                 if(fulfillmentInfo['documents'][indexx]['fileName'].toString()=='PACKING SLIP'){
                                                   callPackingSlipPrintApi(fulfillmentInfo['documents'][indexx]['filePath'].toString());
                                                 }else{
                                                   callDocumentPrintApi(fulfillmentInfo['documents'][indexx]['filePath'].toString());
                                                 }
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),)
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


  void callDocumentPrintApi(String fileName) async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    String? companyName = myPrefs.getString("companyName");
   // String? fileName = myPrefs.getString("companyLogo");
    var url="https://api.langlobal.com/fulfillment/v1/document";
    var body = json.encode({
      "fileName": fileName,
      "companyName": companyName,
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    print("requestParams$body");
    var response = await http.post(Uri.parse(url),body: body, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          print("jsonResponse :::: "+jsonResponse.toString());
          var base64Image=jsonResponse['base64String'];
          Uint8List bytx=Base64Decoder().convert(base64Image);
          await Printing.layoutPdf(onLayout: (_) => bytx);
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
    Navigator.of(_context!).pop();
    debugPrint(response.body);
  }

  void callPackingSlipPrintApi(String fileName) async {
    print("fulfillmentInfo :::: "+fulfillmentInfo.toString());
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    String? companyName = myPrefs.getString("companyName");
    // String? fileName = myPrefs.getString("companyLogo");
    var url="https://api.langlobal.com/fulfillment/v1/Customers/"+companyID!+"/packingslip/"+fulfillmentInfo['customerOrderNumber'];
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    print("requestParams$url");
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          print("jsonResponse :::: "+jsonResponse.toString());
          var base64Image=jsonResponse['base64String'];
          Uint8List bytx=Base64Decoder().convert(base64Image);
          await Printing.layoutPdf(onLayout: (_) => bytx);
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        _showToast("Something went wrong. Please contact administrator.");
        print('returnCode'+e.toString());
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
          _context=context;
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
