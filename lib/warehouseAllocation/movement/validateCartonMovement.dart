import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langlobal/dashboard/DashboardPage.dart';
import 'package:langlobal/drawer/drawerElement.dart';
import 'package:langlobal/warehouseAllocation/movement/cartonMovementValidatePage.dart';

class ValidateCartonMovementPage extends StatefulWidget {
  var heading;

  ValidateCartonMovementPage(this.heading, {Key? key}) : super(key: key);

  @override
  _ValidateCartonMovementPage createState() => _ValidateCartonMovementPage(this.heading);
}

class _ValidateCartonMovementPage extends State<ValidateCartonMovementPage> {
  var heading;

  _ValidateCartonMovementPage(this.heading);

  List<Widget> textFeildList = [];
  List<TextEditingController> controllers = []; //the controllers list

  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool readOnly = true;
  TextEditingController skuController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String btn_text="Validate";

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
        if (value.length == 6) {
          textFeildList.add(customField());
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
  }

  @override
  Widget build(BuildContext context) {
    final sourceField = TextField(
        maxLength: null,
        autofocus: true,
        controller: skuController,
        style: style,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Source Location",
          alignLabelWithHint: true,
          hintText: "Source Location",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ));

    final validateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: 250,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartonMovementValidate('')),
          );

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
            ExpandTapWidget(
              tapPadding: EdgeInsets.all(55.0),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage('')),
                );
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
}
