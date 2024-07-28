import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:wastatussaver/constants.dart' as cnst;

import 'dashboard.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});
  final html =
      '<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Galery :)</p><p>- You can also Use Multiple Saving. [to do]</p>';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status Saver',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown.shade700,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              color: Colors.white,
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              }),
          Obx(
            () {
              cnst.Constants.isBussiness.value;
              return PopupMenuButton<String>(
                onSelected: choiceAction,
                color: Colors.white,
                iconColor: Colors.white,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              );
            },
          )
        ],
        bottom: TabBar(tabs: [
          Container(
            padding: const EdgeInsets.all(12.0),
            child: const Text(
              'IMAGES',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            child: const Text(
              'VIDEOS',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(12.0),
            child: const Text(
              'SAVED',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ]),
      ),
      body: const Dashboard(),

      floatingActionButton: FloatingActionButton(
          child: Obx(
            () => cnst.Constants.isBussiness.value
                ? Image.asset('assets/images/whatsapp.png')
                : Image.asset(
                    'assets/images/wabusiness.png',
                    fit: BoxFit.fill,
                  ),
          ),
          onPressed: () {
            cnst.Constants.isBussiness.toggle();
          }),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (v) {},
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.), label: "WhatsApp"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.abc), label: "B WhatsApp")
      //   ],
      // ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.rate) {
    } else if (choice == Constants.share) {}
  }
}

class Constants {
  // static const String about = 'About App';
  static const String rate = 'Rate App';
  static const String share = 'Share with friends';

  static RxList<String> choices = <String>[
    rate,
    share,
  ].obs;
}
