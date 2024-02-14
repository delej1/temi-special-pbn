import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/controllers/cart_controller.dart';
import 'package:temis_special_snacks/controllers/popular_product_controller.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/widgets/app_column.dart';
import 'package:temis_special_snacks/widgets/app_icon.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';
import 'package:temis_special_snacks/widgets/expandable_text_widget.dart';

class PopularProductDetail extends StatelessWidget {
  final int pageId;
  final String page;

  const PopularProductDetail({Key? key, required this.pageId, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Get.find<PopularProductController>().popularProductList[pageId];
    Get.find<PopularProductController>()
        .initProduct(product, Get.find<CartController>());

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            //background image
            Positioned(
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.maxFinite,
                height: Dimensions.popularProductImgSize,
                child: CachedNetworkImage(
                  imageUrl: AppConstants.baseUrl+AppConstants.uploadUrl+product.img!,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.none,
                ),
              ),
            ),
            //icon widgets
            Positioned(
              top: Dimensions.height45,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        if(page=="cartpage"){
                          Get.toNamed(RouteHelper.getCartPage());
                        }else{
                          Get.toNamed(RouteHelper.getInitial());
                        }
                      },
                      child: const AppIcon(icon: Icons.arrow_back_ios)),
                  GetBuilder<PopularProductController>(builder: (controller) {
                    return GestureDetector(
                      onTap: (){
                        if(controller.totalItems >= 1){
                          Get.toNamed(RouteHelper.getCartPage());
                        }
                      },
                      child: Stack(
                        children: [
                          const AppIcon(icon: Icons.shopping_cart_outlined),
                          controller.totalItems >= 1
                              ? const Positioned(
                                  right: 0,
                                  top: 0,
                                    child: AppIcon(
                                      icon: Icons.circle,
                                      size: 20,
                                      iconColor: Colors.transparent,
                                      backgroundColor: AppColors.mainColor,
                                    ),
                                )
                              : Container(),
                          Get.find<PopularProductController>().totalItems >= 1
                              ? Positioned(
                                  right: 3,
                                  top: 3,
                                  child: BigText(
                                    text: Get.find<PopularProductController>()
                                        .totalItems
                                        .toString(),
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
            //snack details
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Dimensions.popularProductImgSize - 20,
              child: Container(
                  padding: EdgeInsets.only(
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      top: Dimensions.height20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radius20),
                      topLeft: Radius.circular(Dimensions.radius20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppColumn(
                        nameText: product.name!,
                        starText: product.stars!,
                        starInt: int.parse(product.stars!),
                        price: "",
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      BigText(text: "Details"),
                      //expandable text widget
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                  Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ExpandableTextWidget(
                              text: product.description!),
                                  //"10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream 10 pieces of scrumptious doughnuts glazed with sugar coat and topped with whipped cream"),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
        bottomNavigationBar:
            GetBuilder<PopularProductController>(builder: (popularProduct) {
          return Container(
            height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.only(
              top: Dimensions.height30,
              bottom: Dimensions.height30,
              left: Dimensions.width20,
              right: Dimensions.width20,
            ),
            decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20 * 2),
                  topRight: Radius.circular(Dimensions.radius20 * 2),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          popularProduct.setQuantity(false);
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
                          text: popularProduct.inCartItems.toString()),
                      SizedBox(
                        width: Dimensions.width5,
                      ),
                      GestureDetector(
                        onTap: () {
                          popularProduct.setQuantity(true);
                        },
                        child: const Icon(
                          Icons.add,
                          color: AppColors.signColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    popularProduct.addItem(product);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: Dimensions.height20,
                      bottom: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: AppColors.mainColor,
                    ),
                    child: BigText(
                      text: "₦${product.price!} | Add to cart",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
