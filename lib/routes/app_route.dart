import 'package:blue_art_mad2/layout/layout.dart';
import 'package:blue_art_mad2/pages/cartPage.dart';
import 'package:blue_art_mad2/pages/checkOutPage.dart';
import 'package:blue_art_mad2/pages/favoritesPage.dart';
import 'package:blue_art_mad2/pages/homePage.dart';
import 'package:blue_art_mad2/pages/loginPage.dart';
import 'package:blue_art_mad2/pages/registerPage.dart';
import 'package:blue_art_mad2/pages/viewCategoriesPage.dart';
import 'package:blue_art_mad2/pages/viewProductDetails.dart';

class AppRoute {
  static const login = '/';
  static const register = '/register';
  static const layout = '/layout';
  static const home = '/home';
  static const profile = '/profile';
  static const checkOutPage = '/checkOutPage';
  static const cartPage = '/cartPage';
  static const favoritesPage = '/favoritesPage';
  static const viewCategoriesPage = '/viewCategoriesPage';
  static const viewProductDetailsPage = '/ViewProductDetailsPage';

  static final routes ={
    // No Layout
    login: (context) => LoginPage(),
    register: (context) => RegisterPage(),

    // Layout
    layout: (context) => Layout(),

    checkOutPage: (context) => CheckOutPage(),
    home: (context) => HomePage(),
    cartPage: (context) => CartPage(),
    favoritesPage: (context) => FavoritesPage(),
    viewCategoriesPage: (context) => Viewcategoriespage(),
    viewProductDetailsPage: (context) => ViewProductDetailsPage(),
  };
}