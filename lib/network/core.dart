import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';

class Network {
  static const String railwayAuthority = "blueart-laravel-production.up.railway.app";
  static const String railwayBaseUrl = "https://$railwayAuthority";

  static Future<String> localAuthority() async {
    final ip = await LocalSharedPreferences.getString(SharedPrefValues.localIP);
    final port = await LocalSharedPreferences.getString(SharedPrefValues.localPort);
    return "$ip:$port";
  }

  static Future<String> localBaseUrl() async {
    return "http://${await localAuthority()}";
  }

  static Future<String> getAuthority() async {
    final connection = await LocalSharedPreferences.getString(SharedPrefValues.connection);
    if (connection == 'local') {
      return await localAuthority();
    }
    return railwayAuthority;
  }

  static Future<String> getBaseUrl() async {
    final connection = await LocalSharedPreferences.getString(SharedPrefValues.connection);
    if (connection == 'local') {
      return await localBaseUrl();
    }
    return railwayBaseUrl;
  }

  static Future<String?> localIp() async => await LocalSharedPreferences.getString(SharedPrefValues.localIP);
  static Future<String?> protocol() async => await LocalSharedPreferences.getString(SharedPrefValues.localIP);

  static Future<String> loginUrl() async => "${await getBaseUrl()}/api/login";
  static Future<String> registerUrl() async => "${await getBaseUrl()}/api/register";
  static Future<String> logoutUrl() async => "${await getBaseUrl()}/api/logout";
  static Future<String> productsUrl() async => "${await getBaseUrl()}/api/products";
  static Future<String> userDetailsUrl() async => "${await getBaseUrl()}/api/user";
  static Future<String> updateProfileUrl() async => "${await getBaseUrl()}/api/updateUser";
  static Future<String> resetPasswordUrl() async => "${await getBaseUrl()}/api/resetPassword";

  static const String artProducts = "/api/products/category/art";
  static const String collectiblesProducts = "/api/products/category/collectibles";
}
