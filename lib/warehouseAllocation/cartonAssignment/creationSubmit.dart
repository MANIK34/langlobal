import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:http/http.dart' as http;
import 'package:langlobal/model/requestParams/imei.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreationSubmitPage extends StatefulWidget {
  var cartonID;
  var sku;
  var condition;
  var productName;
  var _jsonResponse;
  var sourceCartonResponse;

  CreationSubmitPage(this.cartonID,this.sku,this.condition,this.productName,this._jsonResponse,
      this.sourceCartonResponse,
      {Key? key}) : super(key: key);

  @override
  _CreationSubmitPage createState() =>
      _CreationSubmitPage(this.cartonID,this.sku,this.condition,this.productName,this._jsonResponse,
        this.sourceCartonResponse,);
}

class _CreationSubmitPage extends State<CreationSubmitPage> {
  var cartonID;
  var sku;
  var condition;
  var productName;
  var _jsonResponse;
  var sourceCartonResponse;
  _CreationSubmitPage(this.cartonID,this.sku,this.condition,this.productName,this._jsonResponse,
      this.sourceCartonResponse,);

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool autoFocus=false;

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list
  String cartonId="Test";

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text=cartonId;
    controllers.add(controller);
    return Text(
        cartonId
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFeildList.add(customField());
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
        child: Text("Submit",
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
            GestureDetector(
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
                            'Cartons Creation - View & Submit',
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
                                      Spacer(),
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
                                      Spacer(),
                                      Text(sku,style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Condition:'),
                                      Spacer(),
                                      Text(condition,style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Product Name:'),
                                      Spacer(),
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
                            visible: true,
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
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
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
                                      SizedBox(height: 15,),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: textFeildList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              Expanded(child: textFeildList[index]),
                                            ],
                                          );
                                        },
                                      ),
                                      Divider(
                                        color: Colors.grey,
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
    String? _userID = myPrefs.getString("userID");
    var url = "https://api.langlobal.com/inventoryallocation/v1/carton";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + _token!,
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "companyID": _companyID!,
      "userID": _userID,
      "cartonID":cartonID,
      "condition": condition,
      "sourceCartonID": '',
      "location": _jsonResponse['location'],
      "itemCompanyGUID": _jsonResponse['itemCompanyGUID'],
      "containerConditionID": 0,
      "qtyPerContainer": '',
      "sourceModule": "Movement",
      "uiAgent": "M",
      "createDate": "2023-03-19T05:28:53.061Z",
      "imeiList": jsonstringmap!,
    });

    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");

    print("requestParams$body" );

    final response1 = await http.post(Uri.parse(url), body:body,headers: headers);
    if (response1.statusCode == 200) {
      Navigator.of(context).pop();
      var jsonResponse = json.decode(response1.body);
      var returnCode=jsonResponse['returnCode'];
      if(returnCode=="1"){

      }
      _showToast(jsonResponse['returnMessage']);
    }
    print(response1.statusCode);
    print(response1.body);
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
