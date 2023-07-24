import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../config/translations/strings_enum.dart';
import '../../../components/api_error_widget.dart';
import '../../../components/my_widgets_animator.dart';
import '../controllers/home_controller.dart';
import 'widgets/data_grid.dart';
import 'widgets/employees_list.dart';
import 'widgets/header.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ----------------------- Header ----------------------- //
          const Header(),

          // ----------------------- Content ----------------------- //
          GetBuilder<HomeController>(
            builder: (_) {
              return Expanded(
                child: MyWidgetsAnimator(
                  apiCallStatus: controller.apiCallStatus,
                  loadingWidget: () => const Center(child: CupertinoActivityIndicator(),),
                  errorWidget: () => ApiErrorWidget(
                      message: Strings.internetError.tr,
                      retryAction: () => controller.getData(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                  successWidget: () => SingleChildScrollView(
                    child: Column(
                      children: [
                        20.verticalSpace,
                        // ----------------------- Attendance List Tile ----------------------- //
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: ListTile(
                            title: Text(Strings.attendanceRegistration.tr),
                            subtitle: Text(Strings.time.tr),
                            trailing: const Icon(Icons.arrow_forward),
                            leading: Container(
                              height: 47.h,
                              width: 47.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                'assets/vectors/profile.svg',
                                fit: BoxFit.none,
                                color: Colors.white,
                                height: 19.h,
                                width: 19.h,
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,

                        // ----------------------- Employee details cards ----------------------- //
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: DataGrid(),
                        ),
                        20.verticalSpace,

                        // ----------------------- Employees List ----------------------- //
                        EmployeesList(),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
