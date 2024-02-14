import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/base/custom_loader.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/controllers/auth_controller.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/views/auth/reset_account_page.dart';
import 'package:temis_special_snacks/views/auth/sign_up_page.dart';
import 'package:temis_special_snacks/widgets/app_text_field.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text="";
    passwordController.text="";
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    void login(AuthController authController){

      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      if(phone.isEmpty){
        showCustomSnackBar("Type in your phone number", title: "Phone number");
      }else if(password.isEmpty){
        showCustomSnackBar("Type in your password", title: "Password");
      }else if(password.length<6){
        showCustomSnackBar("Password can't be less than six characters", title: "Password");
      }else if(phone.length<14 || phone.length>14){
        showCustomSnackBar("Phone number format incorrect", title: "Phone number");
      }else if(!phone.contains("+234")){
        showCustomSnackBar("Enter correct country code", title: "Phone number");
      }else if(!phoneController.text.isNum){
        showCustomSnackBar("Enter correct characters", title: "Phone number");
      }else{
        authController.login(phone, password).then((status){
          if(status.isSuccess){
            Get.toNamed(RouteHelper.getInitial());
          }else{
            showCustomSnackBar(status.message);
          }
        });
      }
    }

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
                      Text("Hello",
                        style: TextStyle(
                          fontSize: Dimensions.font20*3+Dimensions.font20/2,
                          fontWeight: FontWeight.bold,
                        ),),
                      Text("Sign in to your account",
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          color: Colors.grey[500],
                        ),)
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height20,),
                //email
                AppTextField(textEditingController: phoneController,
                    hintText: "+234 803 XXX",
                    icon: Icons.phone,
                    textInputType: TextInputType.phone,
                    inputFormatters:[FilteringTextInputFormatter.deny(
                        RegExp(r"\s\b|\b\s"))
                    ]),
                SizedBox(height: Dimensions.height20,),
                //password
                AppTextField(
                    textEditingController: passwordController,
                    hintText: "Password",
                    icon: Icons.password_sharp,
                    isObscure:true),

                SizedBox(height: Dimensions.height30,),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(text: TextSpan(
                          recognizer: TapGestureRecognizer()..
                          onTap=()=>Get.to(()=> const ResetAccountPage(),
                              transition: Transition.fade),
                          text: "Reset account!",
                          style: TextStyle(
                            color: AppColors.blueColor,
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.bold,
                          )
                      )),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height30,),
                //sign in button
                GestureDetector(
                  onTap: (){
                    login(_authController);
                  },
                  child: Container(
                    width: Dimensions.screenWidth/2,
                    height: Dimensions.screenHeight/13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      color: AppColors.mainColor,
                    ),
                    child: Center(
                      child: BigText(text: "Sign In",
                        size: Dimensions.font10*3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height30,),
                //sign up options
                RichText(text: TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: Dimensions.font20,
                    ),
                    children:[
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const SignUpPage(), transition: Transition.fade),
                          text: " Sign Up",
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
}
