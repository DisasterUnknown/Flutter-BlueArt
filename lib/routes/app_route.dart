import 'package:blue_art_mad2/layout/layout.dart';
import 'package:blue_art_mad2/pages/loginPage.dart';
import 'package:blue_art_mad2/pages/registerPage.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const login = '/';
  static const register = '/register';
  static const layout = '/layout';
  static const checkOutPage = '/checkOutPage';
  static const viewProductDetailsPage = '/ViewProductDetailsPage';

  static final routes = {
    // Pages outside Layout
    login: (context) => LoginPage(),
    register: (context) => RegisterPage(),

    // Single Layout route (all tabs handled inside)
    layout: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      int tabIndex = 0;
      if (args != null && args is int) tabIndex = args;
      return Layout(initialTabIndex: tabIndex);
    },
  };
}
