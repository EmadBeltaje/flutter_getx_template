import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../views/downloads/downloads_controller.dart';
import '../views/favourite/favourite_controller.dart';
import '../views/settings/settings_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
    Get.put<FavouriteController>(FavouriteController());
    Get.put<DownloadsController>(DownloadsController());
    Get.put<SettingsController>(SettingsController());
  }
}
