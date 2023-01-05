import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../components/my_widgets_animator.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(
        builder: (_){
          return MyWidgetsAnimator(
            apiCallStatus: controller.apiCallStatus,
            loadingWidget: () => const Center(child: CircularProgressIndicator(),),
            errorWidget: ()=> const Center(child: Text('Something went Wrong!'),),
            successWidget: () =>
                ListView.separated(
                  itemCount: controller.data?.length ?? 0,
                  separatorBuilder: (_,__) => SizedBox(height: 10.h,),
                  itemBuilder: (ctx,index) => ListTile(
                    title: Text(controller.data![index]['userId'].toString()),
                    subtitle: Text(controller.data![index]['title']),
                  ),
                ),
          );
        },
      ),
    );
  }
}
