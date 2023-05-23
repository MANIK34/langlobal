import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/requestParams/cartonList2.dart';
import 'cartonMovementSubmit.dart';

class CartonMovementValidate extends StatefulWidget {
  var movementInfo;
  var sourceLocation;

  CartonMovementValidate(this.movementInfo,this.sourceLocation,  {Key? key}) : super(key: key);

  @override
  _CartonMovementValidate createState() =>
      _CartonMovementValidate(this.movementInfo,this.sourceLocation );
}

class _CartonMovementValidate extends State<CartonMovementValidate> {
  var movementInfo;
  var sourceLocation;

  _CartonMovementValidate(this.movementInfo,this.sourceLocation );

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;
  TextEditingController skuController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var cartonValue;
  BuildContext? _context;
  List<CartonList2> cartonList = <CartonList2>[];

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
    for(int m=0;m<movementInfo['cartons'].length;m++){
      cartonValue=movementInfo['cartons'][m]['cartonID'];
      textFeildList.add(customField());
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final destinationField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        maxLength: 11,
        textAlign: TextAlign.left,
        controller: locationController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          alignLabelWithHint: true,
          hintText: "Destination Location",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
          callCartonMovementApi();
        },
        child: Text("Validate",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: validateButton,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text('Inventory Movement',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
            ),
            /*ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 14,fontWeight: FontWeight.bold),
              ),
            )*/
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
        ),),
      drawer: DrawerElement(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:  Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Carton Movement - Destination Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Color.fromRGBO(211, 211, 211, 6.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Source Location:',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        sourceLocation,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Location Type:" ,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        movementInfo['sourceLocationType'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )),

                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 60,
                            child:  destinationField,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children:   <Widget>[
                                          Text(
                                            'Total Cartons: ' ,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            movementInfo['cartonCount'].toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Items Count: ' ,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            movementInfo['cartornItemsCount'].toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cartons Assignment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: textFeildList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      ""+ (index+1).toString()+". ",
                                    ),
                                    Expanded(child: textFeildList[index]),
                                    const SizedBox(
                                      width: 0,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          textFeildList.removeAt(index);
                                          controllers.removeAt(index);
                                          setState(() {});
                                        },
                                        child: index < 0
                                            ? Container()
                                            : const Icon(Icons.delete,color: Colors.red,)),
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

  void callCartonMovementApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    String? token = myPrefs.getString("token");

    cartonList= <CartonList2>[];
    for (int i = 0; i < controllers.length; i++) {
      if(controllers[i].text! != ""){
        CartonList2 obj= CartonList2(cartonID: controllers[i].text!,assignedQty: 0,);
        cartonList.add(obj);
      }
    }
    var _cartonList = cartonList.map((e){
      return {
        "cartonID": e.cartonID,
        "assignedQty": e.assignedQty,
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap" );

    var url = "https://api.langlobal.com/inventoryallocation/v1/cartonmovement/validate";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "companyID": int.parse(companyID!),
      "sourceLocation": sourceLocation,
      "destinationLocation": locationController.text.toString(),
      "cartons":jsonstringmap,
    });
    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");
    print("requestParams$body" );
    var response =
    await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(_context!).pop();
      print(response.body);
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonMovementSubmit(movementInfo,
                sourceLocation,locationController.text.toString())),
          );
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print("error message ::"+e.toString());
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(_context!).pop();
      print(response.statusCode);
    }
  }
}
