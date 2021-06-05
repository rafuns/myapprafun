import 'dart:convert';
import 'dart:io';
import 'package:franchisecare/class/drawer.dart';

import 'package:flutter/material.dart';
import 'package:franchisecare/models/customer.dart';
import 'package:franchisecare/models/news.dart';
//import 'package:pgprepnepalfinal/pages/subcategories.dart';

import 'package:franchisecare/class/fetchData.dart';
import 'package:franchisecare/common/database.dart';

import 'package:franchisecare/widgets/customer_preseneter.dart';
import 'package:franchisecare/widgets/customer_list.dart';

DataAPi alldata = new DataAPi();

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage>
    implements CustomerContract {
  CustomerPresenter customerPresenter;

  @override
  void initState() {
    super.initState();
    customerPresenter = new CustomerPresenter(this);
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.center;

    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text(
              'View Customers',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: _buildTitle(context),
//        actions: _buildActions(),
      ),
      drawer: FDrawer(),
      body: new FutureBuilder<List<Customer>>(
        future: customerPresenter.getMyCustomers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          return snapshot.hasData
              ? new CustomerList(data, customerPresenter)
              : new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
