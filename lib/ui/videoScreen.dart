import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wastatussaver/constants.dart' as cnst;
import 'package:wastatussaver/constants.dart';

import '../utils/video_play.dart';

Directory videoDir = Directory(Constants().waPath);

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});
  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
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
          videoDir = Directory(Constants().waPath);
        });
      }
    });
    if (!Directory(videoDir.path).existsSync()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Text(
              cnst.Constants.isBussiness.value == true
                  ? "Install WhatsApp Business and watch a video status\n"
                  : 'Install WhatsAppand view and watch a video status\n',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          const Text(
            "Your Friend's Status Will Be Available Here",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
    } else {
      return VideoGrid(directory: videoDir);
    }
  }
}

class VideoGrid extends StatefulWidget {
  final Directory? directory;

  const VideoGrid({super.key, this.directory});

  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  Future<String?> _getImage(videoPathUrl) async {
    //await Future.delayed(Duration(milliseconds: 500));
    final thumb = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    final videoList = widget.directory!
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith('.mp4'))
        .toList(growable: false);

    if (videoList.isNotEmpty) {
      if (videoList.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: GridView.builder(
            itemCount: videoList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.0,
              mainAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayStatus(
                      videoFile: videoList[index],
                      images: videoList,
                      index: index,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                        future: _getImage(videoList[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Hero(
                                tag: videoList[index],
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
                              tag: videoList[index],
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
              );
            },
          ),
        );
      } else {
        return const Center(
          child: Text(
            'Sorry, No Videos Found.',
            style: TextStyle(fontSize: 18.0),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
