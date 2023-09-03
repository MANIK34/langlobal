import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:langlobal/model/requestParams/cartonProvisioning.dart';
import 'package:langlobal/summary/fulfillment/provisioning/confirmationPage.dart';
import 'package:langlobal/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../dashboard/DashboardPage.dart';
import '../../../model/requestParams/cartonList2.dart';
import '../../../model/responseParams/returnCartonList.dart';
import 'lineItem.dart';

class NonSerializedInventoryPage extends StatefulWidget {
  var fulfillmentInfo;
  var lineItemIndex;

  NonSerializedInventoryPage(this.fulfillmentInfo,this.lineItemIndex, {Key? key}) : super(key: key);

  @override
  _NonSerializedInventoryPage createState() => _NonSerializedInventoryPage(fulfillmentInfo,lineItemIndex);
}

class _NonSerializedInventoryPage extends State<NonSerializedInventoryPage> {
  var fulfillmentInfo;
  var lineItemIndex;

  _NonSerializedInventoryPage(this.fulfillmentInfo,this.lineItemIndex);

  String orderDate = "";
  String shipmentDate="";
  bool _isLoading = false;
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = [];
  List<CartonList2> cartonList = <CartonList2>[];

  //List<Widget> textFeildListQty = [];
  List<TextEditingController> controllersQty = [];

  var bg_color=Colors.grey.shade800;
  var txt_color=Colors.grey.shade400;
  bool _visibleLineItem=false;
  BuildContext? _context;
  List<CartonProvisioningList> cartonProList = <CartonProvisioningList>[];
  List<String> trackingList=[];
  late String? _trackingList = null;
  String trackingNumber="";
  var jsonstringmap;
  var returnCartons;
  List<ReturnCartonList> returnCartonList = <ReturnCartonList>[];
  List<ReturnCartonList> returnCartonList2 = <ReturnCartonList>[];
  var skuQty="";
  String addedCartonValue = "";

  Utilities _utilities = Utilities();


  Widget customField({GestureTapCallback? removeWidget}) {

    TextEditingController controller = TextEditingController();
    controller.text=addedCartonValue;
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
      ],
      maxLength: 20,
      autofocus: true,
      showCursor: true,
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        if(controllers[textFeildList.length-1].text!=""){
          textFeildList.add(customField());
          ReturnCartonList obj= ReturnCartonList();
          obj.assignedQty="";
          returnCartonList.add(obj);
        }
      },
      decoration: InputDecoration(
        hintText: "Carton ID",
        counterText: "",
      ),
    );
  }

  /*Widget customFieldQty({GestureTapCallback? removeWidget}) {

    TextEditingController controller = TextEditingController();

    controllersQty.add(controller);
    for (int i = 0; i < controllersQty.length; i++) {
      print(
          controllersQty[i].text); //printing the values to show that it's working
    }
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
      ],
      maxLength: 20,
      autofocus: true,
      showCursor: true,
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        if(controllersQty[textFeildListQty.length-1].text!=""){
          textFeildListQty.add(customField());
        }
      },
      decoration: InputDecoration(
        hintText: "Qty",
        counterText: "",
      ),
    );
  }*/
  @override
  void initState() {
    // TODO: implement initState
    _utilities.checkUserConnection();

    super.initState();

    for (int m = 0; m < Utilities.cartonProList.length; m++) {
      if (Utilities.cartonProList[m].skuID == fulfillmentInfo['lineItems'][lineItemIndex]['sku']) {
        addedCartonValue=Utilities.cartonProList[m].cartonID.toString();
        textFeildList.add(customField());

        ReturnCartonList obj= ReturnCartonList();
        obj.assignedQty=Utilities.cartonProList[m].assignedQty.toString();
        returnCartonList.add(obj);
      }
    }
    if(textFeildList.isEmpty){
      textFeildList.add(customField());
      ReturnCartonList obj= ReturnCartonList();
      obj.assignedQty="";
      returnCartonList.add(obj);
    }else{
      skuQty=fulfillmentInfo['lineItems'][lineItemIndex]['qty'].toString();
    }


   // textFeildListQty.add(customFieldQty());

    orderDate=fulfillmentInfo['fulfillmentDate'];
    orderDate=orderDate.toString().substring(0,10);
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(orderDate);
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    orderDate = formatter.format(tempDate);

    shipmentDate=fulfillmentInfo['requestedShipDate'];
    shipmentDate=shipmentDate.toString().substring(0,10);
    tempDate = new DateFormat("yyyy-MM-dd").parse(shipmentDate);
    formatter = DateFormat('MM/dd/yyyy');
    shipmentDate = formatter.format(tempDate);

    trackingList.add('Select Tracking Number');
    for(int m=0;m<fulfillmentInfo['shipments'].length;m++){
      trackingList.add(fulfillmentInfo['shipments'][m]['trackingNumber']);
    }
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
          hint: const Text("Select Tracking Number",style: TextStyle(
              fontSize: 12
          ),),
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
              child: Text(map,style: const TextStyle(fontSize: 12),),
            );
          }).toList(),
        ),
      ),
    );

    final backToLookup = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: 100,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            print("trackingNumber ::::: " + trackingNumber);
            if (trackingNumber == "") {
              _showToast('Please select tracking number');
            }else if(!Utilities.ActiveConnection){
              _showToast("No internet connection found!");
            }
            else {
              callSerializedApi();
            }
          });
        },
        child: Text("Validate",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 10,
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final sourceCartons = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: bg_color,
      child: MaterialButton(
        minWidth:100,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          for(int m=0;m<Utilities.cartonProList.length;m++){
            if(Utilities.cartonProList[m].skuID==fulfillmentInfo['lineItems'][lineItemIndex]['sku']){
              Utilities.cartonProList.remove(Utilities.ImeisList[m]);
            }
          }
          int skuTotalAssignedQty=0;
          for (int i = 0; i < controllers.length; i++) {
            if(controllers[i].text! != ""){
              skuTotalAssignedQty=skuTotalAssignedQty= returnCartons[i]['assignedQty'];
              CartonProvisioningList obj= CartonProvisioningList(cartonID: controllers[i].text!,
                  assignedQty: returnCartons[i]['assignedQty'],
                  itemCompanyGUID:  fulfillmentInfo['lineItems'][lineItemIndex]['itemCompanyGUID'],
                  quantity:  fulfillmentInfo['lineItems'][lineItemIndex]['qty'],warehouseLocation: "",
                  skuID: fulfillmentInfo['lineItems'][lineItemIndex]['sku'],
                  trackingNumber: trackingNumber);
              Utilities.cartonProList.add(obj);
            }
          }
          fulfillmentInfo['lineItems'][lineItemIndex]['assignedQty']=skuTotalAssignedQty;
          print("array values non serialized ::::: "+Utilities.cartonProList.length.toString());
          print("array values1 non serialized ::::: "+Utilities.cartonProList[0].cartonID.toString());
          //print("array values2 non serialized ::::: "+Utilities.cartonProList[1].cartonID.toString());

          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LineItemPage(fulfillmentInfo,true)),
          );
        },
        child: Text("Line Items",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 10,
                color: txt_color, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            backToLookup,
            SizedBox(width: 5,),
            Visibility(
              visible: _visibleLineItem,
              child: sourceCartons,
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text('Fulfillment Provisioning',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.bold),
            ),
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
      body: SafeArea(
        child: SingleChildScrollView(
            reverse: false,
            child: Padding(
              padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child:  Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[

                        orderInfo(),
                        Padding(padding: EdgeInsets.only(left: 10,right: 10),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Assignments - Shipment Label:',
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
                                Row(
                                  children: <Widget>[
                                    Text('Tracking#:',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                    SizedBox(width: 250,
                                      height: 35,
                                      child: trackingDropdown,),

                                  ],
                                ),
                              ],
                            )),
                        Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Assignments - Non Serialized Inventory:',
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
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                          child: Row(
                            children: <Widget>[
                              Text('S.NO.'),
                              SizedBox(width: 10,),
                              SizedBox(width: 110,child:Text('Carton#'),),
                              Spacer(),
                              SizedBox(width: 30,child: Text('Qty')),
                              Text('Assignment\nQty',textAlign: TextAlign.center,)
                            ],
                          )
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 30),
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
                                      Text(
                                        ""+ (index+1).toString()+". ",
                                      ),
                                      SizedBox(width: 25,),
                                      SizedBox(width: 200,child:textFeildList[index],),
                                      SizedBox(width: 25,),
                                      SizedBox(width: 20,child: Text(skuQty)),
                                      SizedBox(width: 25,),
                                      SizedBox(width: 20,child: Text(returnCartonList[index].assignedQty.toString(),textAlign: TextAlign.center,)),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        ),
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

  Widget orderInfo(){
    return(
        Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fulfillmentInfo['orderType'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                  Text(
                    fulfillmentInfo['fulfillmentNumber'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                  Text(
                    fulfillmentInfo['orderStatus'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10,0,10,0),
              child: Divider(
                thickness: 4,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Text('Customer Order:'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text( fulfillmentInfo['customerOrderNumber'],
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Text('Order Date:'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(orderDate,style:
                          TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      const Text(
                                        'Req. Shipment Date: ',
                                        style: TextStyle(),
                                      ),
                                      Text(
                                        shipmentDate,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
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
        )
    );
  }


  void callSerializedApi() async{
    buildShowDialog(context);

    cartonProList= <CartonProvisioningList>[];
    for (int i = 0; i < controllers.length; i++) {
      if(controllers[i].text! != ""){
        CartonProvisioningList obj= CartonProvisioningList(cartonID: controllers[i].text!,assignedQty: 0, itemCompanyGUID:  fulfillmentInfo['lineItems'][lineItemIndex]['itemCompanyGUID'],
        quantity:  fulfillmentInfo['lineItems'][lineItemIndex]['qty'],warehouseLocation: "",trackingNumber: trackingNumber);
        cartonProList.add(obj);
      }
    }
    var _cartonList = cartonProList.map((e){
      return {
        "cartonID": e.cartonID,
        "assignedQty": e.assignedQty,
        "itemCompanyGUID": e.itemCompanyGUID,
        "quantity": e.quantity,
        "warehouseLocation": e.warehouseLocation,
        "trackingNumber": e.trackingNumber
      };
    }).toList();
    jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap" );

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? token = myPrefs.getString("token");
    String? companyID = myPrefs.getString("companyID");

    var url="https://api.langlobal.com/fulfillment/v1/provisoningnonserialized";

    var body = json.encode(
        {
          "action": "validate",
          "companyID": companyID!,
          "fulfillmentID": fulfillmentInfo['fulfillmentID'],
          "itemCompanyGUID": fulfillmentInfo['lineItems'][lineItemIndex]['itemCompanyGUID'],
          "quantity": fulfillmentInfo['lineItems'][lineItemIndex]['qty'],
          "cartons":jsonstringmap,
        });
    body=body.replaceAll("\"[", "[");
    body=body.replaceAll("]\"", "]");
    body=body.replaceAll("\\\"", "\"");
    print("StockInHandPage$body" );

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token!}'
    };
    print("requestParams$body");
    var response = await http.post(Uri.parse(url),body: body, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        var returnCode=jsonResponse['returnCode'];
        if(returnCode=="1"){
          returnCartons=jsonResponse['cartons'];
          var list = jsonResponse['cartons'] as List;
          setState(() {
            _visibleLineItem=true;
            skuQty=fulfillmentInfo['lineItems'][lineItemIndex]['qty'].toString();
            returnCartonList2= list.map((data) => ReturnCartonList.fromJson(data)).toList();
            for(int m=0;m<returnCartonList2.length;m++){
              returnCartonList[m].assignedQty=returnCartonList2[m].assignedQty.toString();
            }
          });
        }else{
          _showToast(jsonResponse['returnMessage']);
        }
      } catch (e) {
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      print(response.statusCode);
    }
    Navigator.of(_context!).pop();
    debugPrint(response.body);
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
