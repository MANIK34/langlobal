import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:langlobal/summary/shipment/shipmentLookup.dart';

class ShipmentSubmit2Page extends StatefulWidget {


  ShipmentSubmit2Page( {Key? key})
      : super(key: key);

  @override
  _ShipmentSubmit2Page createState() =>
      _ShipmentSubmit2Page();
}

class _ShipmentSubmit2Page extends State<ShipmentSubmit2Page> {


  _ShipmentSubmit2Page();

  String orderDate = "";
  String shipmentDate = "";
  bool _isLoading = false;
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 10.0, color: Colors.black);
  List<String> trackingList = [];
  late String? _trackingList = null;
  String trackingNumber = "";
  BuildContext? _context;
  TextEditingController memoController = TextEditingController();
  TextEditingController memoController2 = TextEditingController();
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
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShipmentLookup("")),
              );
            });
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

    final memoField2 = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        controller: memoController2,
        style: style,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if(memoController2.text.toString()==""){
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
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Column(
                      children: <Widget>[
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
                                    'Ship To: ',
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
