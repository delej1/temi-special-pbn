class AppConstants{
  static const String appName ="Temi Special Snacks";
  static const int appVersion= 1;

  static const String baseUrl = "https://shop.temispecialsnacks.store";
  static const String popularProductsUri= "/api/v1/products/popular";
  static const String recommendedProductsUri= "/api/v1/products/recommended";
  static const String uploadUrl = "/uploads/";

  static const String token="";
  static const String cartList="cart-list";
  static const String cartHistoryList="cart-history-list";

  static const String registrationUri="/api/v1/auth/register";
  static const String loginUri="/api/v1/auth/login";
  static const String userInfoUri="/api/v1/customer/info";

  static const String phone="";
  static const String password="";

  static const String userAddress="user_address";
  static const String addUserAddress="/api/v1/customer/address/add";
  static const String addressListUri="/api/v1/customer/address/list";

  static const String geocodeUri='/api/v1/config/geocode-api';

  static const String searchLocationUri='/api/v1/config/place-api-autocomplete';
  static const String placeDetailsUri= '/api/v1/config/place-api-details';

  static const String deliveryNote= "Note:  Orders below ₦5000 can be delivered on request at the receiver's expense.";

  static const String firebaseApiKey = "AIzaSyDsOpXjEafB410oDJz6oF75imow4_9LaPg";
  static const String firebaseAuthDomain = "temis-special-snacks-bd974.firebaseapp.com";
  static const String firebaseProjectId = "temis-special-snacks-bd974";
  static const String firebaseStorageBucket = "temis-special-snacks-bd974.appspot.com";
  static const String firebaseMessagingSenderId = "793053875001";
  static const String firebaseAppId = "1:793053875001:web:9d3bf24c0957b08bf1f6e8";

  static const String twilioSID = "AC518635cd4150ac7bfa697c8a00a651b4";
  static const String twilioAuthToken = "955e695a91747ae0af9df72d6f184976";
  static const String twilioNumber = "+15625738666";
}