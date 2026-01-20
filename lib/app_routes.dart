import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

import 'screens/reports_menu_screen.dart';
import 'screens/reports_list_screen.dart';
import 'screens/reports_create_screen.dart';

import 'screens/routes_list_screen.dart';

class AppRoutes {
  // Auth
  static const login = '/login';
  static const register = '/register';

  // Home
  static const home = '/home';

  // Reports
  static const reportsMenu = '/reports/menu';
  static const reportsList = '/reports/list';
  static const reportsCreate = '/reports/create';

  // Routes
  static const routesList = '/routes/list';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        home: (_) => const HomeScreen(),

        reportsMenu: (_) => const ReportsMenuScreen(),
        reportsList: (_) => const ReportsListScreen(),
        reportsCreate: (_) => const ReportsCreateScreen(),

        routesList: (_) => const RoutesListScreen(),
      };
}
