import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';

class InventoryLookupDetailPage extends StatefulWidget {
  //var cartonContent;

  InventoryLookupDetailPage({Key? key}) : super(key: key);

  @override
  _InventoryLookupDetailPage createState() => _InventoryLookupDetailPage();
}

class _InventoryLookupDetailPage extends State<InventoryLookupDetailPage> {
  _InventoryLookupDetailPage();

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
        child: Text("Logs",
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
              'Serialized Inventory Lookup',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            ExpandTapWidget(
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
            )
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
                          const Text(
                            'IMEI ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                          Visibility(
                            visible: visible_detailPage,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 15),
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
                                                'Initial SKU: ',
                                                style: TextStyle(),
                                              ),
                                              Text("AQWQE",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Kitted SKU: ',
                                                style: TextStyle(),
                                              ),
                                              Text("AQWQE",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  )),
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
                                                'Category: ',
                                                style: TextStyle(),
                                              ),
                                              Text("Category",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Condition: ',
                                                style: TextStyle(),
                                              ),
                                              Text("condition",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  )),
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
                                              Text("No",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'ReStocking: ',
                                                style: TextStyle(),
                                              ),
                                              Text("Yes",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
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
                                      padding: EdgeInsets.only(top: 5, left: 8),
                                      child: Text(
                                        'Assignments: ',
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
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: <Widget>[
                                                      const Text(
                                                        'Fullfilment Order#: ',
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
                                                        'Date',
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
                                      padding: EdgeInsets.only(top: 5, left: 8),
                                      child: Text(
                                        'Details: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: <Widget>[
                                                      const Text(
                                                        'Batch: ',
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
                                                        'Serail#: ',
                                                        style: TextStyle(),
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
                                                        'ESN: ',
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
                                                        'ESN2: ',
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
                                                        'Medi Hex: ',
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
                                                        'Medi Dec: ',
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
                                      padding: EdgeInsets.only(top: 5, left: 8),
                                      child: Text(
                                        'Warehouse: ',
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
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: <Widget>[
                                                      const Text(
                                                        'Location: ',
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Carton ID:',
                                                        style: TextStyle(),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      )
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
                                                child:  Text("Log Date"),),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              SizedBox(width: 120,
                                                child:  Text("Module"),),
                                              SizedBox(width: 80,
                                                child:  Text("Status"),),
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
