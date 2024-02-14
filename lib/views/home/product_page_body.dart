import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/base/custom_loader.dart';
import 'package:temis_special_snacks/controllers/popular_product_controller.dart';
import 'package:temis_special_snacks/controllers/recommended_product_controller.dart';
import 'package:temis_special_snacks/models/products_model.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/widgets/app_column.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';
import 'package:temis_special_snacks/widgets/small_text.dart';

class ProductsPageBody extends StatefulWidget {
  const ProductsPageBody({Key? key}) : super(key: key);

  @override
  State<ProductsPageBody> createState() => _ProductsPageBodyState();
}

class _ProductsPageBodyState extends State<ProductsPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //slider section
        GetBuilder<PopularProductController>(builder: (popularProduct) {
          return popularProduct.isLoaded?SizedBox(
              height: Dimensions.pageView,
                child: PageView.builder(
                    controller: pageController,
                    itemCount: popularProduct.popularProductList.length,
                    itemBuilder: (context, position) {
                      return _buildPageItem(position, popularProduct.popularProductList[position]);
                    }),
              ):const CustomLoader();
        }),

        //dots
        GetBuilder<PopularProductController>(builder: (popularProduct){
          return DotsIndicator(
            dotsCount: popularProduct.popularProductList.isEmpty?1:popularProduct.popularProductList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        //popular text
        SizedBox(
          height: Dimensions.height30,
        ),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Recommended"),
              SizedBox(
                width: Dimensions.width10,
              ),
              SmallText(
                text: "Snacks",
              )
            ],
          ),
        ),
        //list of recommended snacks and images
        GetBuilder<RecommendedProductController>(builder: (recommendedProduct){
          return recommendedProduct.isLoaded?ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              cacheExtent: double.maxFinite,
              itemCount: recommendedProduct.recommendedProductList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Get.toNamed(RouteHelper.getRecommendedProduct(index, "home"));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: Dimensions.height10),
                    child: Row(
                      children: [
                        //image section
                        SizedBox(
                          height: Dimensions.listViewImgSize,
                          width: Dimensions.listViewImgSize,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radius30),
                            child: CachedNetworkImage(
                              imageUrl: AppConstants.baseUrl+AppConstants.uploadUrl+recommendedProduct.recommendedProductList[index].img!,
                              placeholder: (context, url) => const CustomLoader(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              fit: BoxFit.none,
                            ),
                          ),),
                        //text container
                        Expanded(
                          child: Container(
                            height: Dimensions.listViewTextContSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Dimensions.radius20),
                                bottomRight: Radius.circular(Dimensions.radius20),
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: Dimensions.width10,
                                  right: Dimensions.width10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BigText(text: recommendedProduct.recommendedProductList[index].name!),
                                  SizedBox(
                                    height: Dimensions.height10,
                                  ),
                                  SmallText(
                                    text: recommendedProduct.recommendedProductList[index].description!,
                                    maxLines: 2,
                                    overFLow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: Dimensions.height10,
                                  ),
                                  Align(alignment: Alignment.bottomRight,
                                      child: Text("₦${recommendedProduct.recommendedProductList[index].price!}",
                                        style: const TextStyle(color: Colors.green),)
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }):const CustomLoader();
        })
      ],
    );
  }

  Widget _buildPageItem(int index, ProductModel popularProduct) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return GestureDetector(
      onTap: (){
        Get.toNamed(RouteHelper.getPopularProduct(index, "home"));
      },
      child: Transform(
        transform: matrix,
        child: Stack(
          children: [
            Container(
              height: Dimensions.pageViewContainer,
              width: Dimensions.width500,
              margin: EdgeInsets.only(
                  left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: index.isEven
                  ? const Color(0xFF69c5df)
                    : const Color(0xFF9294cc),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                child: CachedNetworkImage(
                  imageUrl: AppConstants.baseUrl+AppConstants.uploadUrl+popularProduct.img!,
                  placeholder: (context, url) => const CustomLoader(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.none,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.pageViewTextContainer,
                margin: EdgeInsets.only(
                    left: Dimensions.width30,
                    right: Dimensions.width30,
                    bottom: Dimensions.height30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFe8e8e8),
                        blurRadius: 5.0,
                        offset: Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, 0),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(5, 0),
                      ),
                    ]),
                child: Container(
                  padding: EdgeInsets.only(
                      top: Dimensions.height15,
                      left: Dimensions.width15,
                      right: Dimensions.width15),
                  child: AppColumn(
                    nameText: popularProduct.name!,
                    descText: popularProduct.description!,
                    starText: popularProduct.stars!,
                    starInt: int.parse(popularProduct.stars!),
                    price: "₦${popularProduct.price!}",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
