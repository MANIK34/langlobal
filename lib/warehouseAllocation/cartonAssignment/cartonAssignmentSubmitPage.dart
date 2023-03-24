import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/model/requestParams/cartonList2.dart';
import 'package:langlobal/warehouseAllocation/cartonAssignment/cartonAssignmentSuccessfulPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartonAssignmentSubmitPage extends StatefulWidget {
  var sku;
  var category;
  var productName;
  var totalCartons;
  var itemCount;
  List<CartonList2> obj_cartonList;
  var location;
  var conditionValue;

  CartonAssignmentSubmitPage(
      this.sku,
      this.category,
      this.productName,
      this.totalCartons,
      this.itemCount,
      this.obj_cartonList,
      this.location,
      this.conditionValue,
      {Key? key})
      : super(key: key);

  @override
  _CartonAssignmentSubmitPage createState() => _CartonAssignmentSubmitPage(
      this.sku,
      this.category,
      this.productName,
      this.totalCartons,
      this.itemCount,
      this.obj_cartonList,
      this.location,
      this.conditionValue);
}

class _CartonAssignmentSubmitPage extends State<CartonAssignmentSubmitPage> {
  var sku;
  var category;
  var productName;
  var totalCartons;
  var itemCount;
  List<CartonList2> obj_cartonList;
  var location;
  var conditionValue;

  _CartonAssignmentSubmitPage(
      this.sku,
      this.category,
      this.productName,
      this.totalCartons,
      this.itemCount,
      this.obj_cartonList,
      this.location,
      this.conditionValue);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly = true;
  String cartonId = "";

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text = cartonId;
    controllers.add(controller);
    return Text(cartonId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int m = 0; m < obj_cartonList.length; m++) {
      cartonId = obj_cartonList[m].cartonID.toString();
      textFeildList.add(customField());
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
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
          callCartonAssignmentSubmitApi();
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
          children: [
            const Text(
              'Inventory Allocation',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
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
            child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Carton Assignment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  color: Color.fromRGBO(40, 40, 43, 6.0),
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
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              "I",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              sku,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              "I",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              conditionValue.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
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
                                productName,
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
                                  const Text(
                                    'Total Cartons: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    totalCartons.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
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
                                    'Items Count: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    itemCount.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          const Text(
                            'Warehouse Location: ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            location.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
                  'Cartons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  color: Color.fromRGBO(40, 40, 43, 6.0),
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
                                const SizedBox(
                                  width: 60,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
        )),
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

  void callCartonAssignmentSubmitApi() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? companyID = myPrefs.getString("companyID");
    String? userID = myPrefs.getString("userId");
    print("userId ::"+userID!);
    String? token = myPrefs.getString("token");
    print(token);
    var _cartonList = obj_cartonList.map((e){
      return {
        "cartonID": e.cartonID,
        "assignedQty": e.assignedQty,
      };
    }).toList();
    var jsonstringmap = json.encode(_cartonList);
    print("_cartonList$jsonstringmap" );
    var url = "https://api.langlobal.com/inventoryallocation/v1/cartonassignment";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${token!}',
      "Accept": "application/json",
      "content-type":"application/json"
    };
    var body = json.encode({
      "userID": userID!,
      "companyID": int.parse(companyID!),
      "sku": sku,
      "location": location,
      "cartons":jsonstringmap,
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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartonAssignmentSuccessfulPage(sku,category,productName
                ,totalCartons,itemCount,conditionValue)),
          );
        }else{
          _showToast("Something went wrong!!");
        }
      } catch (e) {
        Navigator.of(context).pop();
        print("error message ::"+e.toString());
        print('returnCode'+e.toString());
        // TODO: handle exception, for example by showing an alert to the user
      }
    } else {
      Navigator.of(context).pop();
      print(response.statusCode);
    }
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
