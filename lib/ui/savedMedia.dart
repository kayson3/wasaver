import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wastatussaver/ui/viewphotos.dart';
import 'package:wastatussaver/utils/video_play.dart';

class Savedmedia extends StatefulWidget {
  const Savedmedia({super.key});

  @override
  State<Savedmedia> createState() => _SavedmediaState();
}

class _SavedmediaState extends State<Savedmedia> {
  Future<String?> _getImage(videoPathUrl) async {
    //await Future.delayed(Duration(milliseconds: 500));
    final thumb = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumb;
  }

  Directory? savedPath = Directory(
      '/storage/emulated/0/Android/data/com.example.wastatussaver/files/downloads');

  getAppDirectory() async {
    print((await getDownloadsDirectory()));
    print(await getExternalStorageDirectory());
    // setState(() async {
    //   savedPath = await getDownloadsDirectory();
    //   print(savedPath?.path);
    // });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This function is called after the widget is rendered on screen
      getAppDirectory();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!savedPath!.existsSync()) {
      return const Center(
        child: Text(
          'No Media Saved Yet',
          style: TextStyle(fontSize: 18.0),
        ),
      );
    } else {
      final imageList = savedPath!
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.jpg') || item.endsWith('.png'))
          .toList(growable: false);

      final videoList = savedPath!
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.mp4'))
          .toList(growable: false);

      List bothList = [...imageList, ...videoList];

      bothList.shuffle();

      if (bothList.isNotEmpty) {
        return Container(
            margin: const EdgeInsets.all(8.0),
            child: GridView.builder(
              key: PageStorageKey(widget.key),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150),
              itemCount: bothList.length,
              itemBuilder: (BuildContext context, int index) {
                final String imgPath = bothList[index];

                if (imgPath.endsWith('.mp4')) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayStatus(
                              videoFile: imgPath,
                              saved: true,
                            ),
                          )).then((onValue) {
                        setState(() {});
                      }),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                              colors: [
                                Color(0xffb7d8cf),
                                Color(0xffb7d8cf),
                                Color(0xffb7d8cf),
                                Color(0xffb7d8cf),
                                Color(0xffb7d8cf),
                              ],
                            ),
                          ),
                          child: FutureBuilder<String?>(
                              future: _getImage(imgPath),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    return Hero(
                                      tag: imgPath,
                                      child: Image.file(
                                        File(snapshot.data!),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                } else {
                                  return Hero(
                                    tag: imgPath,
                                    child: SizedBox(
                                      height: 280.0,
                                      child: Image.asset(
                                          'assets/images/video_loader.gif'),
                                    ),
                                  );
                                }
                              }),
                          //new cod
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                      margin: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPhotos(
                                imgPath: imgPath,
                                saved: true,
                              ),
                            ),
                          ).then((onValue) {
                            setState(() {});
                          });
                        },
                        child: Image.file(
                          File(imgPath),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                        ),
                      ));
                }
              },
            ));
      } else {
        return const Center(
          child: Text(
            'Sorry, No Saved Media Found.',
            style: TextStyle(fontSize: 18.0),
          ),
        );
      }
    }
  }
}
