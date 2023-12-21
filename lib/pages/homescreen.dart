import 'dart:math';

import 'package:flutter/material.dart';
import 'package:TaxiApp/component/crud.dart';
import 'package:TaxiApp/component/getnotify.dart';
import 'package:TaxiApp/component/location.dart';
import 'package:TaxiApp/pages/editaccount/editaccount.dart';
import 'package:TaxiApp/pages/stagedelivery/home.dart';
import 'package:TaxiApp/pages/stagedelivery/ordersdelivery.dart';
import 'package:TaxiApp/pages/stagedelivery/ordersdonedelivery.dart';
import 'package:TaxiApp/main.dart';

class HomeScreen extends StatefulWidget {
  final initialpage;
  HomeScreen({Key key, this.initialpage}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Crud crud = new Crud();

  var email, password, username, userid, phone;

  getprefs() {
    userid = prefs.getString("id");
    username = prefs.getString("username");
    email = prefs.getString("email");
    phone = prefs.getString("phone");
    password = prefs.getString("password");
    // if (this.mounted) {
    //   setState(() {});
    // }
  }

  @override
  void initState() {
    requestPermissionLocation(context);
    getprefs();
    getNotify(context);
    requestPermissons();
    getLocalNotification();
    requestLocalPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
            initialIndex: widget.initialpage == "home"
                ? 0
                : widget.initialpage == "wait"
                    ? 1
                    : widget.initialpage == "done"
                        ? 2
                        : 0,
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text('TalabGo'),
                actions: [
                  IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.of(context).pushNamed("message");
                      }),
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () async {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return EditAccount(
                            email: email,
                            userid: userid,
                            password: password,
                            phone: phone,
                            username: username,
                          );
                        }));
                      }),
                ],
                leading: IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      var taxiid = prefs.getString("id");
                      var token = prefs.getString("token");
                      Map data = {"texiid": taxiid, "texitoken": token};
                      await crud.writeData("logout", data);
                      prefs.clear();
                      Navigator.of(context).pushReplacementNamed("login");
                    }),
                bottom: TabBar(
                  tabs: [
                    Text("بانتظار الموافقة"),
                    Text("قيد التوصيل "),
                    Text("تم التوصيل")
                  ],
                ),
              ),
              body: TabBarView(
                  children: [Home(), OrdersDelivery(), OrdersDoneDelivery()]),
            )));
  }
}
