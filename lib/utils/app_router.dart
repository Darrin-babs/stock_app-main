import 'package:get/get.dart';
import 'package:stocks/screens/home_screen.dart';

class AppRouter {
  static const String home = '/';

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: home,
        page: () => const HomeScreen(),
      ),
    ];
  }
}