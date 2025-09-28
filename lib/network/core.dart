class Network {
  // static const String baseUrl = "http://192.168.0.10:8000";
  static const String authority = "blueart-laravel-production.up.railway.app";
  static const String baseUrl = "https://$authority";

  static const String login = "$baseUrl/api/login";
  static const String register = "$baseUrl/api/register";
  static const String logout = "$baseUrl/api/logout";
  static const String getProducts = "$baseUrl/api/products";
  static const String getArtProducts = "/api/products/category/art";
  static const String getColectablesProducts = "/api/products/category/collectibles";
  static const String getUserDetails = "$baseUrl/api/user";
  static const String updateProfile = "$baseUrl/api/updateUser";
  static const String resetPassword = "$baseUrl/api/resetPassword";
}