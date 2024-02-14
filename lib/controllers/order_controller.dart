import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService{
  int _paymentIndex=0;
  int get paymentIndex=> _paymentIndex;

  String _orderType="Delivery";
  String get orderType=>_orderType;

  void setPaymentIndex(int index){
    _paymentIndex=index;
    update();
  }

  void setDeliveryType(String type){
    _orderType=type;
    update();
  }
}