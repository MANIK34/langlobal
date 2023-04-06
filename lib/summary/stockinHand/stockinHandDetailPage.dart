import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import '../../model/requestParams/cartonList2.dart';
import '../../model/requestParams/locationList.dart';

class StockInHandDetailPage extends StatefulWidget {
  var stockInHands;

  StockInHandDetailPage(this.stockInHands,
      {Key? key}) : super(key: key);

  @override
  _StockInHandDetailPage createState() =>
      _StockInHandDetailPage(this.stockInHands);
}

class _StockInHandDetailPage extends State<StockInHandDetailPage> {
  var stockInHands;

  _StockInHandDetailPage(this.stockInHands );

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;

  BuildContext? _context;
  List<CartonList2> cartonList = <CartonList2>[];
  List<LocationList> locationList=<LocationList>[];
  var cartonValue;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text=cartonValue;
    controllers.add(controller);
    return Text(
        cartonValue.toString()
    );
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

    final searchButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
        },
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final refreshButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
        },
        child: Text("Refresh",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              refreshButton,
              Spacer(),
              searchButton
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text('Stock In Hand',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
            ),
            ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),),
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:  Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Stock In Hand',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Total SKUs:',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                    child:  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      color: Color.fromRGBO(	40, 40, 43, 6.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ' ',
                                style: TextStyle(
                                  fontSize: 1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:  Row(
                      children: <Widget>[
                        Text(
                          'SKU',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 55,
                        ),
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'QTY',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: stockInHands.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      stockInHands[index]['sku'],
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      stockInHands[index]['productName'],

                                    ),
                                    Spacer(),
                                    Text(
                                      stockInHands[index]['stockInHand'].toString(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                  child:  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0),
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: const [

                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              ' ',
                                              style: TextStyle(
                                                fontSize: 1,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
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



  void _showToast(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
      action: SnackBarAction(
        label: "OK",
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ),
    ));
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
