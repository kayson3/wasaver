import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Constants {
  static int? androidVersion;
  static RxBool isBussiness = false.obs;
  String waPath = androidVersion != null && androidVersion! <= 9
      ? isBussiness.value == true
          ? '/storage/emulated/0/WhatsApp Business/Media/Statuses'
          : '/storage/emulated/0/WhatsApp/Media/.Statuses'
      : isBussiness.value == true
          ? '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses'
          : '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';

  static Future<void> getAndroidVersion() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    androidVersion = int.tryParse(androidInfo.version.release);

    if (androidVersion != null && androidVersion! <= 9) {
      Constants().waPath = isBussiness.value == true
          ? '/storage/emulated/0/WhatsApp Business/Media/Statuses'
          : '/storage/emulated/0/WhatsApp/Media/.Statuses';
    }
  }
}





// /storage/emulated/0/WhatsApp/Media/.Statuses/
// /storage/emulated/0/WhatsApp Business/Media/Statuses/
// /storage/emulated/0/WhatsApp Business/Media/Statuses/