import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:langlobal/drawer/drawerElement.dart';

import '../../dashboard/DashboardPage.dart';
import 'cartonMovement.dart';

class CartonMovementConfirmation extends StatefulWidget {
  var movementInfo;
  var sourceLocation;
  var destinationLocation;

  CartonMovementConfirmation(this.movementInfo,this.sourceLocation,this.destinationLocation,  {Key? key}) : super(key: key);

  @override
  _CartonMovementConfirmation createState() =>
      _CartonMovementConfirmation(this.movementInfo,this.sourceLocation,this.destinationLocation,);
}

class _CartonMovementConfirmation extends State<CartonMovementConfirmation> {
  var movementInfo;
  var sourceLocation;
  var destinationLocation;


  _CartonMovementConfirmation(this.movementInfo,this.sourceLocation,this.destinationLocation,);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly=true;
  TextEditingController skuController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Widget customField({GestureTapCallback? removeWidget}) {

    TextEditingController controller = TextEditingController();
    controllers.add(controller);
    return Text(
        'Carton ID'
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

    final skuField = TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z _ -]")),
        ],
        maxLength: 50,
        controller: skuController,
        style: style,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "SKU",
          alignLabelWithHint: true,
          hintText: "SKU",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final locationField = TextField(
        maxLength: 11,
        controller: locationController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Location",
          alignLabelWithHint: true,
          hintText: "Location",
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonMovementPage('')),
          );
        },
        child: Text("New Carton Movement",
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
                      'Carton Movement - Confirmation',
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Carton(s) are successfully moved to location.',
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
                                        'Source Location: ',
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
                                        'Destination Location: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        destinationLocation,
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
                                  child:  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Location Type:',
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
                                  ),),

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
}
