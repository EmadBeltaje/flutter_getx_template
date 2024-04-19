import 'package:get/get.dart';

class DashboardController extends GetxController {
  int selectedIndex = 0;

  onDestinationSelected(int selectedIndex){
    this.selectedIndex = selectedIndex;
    update();
  }
}
