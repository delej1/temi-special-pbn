import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/base/custom_loader.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/controllers/auth_controller.dart';
import 'package:temis_special_snacks/models/signup_body_model.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/views/auth/sign_up_page.dart';
import 'package:temis_special_snacks/widgets/app_text_field.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';



class VerifyNumber extends StatefulWidget {
  final String verificationId;
  final String name;
  final String phone;
  final String email;
  final String password;
  const VerifyNumber({Key? key, required this.verificationId,
    required this.name,
    required this.phone,
    required this.email,
    required this.password
  }) : super(key: key);

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {

  final codeController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    codeController.text="";
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: GetBuilder<AuthController>(builder: (_authController){
            return !_authController.isLoading?SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: Dimensions.screenHeight*0.05,),
                  //app logo
                  SizedBox(
                    height: Dimensions.screenHeight*0.25,
                    child: const Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        backgroundImage: AssetImage(
                            "assets/image/temis_special_snacks_img.png"
                        ),
                      ),
                    ),
                  ),
                  //welcome
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi!",
                          style: TextStyle(
                            fontSize: Dimensions.font20*3+Dimensions.font20/2,
                            fontWeight: FontWeight.bold,
                          ),),
                        Text("Kindly verify your phone number",
                          style: TextStyle(
                            fontSize: Dimensions.font20,
                            color: Colors.grey[500],
                          ),)
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height20,),
                  SizedBox(width: Dimensions.width350, child: AppTextField(textEditingController: codeController, hintText: "OTP", icon: Icons.password, textInputType: TextInputType.number,)),
                  SizedBox(height: Dimensions.height20*3,),
                  GestureDetector(
                    onTap: (){
                      verifyOTP();
                    },
                    child: Container(
                      width: Dimensions.screenWidth/2,
                      height: Dimensions.screenHeight/13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainColor,
                      ),
                      child: Center(
                        child: BigText(text: "Verify",
                          size: Dimensions.font10*3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height30,),
                  //sign up options
                  RichText(text: TextSpan(
                      text: "Didn't receive code?",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font20,
                      ),
                      children:[
                        TextSpan(
                            recognizer: TapGestureRecognizer()..
                            onTap=()=>Get.to(()=>const SignUpPage(), transition: Transition.fade),
                            text: " Try again",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainBlackColor,
                              fontSize: Dimensions.font20,
                            )),
                      ]
                  )),
                  SizedBox(height: Dimensions.height15,),
                ],
              ),
            ):const CustomLoader();
          },)
      ),
    );
  }
  void verifyOTP() async{
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: codeController.text);
    try{
      await auth.signInWithCredential(credential);
      var user = FirebaseAuth.instance.currentUser;
      if(user!=null){
        registration(Get.find<AuthController>());
      }
    }catch(e){
      showCustomSnackBar(title: "Error","Invalid verification code");
    }
  }

  registration(AuthController authController){
    String name = widget.name;
    String phone = widget.phone;
    String email = widget.email;
    String password = widget.password;

    SignUpBody signUpBody = SignUpBody(name: name,
        phone: phone,
        email: email,
        password: password);
    authController.registration(signUpBody).then((status){
      if(status.isSuccess){
        Get.offNamed(RouteHelper.getInitial());
      }else{
        showCustomSnackBar(status.message);
      }
    });
  }
}