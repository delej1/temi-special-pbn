import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temis_special_snacks/models/cart_model.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';

class CartRepo{
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<String> cart=[];
  List<String> cartHistory=[];

  void addToCartList(List<CartModel> cartList){
    /*sharedPreferences.remove(AppConstants.cartList);
    sharedPreferences.remove(AppConstants.cartHistoryList);
    return;*/

    var time = DateTime.now().toString();
    cart=[];

    //convert objects to string for shared preference
    cartList.forEach((element){
      element.time = time;
      return cart.add(jsonEncode(element));
    });
    sharedPreferences.setStringList(AppConstants.cartList, cart);
    getCartList();
  }

  List<CartModel> getCartList(){
    List<String> carts=[];
    if(sharedPreferences.containsKey(AppConstants.cartList)){
      carts = sharedPreferences.getStringList(AppConstants.cartList)!;
    }
    List<CartModel> cartList=[];
    
    carts.forEach((element) => cartList.add(CartModel.fromJson(jsonDecode(element))));

    return cartList;
  }

  List<CartModel> getCartHistoryList(){
    if(sharedPreferences.containsKey(AppConstants.cartHistoryList)){
      cartHistory=[];
      cartHistory = sharedPreferences.getStringList(AppConstants.cartHistoryList)!;
    }
    List<CartModel> cartListHistory=[];
    cartHistory.forEach((element) => cartListHistory.add(CartModel.fromJson(jsonDecode(element))));
    return cartListHistory;
  }

  void addToCartHistoryList(){
    if(sharedPreferences.containsKey(AppConstants.cartHistoryList)){
      cartHistory = sharedPreferences.getStringList(AppConstants.cartHistoryList)!;
    }
    for(int i=0; i<cart.length; i++){
      cartHistory.add(cart[i]);
    }
    cart=[];
    sharedPreferences.setStringList(AppConstants.cartHistoryList, cartHistory);
  }

  void removeCart(){
    cart=[];
    sharedPreferences.remove(AppConstants.cartList);
  }

  void clearCartHistory(){
    removeCart();
    cartHistory=[];
    sharedPreferences.remove(AppConstants.cartHistoryList);
  }

  void removeCartSharedPreference(){
    sharedPreferences.remove(AppConstants.cartList);
    sharedPreferences.remove(AppConstants.cartHistoryList);
  }
}