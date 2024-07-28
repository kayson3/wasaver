import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wastatussaver/constants.dart';
import 'package:wastatussaver/ui/savedMedia.dart';

import 'imageScreen.dart';
import 'videoScreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        Constants.isBussiness.value;
        return const TabBarView(
          children: [
            ImageScreen(),
            VideoScreen(),
            Savedmedia(),
          ],
        );
      },
    );
  }
}
