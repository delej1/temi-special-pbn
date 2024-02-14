import 'package:get/get.dart';
import 'package:temis_special_snacks/data/api/api_client.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';

class UserRepo{
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> getUserInfo() async{
    return await apiClient.getData(AppConstants.userInfoUri);
  }
}