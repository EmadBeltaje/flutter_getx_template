import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../config/translations/strings_enum.dart';

// mock model
class DataGridModelMock {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color backgroundColor;
  final Color iconBackgroundColor;

  DataGridModelMock({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.backgroundColor,
    required this.iconBackgroundColor,
  });
}

class DataGrid extends StatelessWidget {
  DataGrid({super.key});

  final List<DataGridModelMock> data = [
    DataGridModelMock(
      title: Strings.vocation.tr,
      subtitle: '10 - 20 ${Strings.vocation.tr}',
      iconPath: 'assets/vectors/vocation.svg',
      backgroundColor: const Color(0xFFEFF5FB),
      iconBackgroundColor: const Color(0xFF83A0EC),
    ),
    DataGridModelMock(
      title: Strings.remainingTasks.tr,
      subtitle: '5 - 10 ${Strings.tasks.tr}',
      iconPath: 'assets/vectors/tasks.svg',
      backgroundColor: const Color(0xFFEEF9FF),
      iconBackgroundColor: const Color(0xFF92D5F6),
    ),
    DataGridModelMock(
      title: Strings.daysOfDelays.tr,
      subtitle: '10 - 20 ${Strings.days.tr}',
      iconPath: 'assets/vectors/alarm.svg',
      backgroundColor: const Color(0xFFF4F0FC),
      iconBackgroundColor: const Color(0xFFAB99D9),
    ),
    DataGridModelMock(
      title: Strings.absentDays.tr,
      subtitle: '10 - 20 ${Strings.days.tr}',
      iconPath: 'assets/vectors/absent.svg',
      backgroundColor: const Color(0xFFFEF0EF),
      iconBackgroundColor: const Color(0xFFF9928A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11.w,
        mainAxisSpacing: 10.h,
        mainAxisExtent: 120.h,
      ),
      itemBuilder: (ctx, index) {
        var gridData = data[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: gridData.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 37.h,
                width: 37.h,
                decoration: BoxDecoration(
                  color: gridData.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  gridData.iconPath,
                  height: 19.h,
                  fit: BoxFit.none,
                ),
              ),
              8.verticalSpace,
              Text(gridData.title,style: theme.textTheme.bodySmall,),
              7.verticalSpace,
              Text(gridData.subtitle,style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF4B4C4D),)),
            ],
          ),
        );
      },
    );
  }
}
