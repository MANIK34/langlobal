import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/warehouseAllocation/movement/cartonMovementValidatePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/requestParams/cartonList2.dart';

class ValidateCartonMovementPage extends StatefulWidget {
  var sourceLocation;

  ValidateCartonMovementPage(this.sourceLocation, {Key? key}) : super(key: key);

  @override
  _ValidateCartonMovementPage createState() => _ValidateCartonMovementPage(this.sourceLocation);
}

class _ValidateCartonMovementPage extends State<ValidateCartonMovementPage> {
  var sourceLocation;

  _ValidateCartonMovementPage(this.sourceLocation);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly = true;
  BuildContext? _context;
  String btn_text="Validate";
  List<CartonList2> cartonList = <CartonList2>[];

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
      ],
      maxLength: 20,
      autofocus: true,
      showCursor: true,
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        textFeildList.add(customField());
      },
    /*  onChanged: (value) {
        if (value.length == 6) {
          textFeildList.add(customField());
        }
      },*/
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
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          buildShowDialog(context);
          callCartonMovementApi();
        },
        child: Text(btn_text,
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
          children: [
            const Text(
              'Inventory Movement',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            /*ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
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
                  Visibility(
                    visible: true,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cartons to Move',
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
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
                                      Expanded(child: textFeildList[index]),
                                      GestureDetector(
                                          onTap: () {
                                            textFeildList.removeAt(index);
                                            controllers.removeAt(index);
                                            setState(() {});
                                          },
                                          child: index < 0
                                              ? Container()
                                              : const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
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
      "destinationLocation": '',
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
            MaterialPageRoute(builder: (context) =>
                CartonMovementValidate(jsonResponse['movementInfo'],sourceLocation)),
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
