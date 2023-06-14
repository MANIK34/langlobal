import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:langlobal/summary/fulfillment/provisioning/lineItem.dart'; 
import 'package:langlobal/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../../model/requestParams/cartonList2.dart';
import '../../../model/requestParams/imeIsList.dart'; 

class ShipmentSubmitPage extends StatefulWidget {


  ShipmentSubmitPage( {Key? key})
      : super(key: key);

  @override
  _ShipmentSubmitPage createState() =>
      _ShipmentSubmitPage();
}

class _ShipmentSubmitPage extends State<ShipmentSubmitPage> {


  _ShipmentSubmitPage();

  String orderDate = "";
  String shipmentDate = "";
  bool _isLoading = false;
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  List<String> trackingList = [];
  late String? _trackingList = null;
  String trackingNumber = "";
  BuildContext? _context;
  TextEditingController memoController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trackingList.add('Select');

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
          hint: const Text(
            "Select",
            style: TextStyle(fontSize: 12),
          ),
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
              child: Text(
                map,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
    final backToLookup = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            /* bg_color=Colors.green.shade800;
             txt_color=Colors.white;*/
            print("trackingNumber ::::: " + trackingNumber);
            if (trackingNumber == "") {
              _showToast('Please select');
            } else {
             // callSerializedApi();
            }
          });
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final generateLabel = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 120,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {

        },
        child: Text("Generate Label",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final memoField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: memoController,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if(memoController.text.toString()==""){
            _showToast("can't be empty");
          }else{
          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "",
          alignLabelWithHint: true,
          hintText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            backToLookup,

          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'New Shipment Label',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Shipment Label By: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 150,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(width: 170,
                                              height: 50,
                                              child:  memoField,),
                                            SizedBox(width: 10,),
                                            SizedBox(
                                              height: 50,
                                              child:  generateLabel,),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),),
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
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Carrier: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),),
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
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Ship Via: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Package: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Weight: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 80,
                                              height: 40,
                                              child: memoField,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Ship From: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),),
                                Divider(
                                  thickness: 2,
                                  color: Colors.black,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Full Name: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Address: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              child: Text(
                                                'City: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                            SizedBox(width: 5,),
                                            SizedBox(
                                              child: Text(
                                                'Zip: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              child: Text(
                                                'State: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              height: 35,
                                              child: trackingDropdown,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
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
