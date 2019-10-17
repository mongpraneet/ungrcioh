import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungrcioh/screens/my_service.dart';
import 'package:ungrcioh/screens/my_style.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
// Explicit
  String name, detail, urlPathPicture, qrCode;
  final formKey = GlobalKey<FormState>();
  File file;

// Methond
  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 48.0,
        color: Colors.purple,
      ),
      onPressed: () {
        cameraThread();
      },
    );
  }

  Future<void> cameraThread() async {
    var objFile = await ImagePicker.pickImage(
      maxWidth: 800.0,
      maxHeight: 480.0,
      source: ImageSource.camera,
    );

    setState(() {
      file = objFile;
    });
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 48.0,
        color: Colors.green.shade900,
      ),
      onPressed: () {
        galleryThred();
      },
    );
  }

  Future<void> galleryThred() async {
    var objGallery = await ImagePicker.pickImage(
      maxHeight: 800.0,
      maxWidth: 480.0,
      source: ImageSource.gallery,
    );

    setState(() {
      file = objGallery;
    });
  }

  Widget pictureButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              cameraButton(),
              galleryButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget picture() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child:
          file == null ? Image.asset('images/picture.png') : Image.file(file),
    );
  }

  Widget nameText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Name :'),
            onSaved: (String value) {
              name = value.trim();
            },
          ),
        ),
      ],
    );
  }

  Widget detailText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: TextFormField(
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(labelText: 'Detail :'),
            onSaved: (String value) {
              detail = value.trim();
            },
          ),
        ),
      ],
    );
  }

  Widget myContent() {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          nameText(),
          detailText(),
          picture(),
          pictureButton(),
        ],
      ),
    );
  }

  Widget uploadValueButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            color: MyStyle().textColor,
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            label: Text(
              'Upload Value',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              formKey.currentState.save();
              checkValue();
            },
          ),
        ),
      ],
    );
  }

  void checkValue() {
    if ((name.isEmpty) || (detail.isEmpty)) {
      // Have space
      myAlert('Have Space', 'Plese Fill All Blank');
    } else if (file == null) {
      myAlert('Non Choose', 'Plese Choose Picture by Camera of Galler');
    } else {
      uploadValueButton();
    }
  }

  Future<void> uploadPicture() async {
    int ranInt = Random().nextInt(10000);
    qrCode = 'p$ranInt';

    String namePricture = '$qrCode.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Product/$namePricture');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    await (await storageUploadTask.onComplete)
        .ref
        .getDownloadURL()
        .then((response) {
      urlPathPicture = response;
      print('urlPath = $urlPathPicture');
      updateFireStore();
    });
  }

  Future<void> updateFireStore() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Product');

    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Detail'] = detail;
    map['PathImage'] = urlPathPicture;
    map['QRcode'] = qrCode;

    await collectionReference.document().setData(map).then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());

      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        uploadValueButton(),
        myContent(),
      ],
    );
  }
}
