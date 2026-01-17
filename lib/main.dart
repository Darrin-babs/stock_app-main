import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocks/controllers/data_controller.dart';
import 'package:stocks/utils/app_router.dart';
import 'package:stocks/utils/app_colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DataController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.darkBackground,
        fontFamily: "Poppins",
      ),
      initialRoute: AppRouter.home,
      getPages: AppRouter.getPages(),
    );
  }
}
