import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';
import 'package:video_player/video_player.dart';

import 'video_controller.dart';

class PlayStatus extends StatefulWidget {
  final String videoFile;
  bool saved;
  PlayStatus({
    super.key,
    required this.videoFile,
    this.saved = false,
  });
  @override
  _PlayStatusState createState() => _PlayStatusState();
}

class _PlayStatusState extends State<PlayStatus> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Saved in Gallary',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            color: Colors.brown.shade700,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  var _fabMiniMenuItemList = [
    Icons.sd_card,
    Icons.share,
    // Icons.reply,
    // Icons.wallpaper,
    Icons.delete_outline,
  ];

  @override
  Widget build(BuildContext context) {
    _fabMiniMenuItemList = [
      if (!widget.saved) Icons.sd_card,
      Icons.share,
      // Icons.reply,
      // Icons.wallpaper,
      Icons.delete_outline,
    ];
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: StatusVideo(
          videoPlayerController:
              VideoPlayerController.file(File(widget.videoFile)),
          looping: true,
          videoSrc: widget.videoFile,
        ),
        // ),
        floatingActionButton: SpeedDialFabWidget(
          secondaryIconsList: _fabMiniMenuItemList,
          secondaryIconsText: [
            if (!widget.saved) "Save",
            "Share",
            // "Repost",
            // "Set As",
            "Delete",
          ],
          secondaryIconsOnPress: [
            if (!widget.saved)
              () async {
                _onLoading(true, '');

                // Get the application documents directory
                Directory appDocDir = (await getDownloadsDirectory())!;
                String appDocPath = appDocDir.path;

                try {
                  final curDate = DateTime.now().toString();

                  // Destination file path in the app's documents directory
                  String destinationFilePath = '$appDocPath/VIDEO-$curDate.mp4';

                  await File(widget.videoFile).copy(destinationFilePath);
                  if (kDebugMode) {
                    print('File copied successfully.');
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print('Error copying file: $e');
                  }
                }

                // if (!Directory('/storage/emulated/0/wa_status_saver')
                //     .existsSync()) {
                //   Directory('/storage/emulated/0/wa_status_saver')
                //       .createSync(recursive: true);
                // }
                // final path = directory.path;

                _onLoading(
                  false,
                  'Video Saved',
                );
              },
            () async {
              // print(widget.imgPath);

              await Share.shareFiles([widget.videoFile], text: 'Great picture');
              return;
            },
            // () => {},
            // () => {},
            () async {
              final file = File(widget.videoFile);
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
        ));
  }
}
