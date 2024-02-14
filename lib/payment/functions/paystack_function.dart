import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/controllers/cart_controller.dart';
import 'package:temis_special_snacks/controllers/location_controller.dart';
import 'package:temis_special_snacks/controllers/order_controller.dart';
import 'package:temis_special_snacks/controllers/user_controller.dart';
import 'package:temis_special_snacks/payment/models/place_order_model.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';
import 'package:twilio_flutter/twilio_flutter.dart';


TwilioFlutter twilioFlutter = TwilioFlutter(
accountSid : AppConstants.twilioSID, // replace *** with Account SID
authToken : AppConstants.twilioAuthToken,  // replace xxx with Auth Token
twilioNumber : AppConstants.twilioNumber  // replace .... with Twilio Number
);

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

var location = Get.find<LocationController>().getUserAddress();
var cart = Get.find<CartController>().getItems;
var user = Get.find<UserController>().userModel;
var totalAmount = Get.find<CartController>().totalAmount;
var orderType = Get.find<OrderController>().orderType;

bool isSuccessful = false;

PlaceOrderBody placeOrder = PlaceOrderBody(
  cart: cart,
  orderAmount: totalAmount,
  address: location.address,
  latitude: location.latitude,
  longitude: location.longitude,
  contactPersonName: user!.name,
  contactPersonNumber: user!.phone,
  contactPersonEmail: user!.email,
  userId: user!.id,
  orderReference: getRandomString(6),
  orderStatus: "preparing order",
  orderType: orderType,
  orderTime: DateFormat('dd/MMMM/yyyy – h:mm a').format(DateTime.now()),
);

class MakePayment{
   MakePayment({required this.ctx, required this.orderAmount});
   BuildContext ctx;
   int orderAmount;

  PaystackPlugin paystack = PaystackPlugin();

  PaymentCard _getCardUI(){
    return PaymentCard(
        number: "",
        cvc: "",
        expiryMonth: 0,
        expiryYear: 0
    );
  }

  Future initializePlugin() async{
    var collection = FirebaseFirestore.instance.collection('paystack');
    var docSnapshot = await collection.doc('details').get();
    if(docSnapshot.exists){
      Map<String, dynamic>? data = docSnapshot.data();
      try {
        String  publicKey = data?['public_key'];
        await paystack.initialize(publicKey: publicKey);
      }catch(e){ }
    }
  }
  chargeCard(){
    initializePlugin().then((_) async{
      Charge charge = Charge()
        ..amount = orderAmount * 100
        ..email = user!.email
        ..reference = getRandomString(10)
        ..card = _getCardUI();

      CheckoutResponse response = await paystack.checkout(
        ctx,
        charge: charge,
        method: CheckoutMethod.card,
        fullscreen: false,
        logo: Image.asset("assets/image/temis_special_snacks_img.png", width: 80, height: 80)
      );

      if(response.status == true){
        isSuccessful = true;
        sendDataToFirestore();
        sendSMS();
      }else{
        isSuccessful = false;
        sendDataToFirestore();
      }
    });
  }
}

void sendDataToFirestore () async{
  final orderDetails = FirebaseFirestore.instance.collection('orders').doc();
  if (isSuccessful) {
    // process result
    await orderDetails.set(placeOrder.toJson());
    Get.find<CartController>().addToHistory();
    Get.toNamed(RouteHelper.getInitial());
    Get.find<CartController>().removeCartSharedPreference();
    showCustomSnackBar(title: "Status", "Transaction successful, thank you");
  } else {
    showCustomSnackBar(title: "Status", "Transaction failed, please try again");
  }
}

void sendSMS () {
  if(user!.phone.contains("+234")){
    twilioFlutter.sendSMS(
        toNumber : user!.phone,
        messageBody : 'Hi ${user!.name}, your order has been successfully placed. You will receive an update shortly.');
    twilioFlutter.sendSMS(
        toNumber : '+2348133672989',
        messageBody : 'New order alert');
  }else{
    twilioFlutter.sendSMS(
        toNumber : '+234${user!.phone}',
        messageBody : 'Hi ${user!.name}, your order has been successfully placed. You will receive an update shortly.');
    twilioFlutter.sendSMS(
        toNumber : '+2348133672989',
        messageBody : 'New order alert');
  }
}