import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/base/common_text_button.dart';
import 'package:temis_special_snacks/base/custom_app_bar.dart';
import 'package:temis_special_snacks/base/custom_loader.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/controllers/auth_controller.dart';
import 'package:temis_special_snacks/controllers/cart_controller.dart';
import 'package:temis_special_snacks/controllers/location_controller.dart';
import 'package:temis_special_snacks/controllers/user_controller.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/utils/styles.dart';
import 'package:temis_special_snacks/widgets/account_widget.dart';
import 'package:temis_special_snacks/widgets/app_icon.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';

class AccountPage extends StatefulWidget{
  const AccountPage({Key? key}) : super(key: key);
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;


  TextEditingController messageController = TextEditingController();
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    messageController.text = "";
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if(_userLoggedIn){
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }
    return Scaffold(
      appBar: const CustomAppBar(title: "Profile"),
      body: GetBuilder<UserController>(builder: (userController){
        return _userLoggedIn?
        (userController.isLoading?
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: Dimensions.height20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //name
                AccountWidget(
                    appIcon: AppIcon(icon: Icons.person,
                      backgroundColor: AppColors.iconColor2,
                      iconColor: Colors.white,
                      iconSize: Dimensions.height10*5/2,
                      size: Dimensions.height10*5,),
                    bigText: BigText(text: userController.userModel!.name,)),
                SizedBox(height: Dimensions.height20,),
                //phone
                AccountWidget(
                    appIcon: AppIcon(icon: Icons.phone,
                      backgroundColor: AppColors.iconColor2,
                      iconColor: Colors.white,
                      iconSize: Dimensions.height10*5/2,
                      size: Dimensions.height10*5,),
                    bigText: BigText(text: userController.userModel!.phone,)),
                SizedBox(height: Dimensions.height20,),
                //email
                AccountWidget(
                    appIcon: AppIcon(icon: Icons.email,
                      backgroundColor: AppColors.iconColor2,
                      iconColor: Colors.white,
                      iconSize: Dimensions.height10*5/2,
                      size: Dimensions.height10*5,),
                    bigText: BigText(text:  userController.userModel!.email,)),
                SizedBox(height: Dimensions.height20,),
                //address
                GetBuilder<LocationController>(builder: (locationController){
                  if(_userLoggedIn&&locationController.addressList.isEmpty){

                  //if(_userLoggedIn&&locationController.getAddressList().isBlank!){

                    return GestureDetector(
                      onTap: (){
                        Get.offNamed(RouteHelper.getAddressPage());
                      },
                      child: AccountWidget(
                          appIcon: AppIcon(icon: Icons.location_on,
                            backgroundColor: Colors.lightGreen,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height10*5/2,
                            size: Dimensions.height10*5,),
                          bigText: BigText(text: "Type in your address",)),
                    );
                  }else{
                    return GestureDetector(
                      onTap: (){
                        Get.offNamed(RouteHelper.getAddressPage());
                      },
                      child: AccountWidget(
                          appIcon: AppIcon(icon: Icons.location_on,
                            backgroundColor: Colors.lightGreen,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height10*5/2,
                            size: Dimensions.height10*5,),
                          bigText: BigText(text: "Your address",)),
                    );
                  }
                }),
                SizedBox(height: Dimensions.height20,),
                //message
                InkWell(
                  onTap: (){
                    _pressed=false;
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        builder: (context){
                          return Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height/2,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radius20),
                                        topRight: Radius.circular(Dimensions.radius20),
                                      )
                                  ),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height/2,
                                    padding: EdgeInsets.only(
                                      left: Dimensions.width20,
                                      right: Dimensions.width20,
                                      top: Dimensions.height20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Leave a message",
                                            style: fontMedium.copyWith(fontSize: Dimensions.font20)),
                                        SizedBox(height: Dimensions.height20,),
                                        Container(
                                          padding: EdgeInsets.all(Dimensions.width10),
                                          height: 200,
                                          width: 350,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(Dimensions.radius15),
                                          ),
                                          child: TextField(
                                            controller: messageController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            expands: true,
                                            textCapitalization: TextCapitalization.sentences,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),

                                          ),
                                        ),
                                        SizedBox(height: Dimensions.height20,),
                                        GestureDetector(
                                            onTap: () async{
                                              if(_pressed==false){
                                                String message = messageController.text;
                                                try{
                                                  if(message.isNotEmpty){
                                                    _pressed = true;
                                                    final collection = FirebaseFirestore.instance.collection('feedback');
                                                    await collection.doc().set({
                                                      'message': message,
                                                      'user_email': userController.userModel!.email,
                                                      'user_number': userController.userModel!.phone,});
                                                    if (!mounted) return;
                                                    Navigator.of(context).pop();
                                                    showCustomSnackBar(title: "Sent", "Message sent successfully");
                                                    messageController.clear();
                                                  }else{showCustomSnackBar(title: "Error", "Type in a message");}
                                                }catch(e){ showCustomSnackBar(e.toString());}
                                              }else{
                                                showCustomSnackBar(title: "Error", "Message sent already");
                                              }
                                            } ,
                                            child: const CommonTextButton(text: "Send")),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: AccountWidget(
                      appIcon: AppIcon(icon: Icons.message_outlined,
                        backgroundColor: Colors.lightGreen,
                        iconColor: Colors.white,
                        iconSize: Dimensions.height10*5/2,
                        size: Dimensions.height10*5,),
                      bigText: BigText(text: "Contact Us",)),
                ),
                SizedBox(height: Dimensions.height20,),
                //messages
                GestureDetector(
                  onTap: () async{
                    try{
                      final collection = FirebaseFirestore.instance.collection('reset_request');
                      await collection.doc().set({
                        'user_email': userController.userModel!.email,
                        'request': "Please delete my account"}).then((_){
                        if(Get.find<AuthController>().userLoggedIn()){
                          Get.find<AuthController>().clearSharedData();
                          Get.find<CartController>().clear();
                          Get.find<CartController>().clearCartHistory();
                          Get.find<LocationController>().clearAddressList();
                          Get.offNamed(RouteHelper.getSignInPage());
                          showCustomSnackBar(title: "Success", "Request sent successfully");
                        }else{
                          Get.offNamed(RouteHelper.getSignInPage());
                        }
                      });
                    }catch(e){ showCustomSnackBar(e.toString());}
                  },
                  child: AccountWidget(
                      appIcon: AppIcon(icon: Icons.delete_forever,
                        backgroundColor: Colors.red,
                        iconColor: Colors.white,
                        iconSize: Dimensions.height10*5/2,
                        size: Dimensions.height10*5,),
                      bigText: BigText(text: "Delete Account",)),
                ),
                SizedBox(height: Dimensions.height20,),
                GestureDetector(
                  onTap: (){
                    if(Get.find<AuthController>().userLoggedIn()){
                      Get.find<AuthController>().clearSharedData();
                      //Get.find<CartController>().clear();
                      Get.find<CartController>().clearCartHistory();
                      Get.find<LocationController>().clearAddressList();
                      Get.offNamed(RouteHelper.getSignInPage());
                    }else{
                      Get.offNamed(RouteHelper.getSignInPage());
                    }
                  },
                  child: AccountWidget(
                      appIcon: AppIcon(icon: Icons.logout,
                        backgroundColor: Colors.red,
                        iconColor: Colors.white,
                        iconSize: Dimensions.height10*5/2,
                        size: Dimensions.height10*5,),
                      bigText: BigText(text: "Logout",)),
                ),
              ],
            ),
          ),
        ):
        const CustomLoader()):
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
          width: double.maxFinite,
          height: Dimensions.height20*16,
          margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      "assets/image/sign_in_to_continue.png"
                  )
              )
          ),
        ),
            GestureDetector(
              onTap: (){
                Get.toNamed(RouteHelper.getSignInPage());
              },
              child: Container(
                width: double.maxFinite,
                height: Dimensions.height20*5,
                margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                decoration:  BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Center(child: BigText(text: "Sign In", color: Colors.white, size: Dimensions.font20,)),
              ),
            )
          ],));
      },),
    );
  }
}
