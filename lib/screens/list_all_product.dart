import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ungrcioh/models/product_model.dart';
import 'package:ungrcioh/screens/my_style.dart';

class ListAllProduct extends StatefulWidget {
  @override
  _ListAllProductState createState() => _ListAllProductState();
}

class _ListAllProductState extends State<ListAllProduct> {
  // Explicit
  List<ProductModel> productModels = [];

  // Method
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFireStore();
  }

  Future<void> readFireStore() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Product');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;
      for (var snapshot in snapshots) {
        print('name = ${snapshot.data['Name']}');

        ProductModel productModel = ProductModel.fromFireStore(snapshot.data);
        //productModels.add(productModel);
        setState(() {
          productModels.add(productModel);
        });
      }
    });
  }

  Widget showImage(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Image.network(productModels[index].pathImage),
    );
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          showName(index),
          showDetailShot(index),
        ],
      ),
    );
  }

  Widget showName(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          productModels[index].name,
          style: TextStyle(
            color: MyStyle().textColor,
            fontSize: MyStyle().h2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget showDetailShot(int index) {
    String detail = productModels[index].detail;
    if (detail.length > 50) {
      detail = detail.substring(0, 50);
      detail = '$detail ...';
    }
    return Text(detail);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[showImage(index), showText(index)],
        );
      },
    );
  }
}
