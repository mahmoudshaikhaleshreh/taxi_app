import 'package:TaxiApp/component/alert.dart';
import 'package:TaxiApp/pages/delivery.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:TaxiApp/component/crud.dart';
import 'package:TaxiApp/main.dart';
// My Import

class OrdersDelivery extends StatefulWidget {
  OrdersDelivery({Key key}) : super(key: key);

  @override
  _OrdersDeliveryState createState() => _OrdersDeliveryState();
}

class _OrdersDeliveryState extends State<OrdersDelivery> {
  var resid;
  var driverid = prefs.getString("id");
  Map data;
  Crud crud = new Crud();
  setLocal() async {
    await Jiffy.locale("ar");
  }

  @override
  void initState() {
    data = {"driverid": driverid, "status": 1.toString()};
    setLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: driverid == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder(
                future: crud.writeData("orders", data),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data[0] == "faild") {
                      return Center(
                          child: Text(
                        "لا يوجد اي طلبات قيد التوصيل",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListOrders(
                          orders: snapshot.data[index],
                          driverid: driverid,
                          crud: crud,
                          context: context,
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ));
  }
}

class ListOrders extends StatelessWidget {
  final orders;
  final driverid;
  final crud;
  final context;
  ListOrders({Key key, this.orders, this.driverid, this.crud, this.context})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        showLoading(context);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return Delivery(
              orderid: orders['orderstaxi_id'],
              statusorders: 1.toString(),
              userid: orders['orderstaxi_user'],
              lat: orders['orderstaxi_lat'],
              long: orders['orderstaxi_long'],
              destlat: orders['orderstaxi_lat_dest'],
              destlong: orders['orderstaxi_long_dest']);
        }));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Container(
                margin: EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "معرف الطلبية : ${orders['orderstaxi_id']}",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "اسم الزبون : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['username']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "هاتف الزبون  : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['user_phone']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "مسافة الطلب   : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text:
                                  "${orders['orderstaxi_distancekm']} كيلو متر",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: " السعر الكلي   : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['orderstaxi_price']} د.ك",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600))
                        ])),
                  ],
                ),
              ),
              trailing: Container(
                  margin: EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${Jiffy(orders['orders_date']).fromNow()}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
            ),
            Container(
              padding:
                  EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
              child: Row(
                children: [
                  Text(
                    "قيد التوصيل",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.3),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "التفاصيل",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          )),
                      onTap: () {
                        showLoading(context);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return Delivery(
                              orderid: orders['orderstaxi_id'],
                              statusorders: 1.toString(),
                              userid: orders['orderstaxi_user'],
                              lat: orders['orderstaxi_lat'],
                              long: orders['orderstaxi_long'],
                              destlat: orders['orderstaxi_lat_dest'],
                              destlong: orders['orderstaxi_long_dest']);
                        }));
                      } // approveDelivery,
                      )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
