import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temis_special_snacks/data/api/api_client.dart';
import 'package:temis_special_snacks/models/signup_body_model.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';

class AuthRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> registration(SignUpBody signUpBody) async{
    return await apiClient.postData(AppConstants.registrationUri, signUpBody.toJson());
  }

  bool userLoggedIn(){
    return sharedPreferences.containsKey(AppConstants.token);
  }

  String getUserToken(){
    return sharedPreferences.getString(AppConstants.token)??"None";
  }

  Future<Response> login(String phone, String password) async{
    return await apiClient.postData(AppConstants.loginUri, {"phone":phone, "password":password});
  }

  Future<bool> saveUserToken(String token) async{
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async{
    try{
      await sharedPreferences.setString(AppConstants.phone, number);
      await sharedPreferences.setString(AppConstants.password, password);
    }catch(e){
      rethrow;
    }
  }

  bool clearSharedData(){
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.password);
    sharedPreferences.remove(AppConstants.phone);
    apiClient.token='';
    apiClient.updateHeader('');
    return true;
  }
}