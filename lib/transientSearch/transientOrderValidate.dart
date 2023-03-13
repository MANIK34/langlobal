import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:langlobal/transientSearch/transientOrderSubmit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/requestParams/cartonList.dart';

class TransientOrderValidatePage extends StatefulWidget {
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
  var customerOrderNumber;
  var condition;
  var companyID;
  var itemCompanyGUID;
  var userID;
  var orderDateTime;

  TransientOrderValidatePage(this.memoNumber,this.orderDate,this.status,
      this.sku,this.category,this.name,this.supplier,this.cartonCount,
      this.orderQty,this.transientOrderID,this.isESNRequired,this.palletID,this.customerOrderNumber
  ,this.condition,this.orderDateTime,this.companyID,this.itemCompanyGUID,this.userID,{Key? key}) : super(key: key);

  @override
  _TransientOrderValidatePage createState() =>
      _TransientOrderValidatePage(this.memoNumber,this.orderDate,this.status,
          this.sku,this.category,this.name,this.supplier,this.cartonCount,
          this.orderQty,this.transientOrderID,this.isESNRequired,this.palletID,this.customerOrderNumber
        ,this.condition,this.orderDateTime,this.companyID,this.itemCompanyGUID,this.userID,);
}

class _TransientOrderValidatePage extends State<TransientOrderValidatePage> {
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

  var customerOrderNumber;
  var condition;
  var companyID;
  var itemCompanyGUID;
  var userID;
  var orderDateTime;

  _TransientOrderValidatePage(this.memoNumber,this.orderDate,this.status,
      this.sku,this.category,this.name,this.supplier,this.cartonCount,
      this.orderQty,this.transientOrderID,this.isESNRequired,this.palletID,this.customerOrderNumber
      ,this.condition,this.orderDateTime,this.companyID,this.itemCompanyGUID,this.userID,);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;
  bool _isLoading = false;

  List<CartonList> cartonList = <CartonList>[];
  List<CartonList> cartonList2 = <CartonList>[];
  List<String> esnList = <String>[];

  Widget customField({GestureTapCallback? removeWidget}) {

    TextEditingController controller = TextEditingController();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return TextField(
      autofocus: true,
      showCursor: true,
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        textFeildList.add(customField());
      },
      onChanged: (value) {
        if (value.length == 20) {
          //textFeildList.add(customField());
        }
      },
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
    print("Dispose called");
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

  @override
  Widget build(BuildContext context) {

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth:250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
            buildShowDialog(context);
            callValidateOrderApi();
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
              child:  _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  :Column(
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
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Carton count: ' ,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            cartonCount.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
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
                                            'Ordered Qty: ' ,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            orderQty.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
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
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cartons',
                      style: TextStyle(
                        fontSize: 24,
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
                            return Row(
                              children: [
                                Expanded(child: textFeildList[index]),
                                GestureDetector(
                                    onTap: () {
                                      textFeildList.removeAt(index);
                                      setState(() {});
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

   callValidateOrderApi() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? token = myPrefs.getString("token");
    print(token);
    cartonList= <CartonList>[];
    for (int i = 0; i < controllers.length; i++) {
      if(controllers[i].text! != ""){
        CartonList obj= CartonList(cartonID: controllers[i].text!,isDelete: false, palletID: palletID,
            quantityPerCarton: cartonCount,warehouseLocation: "upper", errorMessage: "none",esnList: esnList);
        cartonList.add(obj);
      }
    }
    var _cartonList = cartonList.map((e){
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
    var url = "https://api.langlobal.com/transientreceive/v1/transientOrder/validate";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "companyID": int.parse(companyID!),
      "transientOrderID": transientOrderID,
      "source": "Mobile",
      "isESN": isESNRequired,
      "cartonList":jsonstringmap,
    });
    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");
   // var jsonRequest = json.decode(body); \"
    print("requestParams$body" );
    var response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.of(context).pop();
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          _showToast("Validate successfully!");

          var jsonArray = jsonResponse['cartons'];
          for (int m = 0; m < jsonArray.length; m++) {
              CartonList list = CartonList(cartonID: jsonArray[m]['cartonID'], warehouseLocation: jsonArray[m]['warehouseLocation'],
                  isDelete: jsonArray[m]['isDelete'], palletID: palletID, quantityPerCarton: jsonArray[m]['quantityPerCarton'],
                  errorMessage: jsonArray[m]['errorMessage'], esnList: esnList);
              cartonList2.add(list);

          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransientOrderSubmitPage(memoNumber,orderDate,
                status,sku,category,name,supplier,cartonCount,orderQty,transientOrderID,isESNRequired,palletID,cartonList2
            ,customerOrderNumber,condition,orderDateTime,companyID,itemCompanyGUID,userID)),
          );
        }else{
          _showToast("Something went wrong!!");
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
  }


}
