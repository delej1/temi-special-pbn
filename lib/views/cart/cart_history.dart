import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temis_special_snacks/base/custom_app_bar.dart';
import 'package:temis_special_snacks/base/no_data_page.dart';
import 'package:temis_special_snacks/controllers/cart_controller.dart';
import 'package:temis_special_snacks/models/cart_model.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/widgets/small_text.dart';



class CartHistory extends StatefulWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  State<CartHistory> createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    var getCartHistoryList = Get.find<CartController>().getCartHistoryList().reversed.toList();

    Map<String, int> cartItemsPerOrder = {};

    for (int i = 0; i < getCartHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        cartItemsPerOrder.update(
            getCartHistoryList[i].time!, (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    List<int> cartItemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<String> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) => e.key).toList();
    }

    List<int> itemsPerOrder = cartItemsPerOrderToList();

    var listCounter = 0;

    Widget timeWidget(int index) {
      var outputDate = DateTime.now().toString();
      if (index < getCartHistoryList.length) {
        DateTime parseData = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(getCartHistoryList[listCounter].time!);
        var inputDate = DateTime.parse(parseData.toString());
        var outputFormat = DateFormat("dd/MM/yyy hh:mm a");
        outputDate = outputFormat.format(inputDate);
        return SmallText(text: outputDate);
      }
      return SmallText(
        text: outputDate,
      );
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<CartController>().clearCartHistory();
          Get.find<CartController>().removeCartSharedPreference();
        },
        backgroundColor: AppColors.mainColor,
        tooltip: 'Delete Cart History',
        elevation: 5,
        splashColor: Colors.grey,
        child: const Icon(Icons.delete_forever,
          color: Colors.white, size: 30,),
      ),
      appBar: const CustomAppBar(title: "Cart History"),
      body: Column(
        children: [
          GetBuilder<CartController>(builder: (_cartController) {
            return _cartController.getCartHistoryList().isNotEmpty
                ? Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                          top: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView(
                            children: [
                              for (int i = 0; i < itemsPerOrder.length; i++)
                                Container(
                                  height: Dimensions.height30 * 4,
                                  margin: EdgeInsets.only(bottom: Dimensions.height20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      timeWidget(listCounter),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Wrap(
                                              direction: Axis.horizontal,
                                              children: List.generate(itemsPerOrder[i], (index) {
                                                if (listCounter < getCartHistoryList.length) {
                                                  listCounter++;
                                                }
                                                return index <=2?Container(
                                                  height: Dimensions.height20 * 4,
                                                  width: Dimensions.width20 * 4,
                                                  margin: EdgeInsets.only(right: Dimensions.width10 / 2),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(Dimensions.radius15/2),
                                                    child: CachedNetworkImage(
                                                      imageUrl: AppConstants.baseUrl + AppConstants.uploadUrl + getCartHistoryList[listCounter - 1].img!,
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),): Container();
                                              }),
                                            ),
                                            SizedBox(
                                              height: Dimensions.height20 * 4,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  SmallText(text: "Total", color: AppColors.titleColor,),
                                                  SmallText(text: "${itemsPerOrder[i]} Item(s)", color: AppColors.titleColor,),
                                                  GestureDetector(
                                                    onTap: () {
                                                      var orderTime =
                                                          cartOrderTimeToList();
                                                      Map<int, CartModel>
                                                          moreOrder = {};
                                                      for (int j = 0; j<getCartHistoryList.length; j++) {
                                                        if (getCartHistoryList[j].time == orderTime[i]) {
                                                          moreOrder.putIfAbsent(getCartHistoryList[j].id!, () => CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j]))));
                                                        }
                                                      }
                                                      Get.find<CartController>().setItems = moreOrder;
                                                      Get.find<CartController>().addToCartList();
                                                      Get.toNamed(RouteHelper.getCartPage());
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,
                                                        vertical: Dimensions.height10 /2,),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radius15 / 3,),
                                                          border: Border.all(width: 1, color: AppColors.mainColor,)),
                                                      child: SmallText(text: "Update Order", color: AppColors.mainColor,),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        )),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: const NoDataPage(
                      text: "No item(s) in your cart history",
                      imgPath: "assets/image/empty_box.png",
                    ));
          })
        ],
      ),
    );
  }
}
