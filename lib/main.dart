// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';

// void main() {
//   runApp(MaterialApp(
//     home: Image_Labelling(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

// class Image_Labelling extends StatefulWidget {
//   @override
//   _Image_LabellingState createState() => _Image_LabellingState();
// }

// class _Image_LabellingState extends State<Image_Labelling> {
//   // File _image;
//   PickedFile _image;
//   File image;
//   final ImagePicker picker = ImagePicker();
//   String _found = '';
//   List<ImageLabel> labels;
//   var listResult;

//   // ignore: non_constant_identifier_names
//   Future imageLabel(PickedFile imagefile) async {
//     String result = 'No Result';
//     // final imageFile = await picker.getImage(source: ImageSource.gallery);

//     final image = File(imagefile.path);
//     final firebaseImage = FirebaseVisionImage.fromFile(image);
//     final ImageLabeler imageLabeler =
//         await FirebaseVision.instance.imageLabeler(
//       ImageLabelerOptions(confidenceThreshold: 0.75),
//     );
//     // final List<ImageLabel> labels =
//     //     await imageLabeler.processImage(firebaseImage);
//     labels = await imageLabeler.processImage(firebaseImage);
//     for (ImageLabel label in labels) {
//       final String text = label.text;
//       final double confidence = (label.confidence * 100);
//       result = '\n${confidence.toStringAsFixed(0)}% chance there is a $text';

//       setState(() {
//         // _labels = labels;
//         this.image = File(imagefile.path);
//         this._found = result;
//         this.labels = labels;
//         listResult =
//             '\n${confidence.toStringAsFixed(0)}% chance there is a $text';
//         print(result);
//       });
//     }

//     // if (mounted) {
//     //   setState(() {
//     //     image = image;
//     //     _labels = labels;
//     //   });
//     // }
//     //  return getTextWidgets(labels);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black54,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 12,
//         title: Text(
//           "Choose an image...",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.0,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           this._image == null
//               ? Center(
//                   child: Text(
//                     'Select an image...',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600, color: Colors.white),
//                   ),
//                 )
//               : Expanded(
//                   child: Image.file(
//                     this.image,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//           Expanded(
//             child: ListTile(
//               // title: this._found == null
//               title: listResult == null
//                   ? Text('No Results')
//                   : SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Text(
//                           // this._found,
//                           listResult,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//               // : Center(
//               //     child: Text(
//               //       this._found,
//               //       style: TextStyle(color: Colors.white),
//               //     ),
//               //   ),
//               //),

//               // child: SingleChildScrollView(
//               //   scrollDirection: Axis.vertical,
//               //   child: Text(
//               //     this._found,
//               //     style: TextStyle(color: Colors.white, fontSize: 15),
//               //   ),
//               //   // child: getTextWidgets(this.labels),
//             ),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.white,
//         onPressed: () {
//           setState(() async {
//             _image = await picker.getImage(source: ImageSource.gallery);
//             imageLabel(_image);
//           });
//         },
//         tooltip: 'pick an image',
//         child: Icon(
//           Icons.camera_alt,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }

// Widget getTextWidgets(List<ImageLabel> labels) {
//   for (ImageLabel label in labels) {
//     final String text = label.text;
//     final double confidence = (label.confidence * 100);
//     // final  String result = '\n${confidence.toStringAsFixed(0)}% there is a $text';
//     return new Row(
//         children: labels
//             .map((item) => new Text(
//                 '\n${confidence.toStringAsFixed(0)}% chance there is a $text'))
//             .toList());
//   }
// }
import 'dart:io';
import 'barcodeScanner.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;
  var text = '';
  PickedFile _image;
  File image;
  final ImagePicker picker = ImagePicker();

  bool imageLoaded = false;

  Future pickImage() async {
    _image = await picker.getImage(source: ImageSource.gallery);
    // var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    var awaitImage = File(_image.path);

    setState(() {
      pickedImage = awaitImage;
      imageLoaded = true;
    });

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);

    final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler(
      ImageLabelerOptions(confidenceThreshold: 0.75),
    );

    final List<ImageLabel> labels =
        await imageLabeler.processImage(visionImage);

    for (ImageLabel label in labels) {
      final double confidence = label.confidence * 100;
      // result = '\n${confidence.toStringAsFixed(0)}% chance there is a $text';
      setState(() {
        text =
            '\n${confidence.toStringAsFixed(0)}% chance there is a ${label.text}';

        print(text);
      });
    }

    imageLabeler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Choose an image...."),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          SizedBox(height: 100.0),
          imageLoaded
              ? Center(
                  child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(blurRadius: 20),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  height: 250,
                  child: Image.file(
                    pickedImage,
                    fit: BoxFit.cover,
                  ),
                ))
              : Container(),
          SizedBox(height: 10.0),
          // Center(
          //   child: FlatButton.icon(
          //     icon: Icon(
          //       Icons.photo_camera,
          //       color: Colors.white,
          //       size: 100,
          //     ),
          //     label: Text(''),
          //     textColor: Theme.of(context).primaryColor,
          //     onPressed: () async {
          //       pickImage();
          //     },
          //   ),
          // ),
          SizedBox(height: 10.0),
          SizedBox(height: 10.0),
          text == ''
              ? Text('Text will display here')
              : Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Colors.white,
      //     child: Icon(
      //       Icons.camera_alt,
      //       color: Colors.black,
      //     ),
      //     onPressed: () async {
      //       pickImage();
      //     }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: Colors.white,
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              onPressed: () async {
                pickImage();
              }),
          SizedBox(
            height: 30.0,
          ),
          FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Colors.white,
              child: Icon(
                Icons.code,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarcodeScannerPage()),
                );
              })
        ],
      ),
    );
  }
}

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  File pickedImage;
  var text = '';
  PickedFile _image;
  File image;
  final ImagePicker picker = ImagePicker();

  bool imageLoaded = false;

  Future pickImageBarcode() async {
    _image = await picker.getImage(source: ImageSource.camera);
    // var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    var awaitImage = File(_image.path);

    setState(() {
      pickedImage = awaitImage;
      imageLoaded = true;
    });

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);

    final BarcodeDetector barcodeDetector =
        FirebaseVision.instance.barcodeDetector();

    final List<Barcode> barcodes =
        await barcodeDetector.detectInImage(visionImage);

    for (Barcode barcode in barcodes) {
      final String rawValue = barcode.rawValue;
      final BarcodeValueType valueType = barcode.valueType;

      setState(() {
        text = "Value: $rawValue\nType: $valueType";
      });
    }

    barcodeDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Choose an image....",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          SizedBox(height: 100.0),
          imageLoaded
              ? Center(
                  child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(blurRadius: 20),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  height: 250,
                  child: Image.file(
                    pickedImage,
                    fit: BoxFit.cover,
                  ),
                ))
              : Container(),
          SizedBox(height: 10.0),
          SizedBox(height: 10.0),
          SizedBox(height: 10.0),
          text == ''
              ? Text('Text will display here')
              : Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: Colors.white,
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              onPressed: () async {
                pickImageBarcode();
              }),
          SizedBox(
            height: 30.0,
          ),
          FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Colors.white,
              child: Icon(
                Icons.code,
                color: Colors.black,
              ),
              onPressed: () async {
                pickImageBarcode();
              }),
        ],
      ),
    );
  }
}
