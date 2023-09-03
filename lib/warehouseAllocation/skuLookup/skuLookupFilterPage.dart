import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:langlobal/drawer/drawerElement.dart';

import '../../dashboard/DashboardPage.dart';

class SkuLookupFilterPage extends StatefulWidget {
  //var cartonContent;

  SkuLookupFilterPage({Key? key}) : super(key: key);

  @override
  _SkuLookupFilterPage createState() => _SkuLookupFilterPage();
}

class _SkuLookupFilterPage extends State<SkuLookupFilterPage> {
  _SkuLookupFilterPage();

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
  bool visible_detailPage = false;

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

  @override
  void initState() {
    // TODO: implement initState
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
        minWidth: 196,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            visible_detailPage=true;
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
        minWidth: 196,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            visible_detailPage=false;
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
            /*ExpandTapWidget(
              tapPadding: EdgeInsets.fromWindowPadding(),
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
            )*/
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
                                '[Category] - [SKU] - [Conditions] ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                              Text(
                                'A/B/C/New',style: (TextStyle(
                                decoration: TextDecoration.underline,
                              )),
                              )
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
                                            children: const <Widget>[
                                              Text('Product Name'),
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
                                                          /*Text(
                                                    cartonContent['cartonCount'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),*/
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
                                                            'Stock In Hand: ',
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          /*Text(
                                                    cartonContent['itemsCount'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),*/
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
                                            children: const <Widget>[
                                              Text('Short Description:'),
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
                                                          /*Text(
                                                    cartonContent['cartonCount'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),*/
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
                                                          /*Text(
                                                    cartonContent['itemsCount'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),*/
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
                                                          /*Text(
                                                    cartonContent['cartonCount'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),*/
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
                                                          /*Text(
                                                    cartonContent['itemsCount'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),*/
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
                                                          /*Text(
                                                    cartonContent['cartonCount'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),*/
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
                                                          /*Text(
                                                    cartonContent['itemsCount'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),*/
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
                                      padding: EdgeInsets.only(top: 25, left: 8),
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
                                                width: 210,
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
                                              SizedBox(width: 50,
                                                child:  Text("S.NO."),),
                                              SizedBox(width: 80,
                                                child:  Text("Cartons"),),
                                              SizedBox(width: 80,
                                                child:  Text("Location"),),
                                              SizedBox(width: 60,
                                                child:  Text("Count"),),
                                              SizedBox(width: 80,
                                                child:  Text("Assign Date"),),
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
}
