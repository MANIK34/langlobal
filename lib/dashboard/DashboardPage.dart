import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:langlobal/summary/shipment/shipmentSearch.dart';
import 'package:langlobal/warehouseAllocation/cartonAssignment/cartonAssignmentPage.dart';
import 'package:langlobal/warehouseAllocation/cartonConsolidation/cartonConsolidationPage.dart';
import 'package:langlobal/warehouseAllocation/cartonCreations/creationConfiguration.dart';
import 'package:langlobal/warehouseAllocation/cartonLookup/cartonLookupPage.dart';
import 'package:langlobal/warehouseAllocation/skuLookup/skuLookupPage.dart';
import '../drawer/drawerElement.dart';
import '../locationLookup/locationLookupPage.dart';
import '../summary/fulfillment/orderSearchPage.dart';
import '../summary/stockinDemand/stockinDemandPage.dart';
import '../summary/stockinHand/stockinHandPage.dart';
import '../transientSearch/transientOrderSearch.dart';
import '../warehouseAllocation/inventoryLookup/inventoryLookupPage.dart';
import '../warehouseAllocation/movement/cartonMovement.dart';


class DashboardPage extends StatefulWidget {
  String token = '';

  DashboardPage(this.token, {Key? key}) : super(key: key);

  @override
  _DashboardPage createState() => _DashboardPage(this.token);
}

class _DashboardPage extends State<DashboardPage> {
  String token = '';

  _DashboardPage(this.token);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black);
  bool _isLoading = false;


  Widget appBarTitle = const Text(
    "Home",
    style: TextStyle(
        fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.black),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Image.asset('assets/lan_global_icon.jpeg'),iconSize: 300, onPressed: () {  },
                ),
              ],
            ),
            drawer: DrawerElement(),
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 70.0),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                    children: <Widget>[
                      const SizedBox(height: 25.0),
                      Padding(
                          padding: const EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 110,
                                width: 160,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => OrderSearchPage("")),
                                    );
                                  },
                                  child: Card(
                                      color: Colors.blue,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/bill_detail.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text('Fulfillment',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 16)),
                                              )),
                                        ],
                                      )),
                                ),
                              ),
                              Container(
                                  height: 110,
                                  width: 160,
                                  child: GestureDetector(
                                    onTap: () {

                                    },
                                    child: Card(
                                        color: Colors.purple,
                                        semanticContainer: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/graph.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Text('Returns',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        )),
                                  )),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 110,
                                  width: 160,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => TransientOrderSearchPage('')),
                                      );
                                    },
                                    child: Card(
                                        color: Colors.orange,
                                        semanticContainer: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/ecs.png',
                                              width: 40,
                                              height: 40,
                                            ),
                                            const Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    0.0,
                                                    10,
                                                    0.0,
                                                    0.0),
                                                child: Align(
                                                  alignment:
                                                  Alignment.center,
                                                  child: Text('Transient Receive',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize: 16)),
                                                )),
                                          ],
                                        )),
                                  )),
                              Container(
                                height: 110,
                                width: 160,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CartonMovementPage('')),
                                    );
                                  },
                                  child: Card(
                                      color: Colors.blueGrey,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/profile.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                          const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text('Movement',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 16)),
                                              )),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 110,
                                  width: 160,
                                  child: GestureDetector(
                                    onTap: () {
                                      showCartonsDialog();
                                    },
                                    child: Card(
                                        color: Colors.green,
                                        semanticContainer: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/monitor_db.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Text('Cartons',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16)),
                                            ),
                                          ],
                                        )),
                                  )),
                              Container(
                                height: 110,
                                width: 160,
                                child: GestureDetector(
                                  onTap: () {

                                  },
                                  child: Card(
                                      color: Colors.cyan,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/nsdl.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 10, 0.0, 0.0),
                                            child: Text('Quarantine',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 110,
                                width: 160,
                                child: GestureDetector(
                                  onTap: () {
                                  },
                                  child: Card(
                                      color: Colors.indigo,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/gst.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text('Utilities',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 16)),
                                              )),
                                        ],
                                      )),
                                ),
                              ),
                              Container(
                                  height: 110,
                                  width: 160,
                                  child: GestureDetector(
                                    onTap: () {
                                      showSummaryDialog();
                                    },
                                    child: Card(
                                        color: Colors.yellow.shade700,
                                        semanticContainer: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/sms.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Text('Summary ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16,
                                                      fontFamily:
                                                      'Montserrat')),
                                            ),
                                          ],
                                        )),
                                  )),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 110,
                                width: 160,
                                child: GestureDetector(
                                    onTap: () {
                                      showWarehouseDialog();
                                    },
                                    child: Card(
                                      color: Colors.blueGrey.shade600,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/payee_user.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text('Warehouse',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 16)),
                                              )),
                                        ],
                                      ),
                                    )),
                              ),
                              Visibility(
                                child: SizedBox(
                                height: 110,
                                width: 160,
                                child: GestureDetector(
                                    onTap: () {
                                      showInventoryDialog();
                                    },
                                    child: Card(
                                      color: Colors.redAccent,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/graph.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text('Inventory',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 16)),
                                              )),
                                        ],
                                      ),
                                    )),
                              ),)
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 110,
                                width: 160,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ShipmentSearchPage('')),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.teal,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/payee_user.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  0.0, 10, 0.0, 0.0),
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text('Shipment',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 16)),
                                              )),
                                        ],
                                      ),
                                    )),
                              ),
                              Visibility(
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: false,
                                child: SizedBox(
                                  height: 110,
                                  width: 160,
                                  child: GestureDetector(
                                      onTap: () {
                                        showInventoryDialog();
                                      },
                                      child: Card(
                                        color: Colors.redAccent,
                                        semanticContainer: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/graph.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            const Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    0.0, 10, 0.0, 0.0),
                                                child: Align(
                                                  alignment:
                                                  Alignment.center,
                                                  child: Text('Inventory',
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize: 16)),
                                                )),
                                          ],
                                        ),
                                      )),
                                ),)
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }


  void showInventoryDialog(){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.only(
                  topRight: Radius
                      .circular(
                      50.0),
                  topLeft: Radius
                      .circular(
                      50.0))),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment
                .center,
            mainAxisSize:
            MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Select Option',
                style: TextStyle(
                    fontWeight:
                    FontWeight
                        .bold,
                    color:
                    Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  child: const Text(
                      'Serialized Inventory Lookup'),
                  style: ElevatedButton
                      .styleFrom(
                      primary: Colors.orange,
                      minimumSize:
                      const Size(
                          250,
                          50) // put the width and height you want
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InventoryLookupPage('')),
                    );
                  }),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  child: const Text(
                      'SKU Lookup'),
                  style: ElevatedButton
                      .styleFrom(
                      primary: Colors.orange,
                      minimumSize:
                      const Size(
                          250,
                          50) // put the width and height you want
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SkuLookupPage('')),
                    );
                  }),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }
  void showWarehouseDialog(){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.only(
                  topRight: Radius
                      .circular(
                      50.0),
                  topLeft: Radius
                      .circular(
                      50.0))),
          child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .center,
              mainAxisSize:
              MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Select Option',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold,
                      color:
                      Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    child: const Text(
                        'Location Lookup'),
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LocationLookupPage('')),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
        );
      },
    );
  }

  void showSummaryDialog(){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.only(
                  topRight: Radius
                      .circular(
                      50.0),
                  topLeft: Radius
                      .circular(
                      50.0))),
          height: 350,
          child: Center(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .center,
              mainAxisSize:
              MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Select Option',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold,
                      color:
                      Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    child: const Text(
                        'Stock in Hand'),
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StockInHandPage('')),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    child: const Text(
                        'Stock Demand'),
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StockInDemandlPage("")),
                      );
                    }),
               /* const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    child: const Text(
                        'Shipments'),
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShipmentSearchPage('')),
                      );
                    }),*/
                /*const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    child: const Text(
                        'Fulfillment'),
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderSearchPage("")),
                      );
                    }),*/
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    child: const Text(
                        'SO Requests'),
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                    }),

              ],
            ),
          ),
        );
      },
    );
  }

  void showCartonsDialog(){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.only(
                  topRight: Radius
                      .circular(
                      50.0),
                  topLeft: Radius
                      .circular(
                      50.0))),
          height: 350,
          child: Center(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .center,
              mainAxisSize:
              MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Select Option',
                  style: TextStyle(
                      fontWeight:
                      FontWeight
                          .bold,
                      color:
                      Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartonAssignmentPage('')),
                      );
                    },
                    child: const Text(
                        'Assignment')),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartonConsolidationPage('')),
                      );
                    },
                    child: const Text(
                        'Consolidation')),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreationConfigurationPage('')),
                      );
                    },
                    child: const Text(
                        'Creations')),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton
                        .styleFrom(
                        primary: Colors.orange,
                        minimumSize:
                        const Size(
                            250,
                            50) // put the width and height you want
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartonLookupPage('')),
                      );
                    },
                    child: const Text(
                        'Lookup')),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
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
