import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/views/auth/sign_in_page.dart';
import 'package:temis_special_snacks/widgets/app_text_field.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';



class ResetAccountPage extends StatefulWidget {

  const ResetAccountPage({Key? key}) : super(key: key);

  @override
  State<ResetAccountPage> createState() => _ResetAccountPageState();
}

class _ResetAccountPageState extends State<ResetAccountPage> {

  final emailController = TextEditingController();


  @override
  void initState() {
    super.initState();
    emailController.text="";
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: Dimensions.screenHeight*0.40,),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Enter your email to send an account reset request",
                          style: TextStyle(
                            fontSize: Dimensions.font20,
                            color: Colors.grey[500],
                          ),)
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height20,),
                  SizedBox(
                      child: AppTextField(
                          textEditingController: emailController,
                          hintText: "Email",
                          icon: Icons.email_outlined,
                          textInputType: TextInputType.emailAddress,
                          inputFormatters:[FilteringTextInputFormatter.deny(
                              RegExp(r"\s\b|\b\s"))
                          ]
                      )),
                  SizedBox(height: Dimensions.height20*3,),
                  GestureDetector(
                    onTap: (){
                      resetAccount();
                      showAlert();
                    },
                    child: Container(
                      width: Dimensions.screenWidth/2,
                      height: Dimensions.screenHeight/13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainColor,
                      ),
                      child: Center(
                        child: BigText(text: "Reset",
                          size: Dimensions.font10*3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  RichText(text: TextSpan(
                      recognizer: TapGestureRecognizer()..
                      onTap=()=>Get.to(()=> const SignInPage(),
                          transition: Transition.fade),
                      text: "Go back",
                      style: TextStyle(
                        color: AppColors.blueColor,
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.bold,
                      )
                  )),
                ],
              ),
            ))
      );}

  void resetAccount() async{
    String email = emailController.text;
    try{
      if(email.isNotEmpty && GetUtils.isEmail(email)){
        final collection = FirebaseFirestore.instance.collection('reset_request');
        await collection.doc().set({
          'email': email,
          'request': "Please reset my account"
        });
        emailController.clear();
      }else{}
    }catch(e){ print(e.toString());}
  }

  void showAlert() {
    String email = emailController.text;
    if(email.isNotEmpty && GetUtils.isEmail(email)){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(
            const Duration(seconds: 5),
                () {
              Navigator.of(context).pop(true);
            },
          ).then((value) => {
            Get.toNamed(RouteHelper.getSignUpPage())
          });
          return const AlertDialog(
            title: Text('Request Successful'),
            content: Text('Your account will be reset within 30 minutes and then you can Sign Up again.'),
          );
        },
      );
    }else{
      showCustomSnackBar(title: "Error", "Please type in your correct email");
    }
  }
}