import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/controllers/popular_product_controller.dart';
import 'package:temis_special_snacks/controllers/recommended_product_controller.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/views/home/product_page_body.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';
import 'package:temis_special_snacks/widgets/small_text.dart';


class TemiMainPage extends StatefulWidget {
  const TemiMainPage({Key? key}) : super(key: key);

  @override
  State<TemiMainPage> createState() => _TemiMainPageState();
}

class _TemiMainPageState extends State<TemiMainPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadResource() async {
    Get.find<PopularProductController>().getPopularProductList();
    Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        onRefresh: _loadResource,
        child: Column(children: [
        //showing the header
        Container(
          margin: EdgeInsets.only(
              top: Dimensions.height45, bottom: Dimensions.height30),
          padding: EdgeInsets.only(
              left: Dimensions.width20, right: Dimensions.width20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  BigText(
                    text: "Nigeria",
                    color: AppColors.mainColor,
                  ),
                  Row(
                    children: [
                      SmallText(
                        text: "Abuja",
                        color: Colors.black54,
                      ),
                      const Icon(Icons.arrow_drop_down_rounded),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        //showing the body
        const Expanded(child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ProductsPageBody(),
        )),
      ],
    ));
  }
}
