import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/base/custom_loader.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/controllers/auth_controller.dart';
import 'package:temis_special_snacks/models/signup_body_model.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/views/auth/sign_in_page.dart';
import 'package:temis_special_snacks/widgets/app_text_field.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  final auth = FirebaseAuth.instance;
  bool loading = false;
  bool formOkay = false;

  @override
  void initState() {
    super.initState();
    emailController.text="";
    passwordController.text="";
    nameController.text="";
    phoneController.text="";
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: !loading?(GetBuilder<AuthController>(builder: (_authController){
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
                //email
                AppTextField(textEditingController: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    textInputType: TextInputType.emailAddress,
                    inputFormatters:[FilteringTextInputFormatter.deny(
                        RegExp(r"\s\b|\b\s"))
                    ]
                ),
                SizedBox(height: Dimensions.height20,),
                //password
                AppTextField(textEditingController: passwordController,
                    hintText: "Password",
                    icon: Icons.password_sharp,
                    isObscure:true),
                SizedBox(height: Dimensions.height20,),
                //name
                AppTextField(textEditingController: nameController,
                    hintText: "Name",
                    textCapitalization: TextCapitalization.words,
                    icon: Icons.person),
                SizedBox(height: Dimensions.height20,),
                //phone
                AppTextField(textEditingController: phoneController,
                    hintText: "+234 803 XXX",
                    icon: Icons.phone,
                    textInputType: TextInputType.phone,
                    inputFormatters:[FilteringTextInputFormatter.deny(
                        RegExp(r"\s\b|\b\s"))
                    ]),
                SizedBox(height: Dimensions.height20,),
                //sign up button
                GestureDetector(
                  onTap: (){
                    formCheck();
                    setState((){
                      if(formOkay){
                        loading = true;
                        registration(Get.find<AuthController>());
                        //verifyPhoneNumber();
                      }else{

                      }
                    });
                  },
                  child: Container(
                    width: Dimensions.screenWidth/2,
                    height: Dimensions.screenHeight/13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      color: AppColors.mainColor,
                    ),
                    child: Center(
                      child: BigText(text: "Sign Up",
                        size: Dimensions.font10*3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height30,),
                //tag line
                RichText(text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const SignInPage(), transition: Transition.fade),
                    text: "Have an account already?",
                    style: TextStyle(
                      color: AppColors.blueColor,
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.bold,
                    )
                )),
              ],
            ),
          ):const CustomLoader();
        })):const CustomLoader(),
      ),
    );
  }

  // void verifyPhoneNumber(){
  //   auth.verifyPhoneNumber(
  //     phoneNumber: phoneController.text,
  //     verificationCompleted: (_){
  //       loading = false;
  //     },
  //     verificationFailed: (e){
  //       loading = false;
  //     },
  //     codeSent: (String verificationId, int? token){
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>
  //           VerifyNumber(
  //             verificationId: verificationId,
  //             name: nameController.text.trim(),
  //             phone: phoneController.text.trim(),
  //             email: emailController.text.trim(),
  //             password: passwordController.text.trim(),
  //           )));
  //       loading = false;
  //     },
  //     codeAutoRetrievalTimeout: (e){
  //       loading = false;
  //     },);
  // }

  void formCheck(){
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(name.isEmpty){
      showCustomSnackBar("Type in your name", title: "Name");
      formOkay = false;
    }else if(phone.isEmpty){
      showCustomSnackBar("Type in your phone number", title: "Phone number");
      formOkay = false;
    }else if(email.isEmpty){
      showCustomSnackBar("Type in your email address", title: "Email address");
      formOkay = false;
    }else if(!GetUtils.isEmail(email)){
      showCustomSnackBar("Type in a valid email address", title: "Invalid email address");
      formOkay = false;
    }else if(password.isEmpty){
      showCustomSnackBar("Type in your password", title: "Password");
      formOkay = false;
    }else if(password.length<6){
      showCustomSnackBar("Password can't be less than six characters", title: "Password");
      formOkay = false;
    }else if(phone.length<14 || phone.length>14){
      showCustomSnackBar("Phone number format incorrect", title: "Phone number");
      formOkay = false;
    }else if(!phone.contains("+234")){
      showCustomSnackBar("Enter correct country code", title: "Phone number");
      formOkay = false;
    }else if(!phoneController.text.isNum){
      showCustomSnackBar("Enter correct characters", title: "Phone number");
      formOkay = false;
    }else{
      formOkay = true;
    }
  }

  void registration(AuthController authController){
    SignUpBody signUpBody = SignUpBody(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );
    authController.registration(signUpBody).then((status){
      if(status.isSuccess){
        loading = false;
        Get.offNamed(RouteHelper.getInitial());
      }else{
        showCustomSnackBar(status.message);
      }
    });
  }
}
