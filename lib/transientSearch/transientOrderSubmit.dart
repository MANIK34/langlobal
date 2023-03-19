import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/DashboardPage.dart';
import '../model/requestParams/cartonList.dart';

class TransientOrderSubmitPage extends StatefulWidget {
  var memoNumber;
  var orderDate;
  var status;
  var sku;
  var category;
  var name;
  var supplier;
  var cartonCount;
  var orderQty;
  var transientOrderID;
  var isESNRequired;
  var palletID;
  List<CartonList> obj_cartonList;

  var customerOrderNumber;
  var condition;
  var companyID;
  var itemCompanyGUID;
  var userID;
  var orderDateTime;

  TransientOrderSubmitPage(this.memoNumber,this.orderDate,this.status,
      this.sku,this.category,this.name,this.supplier,this.cartonCount,
      this.orderQty,this.transientOrderID,this.isESNRequired,this.palletID,this.obj_cartonList
      ,this.customerOrderNumber
      ,this.condition,this.orderDateTime,this.companyID,this.itemCompanyGUID,this.userID,{Key? key}) : super(key: key);

  @override
  _TransientOrderSubmitPage createState() =>
      _TransientOrderSubmitPage(this.memoNumber,this.orderDate,this.status,
          this.sku,this.category,this.name,this.supplier,this.cartonCount,
          this.orderQty,this.transientOrderID,this.isESNRequired,this.palletID,this.obj_cartonList
        ,this.customerOrderNumber
        ,this.condition,this.orderDateTime,this.companyID,this.itemCompanyGUID,this.userID,);
}

class _TransientOrderSubmitPage extends State<TransientOrderSubmitPage> {
  var memoNumber;
  var orderDate ;
  var status ;
  var sku ;
  var category;
  var name ;
  var supplier ;
  var cartonCount;
  var orderQty ;
  var transientOrderID;
  var isESNRequired;
  var palletID;
  List<CartonList> obj_cartonList;

  var customerOrderNumber;
  var condition;
  var companyID;
  var itemCompanyGUID;
  var userID;
  var orderDateTime;

  _TransientOrderSubmitPage(this.memoNumber,this.orderDate,this.status,
      this.sku,this.category,this.name,this.supplier,this.cartonCount,
      this.orderQty,this.transientOrderID,this.isESNRequired,this.palletID,this.obj_cartonList
      ,this.customerOrderNumber
      ,this.condition,this.orderDateTime,this.companyID,this.itemCompanyGUID,this.userID,);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;
  bool _isLoading = false;

  List<CartonList> cartonList = <CartonList>[];
  List<String> esnList = <String>[];
  String cartonId="";
  List<String> cartonQty = <String>[];
  int _orderQty=0;

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
    for(int m=0;m<obj_cartonList.length;m++){
      if(!obj_cartonList[m].isDelete){
        cartonId=obj_cartonList[m].cartonID.toString();
        textFeildList.add(customField());
        cartonQty.add(obj_cartonList[m].quantityPerCarton.toString());
        _orderQty=_orderQty+(obj_cartonList[m].quantityPerCarton as int);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
          callSubmitOrderApi();
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
        child: submitButton,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text('Transient Receive',textAlign: TextAlign.center,
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:  Column(
                children: <Widget>[
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        memoNumber.toString(),
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
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderDate.toString() ,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )),

                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        status.toString() ,
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
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sku.toString(),
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
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.toString(),
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
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name.toString() ,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        supplier.toString() ,
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

                        ],
                      ),
                    ),
                  ),
                 const SizedBox(
                    height: 20,
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child:  Row(
                    children: <Widget>[
                      Text(
                        'Cartons',
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

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
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
                                  children: [
                                    Expanded(child: textFeildList[index]),
                                    const SizedBox(width: 60,),
                                    GestureDetector(
                                        onTap: () {
                                        },
                                        child: index < 0
                                            ? Container()
                                            : Text(cartonQty[index],)),
                                  ],
                                ),
                               const Divider(
                                   color: Colors.black
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
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  callSubmitOrderApi() async {
     var noOfContainers=textFeildList.length;
     //var orderQty=(noOfContainers*10);

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? token = myPrefs.getString("token");
    String? _userId= myPrefs.getString("userId");
    for(int m=0;m<obj_cartonList.length;m++){
      obj_cartonList[m].warehouseLocation="";
    }
    var _cartonList = obj_cartonList.map((e){
      return {
        "cartonID": e.cartonID,
        "warehouseLocation": e.warehouseLocation,
        "isDelete": e.isDelete,
        "palletID": e.palletID,
        "quantityPerCarton": e.quantityPerCarton,
        "errorMessage": e.errorMessage,
        "esnList": e.esnList
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap" );
    var url = "https://api.langlobal.com/transientreceive/v1/transientOrder";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "transientOrderID": transientOrderID,
      "memoNumber": memoNumber,
      "customerOrderNumber": customerOrderNumber,
      "condition": condition,
      "transientOrderDateTime": orderDateTime,
      "companyID": int.parse(companyID!),
      "itemCompanyGUID":itemCompanyGUID,
      "supplierName": supplier,
      "orderedQty": _orderQty,
      "isESNRequired": isESNRequired,
      "userID": _userId,
      "noOfContainers": noOfContainers,
      "cartonList":jsonstringmap,
      "accessoryList":esnList
    });
    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");
    // var jsonRequest = json.decode(body); \"
    print("requestParams$body" );
    var response =
    await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        var returnMessage=jsonResponse['returnMessage'];
        if(returnCode=="1"){
          _showResultDialog(returnMessage);
        }else{
          Navigator.of(context).pop();
          _showToast(returnMessage);
        }
      } catch (e) {
        Navigator.of(context).pop();
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(context).pop();
      print(response.statusCode);
    }
    print(response.body);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showResultDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardPage('')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
