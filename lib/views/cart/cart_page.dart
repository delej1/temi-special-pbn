import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_utils/google_maps_utils.dart' as map;
import 'package:temis_special_snacks/base/common_text_button.dart';
import 'package:temis_special_snacks/base/custom_app_bar.dart';
import 'package:temis_special_snacks/base/no_data_page.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/controllers/auth_controller.dart';
import 'package:temis_special_snacks/controllers/cart_controller.dart';
import 'package:temis_special_snacks/controllers/location_controller.dart';
import 'package:temis_special_snacks/controllers/order_controller.dart';
import 'package:temis_special_snacks/controllers/popular_product_controller.dart';
import 'package:temis_special_snacks/controllers/recommended_product_controller.dart';
import 'package:temis_special_snacks/controllers/user_controller.dart';
import 'package:temis_special_snacks/payment/functions/paystack_function.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/utils/styles.dart';
import 'package:temis_special_snacks/views/order/delivery_options.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';
import 'package:temis_special_snacks/views/order/payment_option_button.dart';



class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if(_userLoggedIn){
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }

    bool _contains = false;
    List<Point> polygon =[
      const Point(9.104823, 7.492553),
      const Point(9.089623, 7.413802),
      const Point(9.052197, 7.432933),
      const Point(9.018008, 7.494148),
      const Point(9.052079, 7.522440),
    ];

    return Scaffold(
      appBar:  const CustomAppBar(title: "Cart"),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(_userLoggedIn){
              Get.find<CartController>().addToHistory();
            }else{
              showCustomSnackBar(title: "Sign In","Please sign in to add to history");
            }
          },
          backgroundColor:  AppColors.mainColor,
          tooltip: 'Add to Cart History',
          elevation: 5,
          splashColor: Colors.grey,
          child: const Icon(Icons.shopping_cart_rounded,
          color: Colors.white, size: 30,),
        ),
      body: Stack(
        children: [
          GetBuilder<CartController>(builder: (_cartController){
            return _cartController.getItems.isNotEmpty?Positioned(
                top: 0,
                left: Dimensions.width20,
                right: Dimensions.width20,
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.height15),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GetBuilder<CartController>(builder: (cartController){
                      var _cartList = cartController.getItems;
                      return ListView.builder(
                          itemCount: _cartList.length,
                          itemBuilder: (_, index) {
                            return SizedBox(
                              height: Dimensions.height20 * 5,
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      var popularIndex = Get.find<PopularProductController>()
                                          .popularProductList
                                          .indexOf(_cartList[index].product!);
                                      if(popularIndex>=0){
                                        Get.toNamed(RouteHelper.getPopularProduct(popularIndex, "cartpage"));
                                      }else{
                                        var recommendedIndex = Get.find<RecommendedProductController>()
                                            .recommendedProductList
                                            .indexOf(_cartList[index].product!);
                                        if(recommendedIndex<0){
                                          showCustomSnackBar(title: "Snack Detail", "Snack detail is not available for selected item",);
                                        }else{
                                          Get.toNamed(RouteHelper.getRecommendedProduct(recommendedIndex, "cartpage"));
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: Dimensions.width20 * 5,
                                      height: Dimensions.height20 * 5,
                                      margin: EdgeInsets.only(bottom: Dimensions.height10,),
                                      color: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radius15/2),
                                        child: CachedNetworkImage(
                                          imageUrl: AppConstants.baseUrl+AppConstants.uploadUrl+cartController.getItems[index].img!,
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width10,),
                                  Expanded(child: SizedBox(
                                    height: Dimensions.height20*5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        BigText(text: cartController.getItems[index].name!,
                                          color: Colors.black54,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            BigText(text: "₦${cartController.getItems[index].price!}", color: Colors.redAccent,),
                                            Container(
                                              padding: EdgeInsets.only(
                                                top: Dimensions.height10,
                                                bottom: Dimensions.height10,
                                                left: Dimensions.width10,
                                                right: Dimensions.width10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartController.addItem(_cartList[index].product!, -1);
                                                    },
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: AppColors.signColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Dimensions.width5,
                                                  ),
                                                  BigText(
                                                      text: _cartList[index].quantity.toString()),
                                                  SizedBox(
                                                    width: Dimensions.width5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartController.addItem(_cartList[index].product!, 1);
                                                    },
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: AppColors.signColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            );
                          });
                    }),
                  ),
                )):const Center(
                  child: NoDataPage(text: "Your cart is empty"),
                );
          })
        ],
      ),
        bottomNavigationBar:
          GetBuilder<CartController>(builder: (cartController) {
            return Container(
                height: Dimensions.bottomHeightBar+60,
                padding: EdgeInsets.only(
                  top: Dimensions.height10,
                  bottom: Dimensions.height10,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                ),
                decoration: BoxDecoration(
                    color: AppColors.buttonBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20 * 2),
                      topRight: Radius.circular(Dimensions.radius20 * 2),
                    )),
                child: cartController.getItems.isNotEmpty?Column(
                  children: [
                    InkWell(
                      onTap: ()=>showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context){
                            return Container(
                              height: MediaQuery.of(context).size.height/2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radius20),
                                    topRight: Radius.circular(Dimensions.radius20),
                                  )
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height/2,
                                    padding: EdgeInsets.only(
                                      left: Dimensions.width20,
                                      right: Dimensions.width20,
                                      top: Dimensions.height20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const PaymentOptionButton(
                                          icon: Icons.payment,
                                          title: "Digital Payment",
                                          subTitle: "Safer and faster way of payment",
                                          index: 0,
                                        ),
                                        SizedBox(height: Dimensions.height20*2,),
                                        Text("Delivery Options", style: fontMedium.copyWith(fontSize: Dimensions.font20),),
                                        SizedBox(height: Dimensions.height10/2,),
                                        DeliveryOptions(value: "Delivery",
                                            title: "Handling & Delivery",
                                            amount: cartController.totalAmount,
                                            isFree: false),
                                        SizedBox(height: Dimensions.height10/2,),
                                        const DeliveryOptions(value: "Pick up",
                                            title: "Pick up",
                                            amount: 0,
                                            isFree: true),
                                        SizedBox(height: Dimensions.height30,),
                                        const Text(AppConstants.deliveryNote,),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                      child: const SizedBox(
                        width: double.maxFinite,
                        child: CommonTextButton(text: "Delivery Options"),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: Dimensions.height20,
                            bottom: Dimensions.height20,
                            left: Dimensions.width20,
                            right: Dimensions.width20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: Dimensions.width5,
                              ),
                              BigText(
                                  text: "₦${cartController.totalAmount}"),
                              SizedBox(
                                width: Dimensions.width5,
                              ),
                            ],
                          ),
                        ),
                            SizedBox(width: Dimensions.width10,),
                            GestureDetector(
                              onTap: () {
                                if(_userLoggedIn){
                                  if(Get.find<LocationController>().addressList.isEmpty||
                                      Get.find<LocationController>().getUserAddress().latitude.isEmpty){
                                    cartController.addToHistory();
                                    Get.toNamed(RouteHelper.getAddressPage());
                                  }else{
                                    //edit here for address check
                                    Point point = Point(
                                        double.parse(Get.find<LocationController>().getUserAddress().latitude),
                                        double.parse(Get.find<LocationController>().getUserAddress().longitude));
                                    _contains = map.PolyUtils.containsLocationPoly(point, polygon);
                                    if(_contains){
                                      //edit here for payment button
                                      if(cartController.totalAmount<1000){
                                        showCustomSnackBar(title: "Order Amount", "Your order can't be less than ₦1000");
                                      }else{
                                        if(Get.find<OrderController>().orderType=="Delivery"&&cartController.totalAmount<5000){
                                          showCustomSnackBar(title: "Order Amount", "Your order can't be less than ₦5000 for delivery");
                                        }else if(Get.find<OrderController>().orderType=="Pick up"){
                                          MakePayment(ctx: context, orderAmount: cartController.totalAmount).chargeCard();
                                        }else{
                                          MakePayment(ctx: context, orderAmount: cartController.totalAmount+(cartController.totalAmount/10).round()).chargeCard();
                                        }
                                      }
                                    }else{
                                      showCustomSnackBar(title: "Out of Service Area", "Sorry, your address is out of the service area");
                                    }
                                  }
                                }else{
                                  cartController.addToHistory();
                                  Get.toNamed(RouteHelper.getSignInPage());
                                }
                              },
                              child: const CommonTextButton(text: "Check Out",)
                            ),
                      ],
                    ),
                  ],
                ):Container()
            );
          })
    );
  }
}
