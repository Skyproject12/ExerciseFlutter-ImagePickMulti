import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return ViewImages(
          index,
          asset,
          key: UniqueKey(),
        );
      }),
    );
  }

  requestPermissions() async {
    // List<PermissionName> permissionNames = [];
    // permissionNames.add(PermissionName.Camera);
    // permissionNames.add(PermissionName.Storage);
    // message = '';
    // var permissions = await Permission.requestPermissions(permissionNames);
    // permissions.forEach((permission) {
    //   message += '${permission.permissionName}: ${permission.permissionStatus}\n';
    // }); 
    // final res = await Permission.requestPermissions([PermissionName.Camera, PermissionName.Storage]);
    // res.forEach((permission) {});
    setState(() {});
  }
  

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      requestPermissions();
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
        options: CupertinoOptions(takePhotoIcon: "chat"),
      );
    } on PlatformException catch (e) {
      error = e.message;
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Multiple Images Example'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Select the multiple images '),
                RaisedButton(
                  child: Text(
                    "Click",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: loadAssets,
                ),
                //                Icon(Icons.camera_alt,color: Colors.blue,)
              ],
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Error: $_error',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(color: Color(0x0FF000000))),
              ),
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }
}
