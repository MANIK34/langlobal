import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/model/requestParams/imei.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'creationSubmit.dart';

class CartonSerializedPage extends StatefulWidget {
  var cartonID;
  var sku;
  var condition;
  var productName;
  var _jsonResponse;
  var sourceCartonResponse;
  String qty = '';
  var sourceCartonID = '';
  var containerConditionID = '';
  bool isEsnRequired;

  CartonSerializedPage(this.cartonID,this.sku,this.condition,this.productName,this._jsonResponse,
      this.sourceCartonResponse,this.qty,this.sourceCartonID,this.containerConditionID,this.isEsnRequired,
      {Key? key}) : super(key: key);

  @override
  _CartonSerializedPage createState() =>
      _CartonSerializedPage(this.cartonID,this.sku,this.condition,this.productName,this._jsonResponse,
        this.sourceCartonResponse,this.qty,this.sourceCartonID,this.containerConditionID,this.isEsnRequired);
}

class _CartonSerializedPage extends State<CartonSerializedPage> {
  var cartonID;
  var sku;
  var condition;
  var productName;
  var _jsonResponse;
  var sourceCartonResponse;
  String qty = '';
  var sourceCartonID = '';
  var containerConditionID = '';
  bool isEsnRequired;

  _CartonSerializedPage(this.cartonID,this.sku,this.condition,this.productName,this._jsonResponse,
      this.sourceCartonResponse,this.qty,this.sourceCartonID,this.containerConditionID,this.isEsnRequired);

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool autoFocus=false;

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list
  BuildContext? _context;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return TextField(
      autofocus: autoFocus,
      showCursor: true,
      maxLength: 20,
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        if(controllers[textFeildList.length-1].text!=""){
          setState(() {
            autoFocus=true;
            textFeildList.add(customField());
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFeildList.add(customField());
    print(_jsonResponse['itemCompanyGUID']);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
          callValidateApi();

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
            const Text('Carton Creation',textAlign: TextAlign.center,
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
            reverse: true,
            child: Padding(
              padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child:  Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cartons - Serialized/Non-Serialized Assignment',
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
                        Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Carton ID:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonID.toString(),style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                               Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                 child: Row(
                                   children: <Widget>[
                                     Text('SKU:'),
                                     const SizedBox(
                                       width: 5,
                                     ),
                                     Text(sku,style: TextStyle(
                                         fontWeight: FontWeight.bold
                                     )),
                                     const SizedBox(
                                       width: 5,
                                     ),
                                     Text('I'),
                                     const SizedBox(
                                       width: 5,
                                     ),
                                     Text('Condition:'),
                                     const SizedBox(
                                       width: 5,
                                     ),
                                     Text(condition,style: TextStyle(
                                         fontWeight: FontWeight.bold
                                     )),
                                   ],
                                 ),
                               ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Product Name:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(productName,style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),),

                        Visibility(
                          visible: isEsnRequired,
                          child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Assignments',
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

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Text(
                                    'IMEI',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: textFeildList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          Text(
                                            ""+ (index+1).toString()+". ",
                                          ),
                                          Expanded(child: textFeildList[index]),
                                          GestureDetector(
                                              onTap: () {
                                                if(textFeildList.length>1){
                                                  textFeildList.removeAt(index);
                                                  controllers.removeAt(index);
                                                  setState(() {});
                                                }
                                              },
                                              child: index < 0
                                                  ? Container()
                                                  : const Icon(Icons.delete,color: Colors.red,)),
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),

                          ]
                          ,
                        ))

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




  void callValidateApi() async{
    List<IMEI>imeiList= <IMEI>[];
    for (int i = 0; i < controllers.length; i++) {
      if(controllers[i].text! != ""){
        IMEI obj= IMEI(imei: controllers[i].text!);
        imeiList.add(obj);
      }
    }
    if(imeiList.isEmpty){
      IMEI obj= IMEI(imei: "");
      imeiList.add(obj);
    }
    var _cartonList = imeiList.map((e){
      return {
        "imei": e.imei,
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap" );

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? _token = myPrefs.getString("token");
    String? _companyID = myPrefs.getString("companyID");
    var url = "https://api.langlobal.com/inventoryallocation/v1/cartoncontent/validate";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var sourceCarton;
    if(containerConditionID=='0'){
      sourceCarton="";
    }else{
      sourceCarton=sourceCartonResponse['cartonID']!;
    }
    var body = json.encode({
      "companyID": _companyID!,
      "itemCompanyGUID": _jsonResponse['itemCompanyGUID'],
      "location": _jsonResponse['location'],
      "condition": condition,
      "sourceCarton": sourceCarton,
      "esNs": jsonstringmap!,
    });

    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");

    print("requestParams$body" );

    final response1 = await http.post(Uri.parse(url), body:body,headers: headers);
    if (response1.statusCode == 200) {
      Navigator.of(_context!).pop();
      var jsonResponse = json.decode(response1.body);
      var returnCode=jsonResponse['returnCode'];
      if(returnCode=="1"){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreationSubmitPage(cartonID,sku,condition,
                  _jsonResponse['productName'],_jsonResponse,sourceCartonResponse,qty,sourceCartonID,
              containerConditionID,jsonstringmap,imeiList)),
        );
      }else{
        _showToast(jsonResponse['returnMessage']);
      }
    }
    print(response1.statusCode);
    print(response1.body);
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
