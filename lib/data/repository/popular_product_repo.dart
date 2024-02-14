import 'package:get/get.dart';
import 'package:temis_special_snacks/data/api/api_client.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';

class PopularProductRepo extends GetxService{
  final ApiClient apiClient;
  PopularProductRepo({required this.apiClient});

  Future<Response> getPopularProductList() async{
    return await apiClient.getData(AppConstants.popularProductsUri);
  }
}