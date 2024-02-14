import 'package:get/get.dart';
import 'package:temis_special_snacks/views/address/add_address_page.dart';
import 'package:temis_special_snacks/views/address/pick_address_map.dart';
import 'package:temis_special_snacks/views/auth/reset_account_page.dart';
import 'package:temis_special_snacks/views/auth/sign_in_page.dart';
import 'package:temis_special_snacks/views/auth/sign_up_page.dart';
import 'package:temis_special_snacks/views/cart/cart_page.dart';
import 'package:temis_special_snacks/views/home/home_page.dart';
import 'package:temis_special_snacks/views/order/track_order.dart';
import 'package:temis_special_snacks/views/product/popular_product_detail.dart';
import 'package:temis_special_snacks/views/product/recommended_product_detail.dart';
import 'package:temis_special_snacks/views/splash/splash_screen.dart';

class RouteHelper{
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String popularProduct="/popular-product";
  static const String recommendedProduct="/recommended-product";
  static const String cartPage = "/cart-page";
  static const String signUp = "/sign-up";
  static const String signIn = "/sign-in";
  static const String addAddress="/add-address";
  static const String pickAddressMap="/pick-address";
  static const String resetAccount= "/reset-account";
  static const String trackOrder= "/track-order";


  static String getSplashPage()=>'$splashPage';
  static String getInitial()=>'$initial';
  static String getPopularProduct(int pageId, String page)=>'$popularProduct?pageId=$pageId&page=$page';
  static String getRecommendedProduct(int pageId, String page)=>'$recommendedProduct?pageId=$pageId&page=$page';
  static String getCartPage()=>'$cartPage';
  static String getSignUpPage()=>'$signUp';
  static String getSignInPage()=>'$signIn';
  static String getAddressPage()=>'$addAddress';
  static String getPickAddressPage()=>'$pickAddressMap';
  static String getResetAccountPage()=>'$resetAccount';
  static String getTrackOrderPage()=>'$trackOrder';


  static List<GetPage>routes=[

    GetPage(name: splashPage, page: ()=>const SplashScreen()),

    GetPage(name: initial, page: (){
      return const HomePage();
  }, transition: Transition.fade),

    GetPage(name: signUp, page: (){
      return const SignUpPage();
    }, transition: Transition.fade),

    GetPage(name: signIn, page: (){
      return const SignInPage();
    }, transition: Transition.fade),

    GetPage(name: popularProduct, page: () {
      var pageId = Get.parameters['pageId'];
      var page = Get.parameters["page"];
      return PopularProductDetail(pageId:int.parse(pageId!), page:page!);
      },
    transition: Transition.fadeIn),

    GetPage(name: recommendedProduct, page: () {
      var pageId = Get.parameters['pageId'];
      var page = Get.parameters["page"];
      return RecommendedProductDetail(pageId:int.parse(pageId!), page:page!);
    },
        transition: Transition.fadeIn),

    GetPage(name: cartPage, page: (){
      return const CartPage();
    },
    transition: Transition.fadeIn),

    GetPage(name: addAddress, page: (){
      return const AddAddressPage();
    }),

    GetPage(name: pickAddressMap, page: (){
      PickAddressMap _pickAddress = Get.arguments;
      return _pickAddress;
    }),

    GetPage(name: resetAccount, page: (){
      return const ResetAccountPage();
    }, transition: Transition.fade),

    GetPage(name: trackOrder, page: (){
      return const TrackOrder();
    }, transition: Transition.fade),
  ];
}