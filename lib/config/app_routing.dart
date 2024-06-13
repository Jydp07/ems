import 'package:ems/constant/routing_constant.dart';
import 'package:ems/views/screens/admin_screens/admin_home_screen.dart';
import 'package:ems/views/screens/bottom_nav_bar_screen.dart';
import 'package:ems/views/screens/home_screen.dart';
import 'package:ems/views/screens/leaves_screen.dart';
import 'package:ems/views/screens/login_screen.dart';
import 'package:ems/views/screens/registration_screen.dart';
import 'package:ems/views/screens/services_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter();

  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutingConstant.loginScreen:
        return MaterialPageRoute(builder: (_) => const LogInScreen());
      case RoutingConstant.registrationScreen:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case RoutingConstant.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RoutingConstant.bottombar:
        return MaterialPageRoute(builder: (_) => const BottomNavBarScreen());
      case RoutingConstant.leaveScreen:
        return MaterialPageRoute(builder: (_) => const LeavesScreen());
      case RoutingConstant.serviceScreen:
        return MaterialPageRoute(builder: (_) => const ServicesScreen());
      case RoutingConstant.adminHome:
        return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
    }
  }
}
