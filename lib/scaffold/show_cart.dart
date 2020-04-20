import 'package:flutter/material.dart';
import 'package:foodlion/models/order_model.dart';
import 'package:foodlion/utility/my_style.dart';
import 'package:foodlion/utility/sqlite_helper.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  // Filed
  List<OrderModel> orderModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future<void> readSQLite() async {
    try {
      var object = await SQLiteHelper().readDatabase();
      print("object length ==>> ${object.length}");
      if (object.length != 0) {
        setState(() {
          orderModels = object;
        });
      }
    } catch (e) {
      print('e readSQLite ==>> ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้า'),
      ),
      body: orderModels.length == 0
          ? Center(
              child: Text(
                'ยังไม่มี รายการอาหาร คะ',
                style: MyStyle().h1PrimaryStyle,
              ),
            )
          : showContent(),
    );
  }

  Column showContent() {
    return Column(
      children: <Widget>[
        showListCart(),
        showBottom(),
        orderButton(),
      ],
    );
  }

  Widget orderButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          color: MyStyle().primaryColor,
          onPressed: () {},
          icon: Icon(
            Icons.check_box,
            color: Colors.white,
          ),
          label: Text(
            'สั่งซื่อ',
            style: MyStyle().hiStyleWhite,
          ),
        ),
      );

  Widget showSum(String title, String message, Color color) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            title,
            style: MyStyle().hiStyleWhite,
          ),
          Text(
            message,
            style: MyStyle().hiStyleWhite,
          ),
        ],
      ),
    );
  }

  Widget showBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: <Widget>[
              showSum('ค่าขอส่ง', 'aa', MyStyle().lightColor),
              showSum('รวมราคา', 'aa', MyStyle().dartColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget showListCart() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            headTitle(),
            Expanded(
              child: ListView.builder(
                  itemCount: orderModels.length,
                  itemBuilder: (value, index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              orderModels[index].nameFood,
                              style: MyStyle().h2NormalStyle,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              orderModels[index].priceFood,
                              style: MyStyle().h2NormalStyle,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              orderModels[index].amountFood,
                              style: MyStyle().h2NormalStyle,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              calculateTotal(orderModels[index].priceFood,
                                  orderModels[index].amountFood),
                              style: MyStyle().h2NormalStyle,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: MyStyle().dartColor,
                                ),
                                onPressed: () {}),
                          ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    );
  }

  String calculateTotal(String price, String amount) {
    int princtInt = int.parse(price);
    int amountInt = int.parse(amount);
    int total = princtInt * amountInt;
    return total.toString();
  }

  Row headTitle() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Text(
            'รายการอาหาร',
            style: MyStyle().h2Style,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'ราคา',
            style: MyStyle().h2Style,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'จำนวน',
            style: MyStyle().h2Style,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'รวม',
            style: MyStyle().h2Style,
          ),
        ),
      ],
    );
  }
}
