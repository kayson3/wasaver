import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';

class ViewPhotos extends StatefulWidget {
  final String imgPath;
  final bool saved;
  final List images;
  final int index;
  const ViewPhotos({
    super.key,
    required this.imgPath,
    this.saved = false,
    required this.images,
    required this.index,
  });

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  var filePath;
  int currentindex = 0;

  final LinearGradient backgroundGradient = const LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x00333333),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  var _fabMiniMenuItemList = [
    Icons.sd_card,
    Icons.share,
    // Icons.reply,
    // Icons.wallpaper,
    Icons.delete_outline,
  ];

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      Get.snackbar('Success', 'Saved in Gallary!!',
          backgroundColor: Colors.white, icon: const Icon(Icons.sd_card));
      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (BuildContext context) {
      //       return Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: SimpleDialog(
      //           children: <Widget>[
      //             Center(
      //               child: Container(
      //                 padding: const EdgeInsets.all(15.0),
      //                 child: Column(
      //                   children: <Widget>[
      //                     const Text(
      //                       'Saved in Gallary',
      //                       style: TextStyle(
      //                           fontSize: 20, fontWeight: FontWeight.bold),
      //                     ),
      //                     const Padding(
      //                       padding: EdgeInsets.all(10.0),
      //                     ),
      //                     // Text(str,
      //                     //     style: const TextStyle(
      //                     //       fontSize: 16.0,
      //                     //     )),
      //                     // const Padding(
      //                     //   padding: EdgeInsets.all(10.0),
      //                     // ),
      //                     // Text('FileManager > wa_status_saver',
      //                     //     style: TextStyle(
      //                     //         fontSize: 16.0, color: Colors.brown[700])),
      //                     // const Padding(
      //                     //   padding: EdgeInsets.all(10.0),
      //                     // ),
      //                     MaterialButton(
      //                       color: Colors.brown.shade700,
      //                       textColor: Colors.white,
      //                       onPressed: () => Navigator.pop(context),
      //                       child: const Text('Close'),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     });
    }
  }

  @override
  Widget build(BuildContext context) {
    currentindex = widget.index;
    _fabMiniMenuItemList = [
      if (!widget.saved) Icons.sd_card,
      Icons.share,
      Icons.delete_outline,
    ];

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.indigo,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView(
        controller: PageController(initialPage: widget.index),
        onPageChanged: (v) {
          currentindex = v;
        },
        children: widget.images.map((v) {
          return Center(
            child: Image.file(
              File(v),
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ),
      floatingActionButton: SpeedDialFabWidget(
        secondaryIconsList: _fabMiniMenuItemList,
        // secondaryIconsText: [
        //   if (!widget.saved) "",

        //   "",
        //   // "Repost",
        //   // "Set As",
        //   "",
        // ],
        secondaryIconsOnPress: [
          if (!widget.saved)
            () async {
              // _onLoading(true, '');

              // final myUri = Uri.parse(widget.images[currentindex]);
              // final originalImageFile = File.fromUri(myUri);
              // late Uint8List bytes;
              // await originalImageFile.readAsBytes().then((value) {
              //   bytes = Uint8List.fromList(value);
              // }).catchError((onError) {});

              // await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
              // _onLoading(false,
              //     'If Image not available in gallary\n\nYou can find all images at');

              // var status = Permission.manageExternalStorage;
              // if (await status.isDenied) {
              //   Permission.mediaLibrary.request();
              // }

              _onLoading(true, '');

              await Permission.storage.request();

              try {
                Directory appDocDir = (await getDownloadsDirectory())!;
                String appDocPath = appDocDir.path;
                // final path = directory.path;
                final curDate = DateTime.now().toString();
                String destinationFilePath = '$appDocPath/VIDEO-$curDate.png';
                await File(widget.images[currentindex])
                    .copy(destinationFilePath);
                _onLoading(
                  false,
                  'Image Saved',
                );
              } on FileSystemException catch (e) {
                print('Error copying file: $e');
              }
            },
          () async {
            // print(widget.images[currentindex]);

            await Share.shareFiles([widget.images[currentindex]],
                text: 'Great picture');
            return;
          },
          // () => {},
          // () => {},
          () async {
            final file = File(widget.images[currentindex]);
            try {
              await file.delete().then((onValue) {
                Navigator.of(context).pop();
              });

              // setState(() {});
            } catch (error) {
              // print(error);
              Fluttertoast.showToast(
                  msg: "File aready deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
        ],
        primaryIconExpand: Icons.add,
        primaryIconCollapse: Icons.add,
        secondaryBackgroundColor: Colors.brown.shade700,
        secondaryForegroundColor: Colors.white,
        primaryBackgroundColor: Colors.brown.shade700,
        primaryForegroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
