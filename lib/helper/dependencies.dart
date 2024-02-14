import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temis_special_snacks/controllers/auth_controller.dart';
import 'package:temis_special_snacks/controllers/cart_controller.dart';
import 'package:temis_special_snacks/controllers/location_controller.dart';
import 'package:temis_special_snacks/controllers/order_controller.dart';
import 'package:temis_special_snacks/controllers/popular_product_controller.dart';
import 'package:temis_special_snacks/controllers/recommended_product_controller.dart';
import 'package:temis_special_snacks/controllers/user_controller.dart';
import 'package:temis_special_snacks/data/api/api_client.dart';
import 'package:temis_special_snacks/data/repository/auth_repo.dart';
import 'package:temis_special_snacks/data/repository/cart_repo.dart';
import 'package:temis_special_snacks/data/repository/location_repo.dart';
import 'package:temis_special_snacks/data/repository/popular_product_repo.dart';
import 'package:temis_special_snacks/data/repository/recommended_product_repo.dart';
import 'package:temis_special_snacks/data/repository/user_repo.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';


Future<void> init() async{
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  //api client
  Get.lazyPut(()=> ApiClient(appBaseUrl:AppConstants.baseUrl, sharedPreferences:Get.find()));

  //repos
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => PopularProductRepo(apiClient:Get.find()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient:Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences:Get.find()));
  Get.lazyPut(() => UserRepo(apiClient:Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  //controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => PopularProductController(popularProductRepo:Get.find()));
  Get.lazyPut(() => RecommendedProductController(recommendedProductRepo:Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => OrderController());
}