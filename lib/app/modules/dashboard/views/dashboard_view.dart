import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../config/translations/strings_enum.dart';
import '../controllers/dashboard_controller.dart';
import 'downloads/downloads_view.dart';
import 'favourite/favourite_view.dart';
import 'settings/settings_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(Strings.dashboard.tr),
          ),
          body: IndexedStack(
            index: controller.selectedIndex,
            children: [
              FavouriteView(),
              DownloadsView(),
              SettingsView(),
            ],
          ),
          bottomNavigationBar: NavigationBar(// The navigation bar itself
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.favorite),
                label: Strings.favourite.tr,
              ),
              NavigationDestination(
                icon: Icon(Icons.download_for_offline),
                label: Strings.downloads.tr,
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: Strings.settings.tr,
              ),
            ],
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: (int index) {
              controller.onDestinationSelected(index); // Update selected index in controller
            },
          ),
        );
      }
    );
  }
}
