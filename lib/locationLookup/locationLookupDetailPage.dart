import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/locationLookup/locationLookupPage.dart';
 

class LocationLookupDetailPage extends StatefulWidget {
  var cartonContent;

  LocationLookupDetailPage(this.cartonContent,
      {Key? key}) : super(key: key);

  @override
  _LocationLookupDetailPage createState() =>
      _LocationLookupDetailPage(this.cartonContent);
}

class _LocationLookupDetailPage extends State<LocationLookupDetailPage> {
  var cartonContent;

  _LocationLookupDetailPage(this.cartonContent);

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool autoFocus=false;

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list
  var esnValue;
  bool _visibleImei=false;

  Widget customField({GestureTapCallback? removeWidget}) {
    TextEditingController controller = TextEditingController();
    controller.text=esnValue.toString();
    controllers.add(controller);
    for (int i = 0; i < controllers.length; i++) {
      print(
          controllers[i].text); //printing the values to show that it's working
    }
    return Text(esnValue.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationLookupPage('')),
          );
        },
        child: Text("New Lookup",
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
            const Text('Location Lookup',textAlign: TextAlign.center,
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
            reverse: false,
            child: Padding(
              padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child:  Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                                      Text('Location:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['location'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['locationType'].toString(),style: TextStyle(
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
                                      Text('Aisle:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['aisle'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Bay:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['bay'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('I'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Level:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(cartonContent['level'].toString(),style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10,right: 10,),
                                child:  Row(
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
                                                  ),
                                                ),
                                                Text(
                                                  cartonContent['cartonCount'].toString(),
                                                  style: TextStyle(
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
                                                  ),
                                                ),
                                                Text(
                                                  cartonContent['itemsCount'].toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),),

                        Padding(padding: EdgeInsets.only(left: 10,right: 10),
                        child: Column(
                          children: <Widget>[
                        const Align(
                        alignment: Alignment.centerLeft,
                          child: Text(
                            'Carton Assignments',
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
                        const SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.only(left: 0,right: 0),child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cartonContent['skuList'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  color: Colors.grey,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5,right: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        const SizedBox(height: 2,),
                                        Wrap(
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(cartonContent['skuList'][index]['categoryName'],style: TextStyle(
                                                    fontWeight: FontWeight.normal
                                                ),),
                                                Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                                  child:Text("I"),),
                                                Text(cartonContent['skuList'][index]['condition'],style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2,),
                                        Align(
                                          child: Text(cartonContent['skuList'][index]['sku'],style: TextStyle(
                                              fontWeight: FontWeight.normal
                                          ),),
                                          alignment: Alignment.centerLeft,
                                        ),

                                        Align(
                                          child: Text(cartonContent['skuList'][index]['productName'],style: TextStyle(
                                              fontWeight: FontWeight.normal
                                          ),),
                                          alignment:Alignment.centerLeft ,
                                        ),
                                        const SizedBox(height: 2,),
                                      ],
                                    )
                                  )
                                ),
                                Padding(padding: EdgeInsets.only(left: 0,right: 0),
                                child: Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: cartonContent['skuList'][index]['cartons'].length,
                                    itemBuilder: (BuildContext context, int indexx) {
                                      return Column(
                                        children: <Widget>[
                                         Container(
                                           height: 30,
                                           child:  Row(
                                             children: [
                                               Text(
                                                 ""+ (indexx+1).toString()+". ",
                                               ),
                                               Text(cartonContent['skuList'][index]['cartons'][indexx]['cartonID'].toString(),style: TextStyle(
                                                   fontWeight: FontWeight.bold
                                               ),),
                                               Padding(padding: EdgeInsets.only(left: 5,right: 5),
                                                 child:Text("I"),),
                                               Text(cartonContent['skuList'][index]['cartons'][indexx]['qtyPerCarton'].toString(),style: TextStyle(
                                                   fontWeight: FontWeight.bold
                                               ),),
                                               Spacer(),
                                               Text(cartonContent['skuList'][index]['cartons'][indexx]['assignedDate'].toString(),style: TextStyle(
                                                   fontWeight: FontWeight.bold
                                               ),),
                                             ],
                                           ),
                                         ),
                                          const Divider(
                                              color: Colors.black
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),)

                              ],
                            );
                          },
                        ),)
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
}
