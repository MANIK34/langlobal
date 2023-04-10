import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/warehouseAllocation/cartonConsolidation/consolidationConfirmationPage.dart';

class CartonSubmitPage extends StatefulWidget {
  var heading;

  CartonSubmitPage(this.heading,  {Key? key}) : super(key: key);

  @override
  _CartonSubmitPage createState() =>
      _CartonSubmitPage(this.heading );
}

class _CartonSubmitPage extends State<CartonSubmitPage> {
  var heading;


  _CartonSubmitPage(this.heading );

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

    final destinationField = TextField(
        maxLength: 11,
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConsolidationConfirmationPage('')),
          );

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
            const Text('Cartons Consolidation',textAlign: TextAlign.center,
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:  Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cartons Consolidation - View & Submit',
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
                  Row(
                    children: <Widget>[
                      Text('Category',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      Text(' I ',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text('SKU',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                                Text('Destination Cartons:'),
                                Spacer(),
                                Text('1'),
                              ],
                            ),),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              children: <Widget>[
                                Text('Warehouse Location:'),
                                Spacer(),
                                Text('1'),
                              ],
                            ),),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              children: <Widget>[
                                Text('Total Qty:'),
                                Spacer(),
                                Text('5'),
                              ],
                            ),),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              children: <Widget>[
                                Text('Source Cartons:'),
                                Spacer(),
                                Text('10'),
                              ],
                            ),),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Carton Allocations',
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
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
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
                                    Spacer(),
                                    GestureDetector(
                                        onTap: () {
                                          textFeildList.removeAt(index);
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
}
