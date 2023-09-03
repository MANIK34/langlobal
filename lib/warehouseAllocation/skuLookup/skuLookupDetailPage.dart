import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../dashboard/DashboardPage.dart';
import '../../utilities.dart';
import '../cartonLookup/cartonLookupDetailPage.dart';

class SkuLookupDetailPage extends StatefulWidget {
  var jsonResponse;

  SkuLookupDetailPage(this.jsonResponse, {Key? key}) : super(key: key);

  @override
  _SkuLookupDetailPage createState() => _SkuLookupDetailPage(this.jsonResponse);
}

class _SkuLookupDetailPage extends State<SkuLookupDetailPage> {
  var jsonResponse;

  _SkuLookupDetailPage(this.jsonResponse);

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool autoFocus = false;

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list
  var esnValue;
  bool _visibleImei = false;
  Color active_bg_color = Colors.orange;
  Color active_text_color = Colors.white;
  Color inactive_bg_color = Colors.grey.shade200;
  Color inactive_text_color = Colors.grey;
  bool visible_detailPage = true;
  BuildContext? _context;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text = esnValue.toString();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return Text(esnValue.toString());
  }

  Utilities _utilities = Utilities();


  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: active_bg_color,
      child: MaterialButton(
        minWidth: 177,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            visible_detailPage = true;
            active_bg_color = Colors.orange;
            active_text_color = Colors.white;
            inactive_bg_color = Colors.grey.shade200;
            inactive_text_color = Colors.grey;
          });
        },
        child: Text("Details",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: active_text_color, fontWeight: FontWeight.bold)),
      ),
    );

    final logButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: inactive_bg_color,
      child: MaterialButton(
        minWidth: 178,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            visible_detailPage = false;
            active_bg_color = Colors.grey.shade200;
            active_text_color = Colors.grey;
            inactive_bg_color = Colors.orange;
            inactive_text_color = Colors.white;
          });
        },
        child: Text("Cartons",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: inactive_text_color, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[detailButton, logButton],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SKU Lookup',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
           /* ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),*/
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
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: false,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text(
                                jsonResponse['sku'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                              ),

                            ],
                          ),
                          Visibility(
                            visible: visible_detailPage,
                            child: Column(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 15, left: 8),
                                      child: Text(
                                        'Product Info: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.black,
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
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                jsonResponse['category']+" - ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Expanded(child: Text(jsonResponse['productInfo']['productName'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,),),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 5),
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
                                                        'Maker: ',
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                        jsonResponse[
                                                                'productInfo']
                                                            ['maker'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Short Description:'),
                                              Expanded(child: Text(
                                                jsonResponse['productInfo']
                                                ['shortDescription'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 5),
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
                                                        'Min. Stock: ',
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                        jsonResponse[
                                                                    'productInfo']
                                                                ['minimumStock']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                        'Max. Stock: ',
                                                      ),
                                                      Text(
                                                        jsonResponse[
                                                                    'productInfo']
                                                                ['maximumStock']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 5),
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
                                                        'Proudcut Type: ',
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                        jsonResponse[
                                                                'productInfo']
                                                            ['productType'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                        'UPC: ',
                                                      ),
                                                      Text(
                                                        jsonResponse[
                                                                'productInfo']
                                                            ['upc'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 5),
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
                                                        'Active: ',
                                                        style: TextStyle(),
                                                      ),
                                                      if (jsonResponse[
                                                                  'productInfo']
                                                              ['active'] ==
                                                          true)
                                                        Text('Yes',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            )),
                                                      if (jsonResponse[
                                                                  'productInfo']
                                                              ['active'] ==
                                                          false)
                                                        Text('No',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            )),
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
                                                        'ReStocking: ',
                                                      ),
                                                      if (jsonResponse[
                                                                  'productInfo']
                                                              ['reStocking'] ==
                                                          true)
                                                        Text('Yes',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            )),
                                                      if (jsonResponse[
                                                                  'productInfo']
                                                              ['reStocking'] ==
                                                          false)
                                                        Text('No',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            )),
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
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 25, left: 8),
                                      child: Text(
                                        'Stock Level: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.black,
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
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 5),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                child: Text('S.NO.'),
                                              ),
                                              SizedBox(
                                                width: 190,
                                                child: Text('Condition'),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text('Stock'),
                                              )
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

                                Padding(padding: EdgeInsets.only(left: 15,right: 0),
                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: jsonResponse['stocks'].length,
                                      itemBuilder: (BuildContext context, int indexx) {
                                        return Container(
                                          color: indexx % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                                          height: 30,
                                          child:  Row(
                                            children: [
                                              SizedBox(width: 5,),
                                              SizedBox(
                                                width: 50,
                                                child: Text((indexx + 1)
                                                    .toString()),
                                              ),
                                              SizedBox(
                                                width: 190,
                                                child: Text( jsonResponse['stocks'][indexx]['condition'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text( jsonResponse['stocks'][indexx]['stock'].toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !visible_detailPage,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.black,
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
                                          padding: EdgeInsets.only(
                                              left: 5, right: 0, top: 5),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                child: Text("#"),
                                              ),
                                              SizedBox(
                                                width: 105,
                                                child: Text("Cartons"),
                                              ),
                                              SizedBox(
                                                width: 70,
                                                child: Text("Location"),
                                              ),
                                              SizedBox(
                                                width: 60,
                                                child: Text("Count"),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text("Assign Date"),
                                              ),
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
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 0),
                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: jsonResponse['cartons'].length,
                                      itemBuilder:
                                          (BuildContext context, int indexx) {
                                        return Container(
                                          color: indexx % 2 == 0 ? Color(0xffd3d3d3) : Colors.white,
                                          child: GestureDetector(
                                            onTap: (){
                                              if(!Utilities.ActiveConnection){
                                                _showToast("No internet connection found!");
                                              }else{
                                                callGetCartonLookupApi(jsonResponse['cartons'][indexx]['cartonID'].toString());
                                                print(jsonResponse['cartons'][indexx]['cartonID'].toString());
                                              }
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 20,
                                                        child: Text((indexx + 1)
                                                            .toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 95,
                                                        child:Text(
                                                          jsonResponse['cartons']
                                                          [indexx]
                                                          ['cartonID']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,decoration: TextDecoration.underline,color: Colors.blue),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      SizedBox(
                                                          width: 80,
                                                          child: Text(
                                                            jsonResponse['cartons']
                                                            [indexx]
                                                            ['location']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          )),
                                                      SizedBox(
                                                        width: 45,
                                                        child: Text(
                                                          jsonResponse['cartons']
                                                          [indexx]
                                                          ['quantity']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 90,
                                                        child: Text(DateFormat("MM/dd/yyyy").format(DateTime.parse(jsonResponse['cartons']
                                                        [indexx][
                                                        'assignedDateTime']
                                                            .toString()
                                                            .substring(0, 10))),
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(color: Colors.black),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )),
      ),
    );
  }

  void callGetCartonLookupApi(String cartonId) async {
    buildShowDialog(context);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");
    var url = "https://api.langlobal.com/inventoryallocation/v1/cartonlookup/"+
       cartonId;
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}'
    };
    print(url.toString());
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonLookupDetailPage(jsonResponse['cartonContent'])),
          );
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(_context!).pop();
      print(response.statusCode);
    }
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
