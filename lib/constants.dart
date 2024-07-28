import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Constants {
  static RxBool isBussiness = false.obs;
  String waPath = isBussiness.value == true
      ? '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses'
      : '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
}
