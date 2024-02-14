import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/base/custom_app_bar.dart';
import 'package:temis_special_snacks/base/custom_loader.dart';
import 'package:temis_special_snacks/controllers/auth_controller.dart';
import 'package:temis_special_snacks/controllers/user_controller.dart';
import 'package:temis_special_snacks/payment/models/place_order_model.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/utils/styles.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}


class _OrderPageState extends State<OrderPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  final bool _isLoggedIn = Get.find<AuthController>().userLoggedIn();
  late String docId;


  Stream<List<PlaceOrderBody>> readOrders() =>
      FirebaseFirestore.instance
          .collection('orders')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs
              .map((doc) => PlaceOrderBody.fromJson(doc.data()))
              .toList());

  @override
  void initState() {
    super.initState();
    docId = "";
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(_isLoggedIn){
      Get.find<UserController>().getUserInfo();
    }
    return Scaffold(
        appBar: const CustomAppBar(title: "Order History"),
        body: GetBuilder<UserController>(builder: (userController) {
          return _isLoggedIn ?
          (userController.isLoading ? StreamBuilder<List<PlaceOrderBody>>(
            stream: readOrders(),
            builder: (context, snapshot){
              if (snapshot.hasError){
                debugPrint(snapshot.error.toString());
                return const Center(child: Text("Error"));
              } else if (snapshot.hasData) {
                final orders = snapshot.data!;
                return ListView(
                  children: orders.map(buildOrder).toList().reversed.toList(),
                );
              } else {
                return const Center(child: Text("No Orders"));
              }
            },
          ) : const CustomLoader())
              : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: Dimensions.height20 * 16,
                    margin: EdgeInsets.only(
                        left: Dimensions.width20, right: Dimensions.width20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/image/sign_in_to_continue.png"))),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getSignInPage());
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: Dimensions.height20 * 5,
                      margin: EdgeInsets.only(
                          left: Dimensions.width20, right: Dimensions.width20),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                      ),
                      child: Center(
                          child: BigText(
                            text: "Sign In",
                            color: Colors.white,
                            size: Dimensions.font20,
                          )),
                    ),
                  )
                ],
              ));
        }));
  }

  Widget buildOrder(PlaceOrderBody placeOrderBody) {
    docId = "";
    return placeOrderBody.userId.toString()==Get.find<UserController>().userModel!.id.toString()?
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          SizedBox(
              width: Dimensions.screenWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,
                    vertical: Dimensions.height10),
                child: InkWell(
                  onTap: (){
                    FirebaseFirestore.instance
                        .collection('orders')
                        .where('order_reference', isEqualTo: placeOrderBody.orderReference)
                        .get().then((value){
                      for (var element in value.docs){
                        docId = element.id;
                      }
                    });
                    String orderRef = placeOrderBody.orderReference;
                    String address = placeOrderBody.address;
                    String status = placeOrderBody.orderStatus;
                    int amount = placeOrderBody.orderAmount;
                    showDialog(context: context, builder:(context) {
                      Future.delayed(
                        const Duration(seconds: 1),
                            () {
                          Navigator.of(context).pop(true);
                        },
                      ).then((value) => {
                        if(docId != ""){
                          Get.toNamed('/track-order', arguments: [orderRef, address, amount, docId, status])
                        }
                      });
                      return const Center(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: AlertDialog(
                            title: Center(child: Text("Please Wait")),
                            content: CustomLoader(),
                          ),
                        ),
                      );
                    });
                  },
                  child: (
                      Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Order ID:", style: fontRegular.copyWith(
                                        fontSize: Dimensions.font12
                                    ),),
                                    SizedBox(width: Dimensions.width10,),
                                    Text('#${placeOrderBody.orderReference}')
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20 / 4)
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,
                                          vertical: Dimensions.width10/2),
                                      child: Text(
                                        placeOrderBody.orderStatus,
                                        style: fontMedium.copyWith(
                                          fontSize: Dimensions.font12,
                                          color: Theme.of(context).cardColor,
                                        ),),
                                    ),
                                    SizedBox(height: Dimensions.height10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius
                                            .circular(
                                            Dimensions.radius20 / 4),
                                        border: Border.all(width: 1, color: AppColors.mainColor),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(Dimensions.height10),
                                        child: const Text("Track Order"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: Dimensions.height10,),
                          ]
                      )
                  ),
                ),
              )
          ),
        ],
      ):Container();
  }
}
