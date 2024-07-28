import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:wastatussaver/constants.dart' as cnst;
import 'package:wastatussaver/constants.dart';

import 'viewphotos.dart';

Directory _newPhotoDir = Directory(Constants().waPath);

// );

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});
  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Constants.isBussiness.listen((onData) {
      print(onData);
      if (mounted) {
        setState(() {
          _newPhotoDir = Directory(Constants().waPath);
        });
      }
    });
    if (!Directory(_newPhotoDir.path).existsSync()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () {
              return Text(
                cnst.Constants.isBussiness.value == true
                    ? "Install WhatsApp Business\n"
                    : 'Install WhatsApp\n',
                style: const TextStyle(fontSize: 18.0),
              );
            },
          ),
          const Text(
            "Your Friend's Status Will Be Available Here",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
    } else {
      final imageList = _newPhotoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.jpg') || item.endsWith('.png'))
          .toList(growable: false);
      if (imageList.isNotEmpty) {
        return Container(
            margin: const EdgeInsets.all(8.0),
            child: GridView.builder(
              key: PageStorageKey(widget.key),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150),
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                final String imgPath = imageList[index];
                return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPhotos(
                              imgPath: imgPath,
                            ),
                          ),
                        ).then((onValue) {
                          setState(() {});
                        });
                      },
                      child: Image.file(
                        File(imageList[index]),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                      ),
                    ));
              },
            )
            // child: StaggeredGrid.count(
            //   crossAxisCount: 4,
            //   children: [
            //     ...imageList.map((imgPath) => StaggeredGridTile.count(
            //           crossAxisCellCount: 2,
            //           mainAxisCellCount:
            //               imageList.indexOf(imgPath).isEven ? 2 : 3,
            //           child: Material(
            //             elevation: 8.0,
            //             borderRadius: const BorderRadius.all(Radius.circular(8)),
            //             child: InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => ViewPhotos(
            //                       imgPath: imgPath,
            //                     ),
            //                   ),
            //                 );
            //               },
            //               child: Hero(
            //                   tag: imgPath,
            //                   child: Image.file(
            //                     File(imgPath),
            //                     fit: BoxFit.cover,
            //                   )),
            //             ),
            //           ),
            //         ))
            //   ],
            //   mainAxisSpacing: 8.0,
            //   crossAxisSpacing: 8.0,
            // ),
            );
      } else {
        return Scaffold(
          body: Center(
            child: Container(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: const Text(
                  'Sorry, No Image Found!',
                  style: TextStyle(fontSize: 18.0),
                )),
          ),
        );
      }
    }
  }
}
