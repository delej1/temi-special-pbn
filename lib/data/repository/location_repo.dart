import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temis_special_snacks/data/api/api_client.dart';
import 'package:temis_special_snacks/utils/app_constants.dart';

import '../../models/address_model.dart';

class LocationRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAddressFromGeocode(LatLng latlng) async{
    return await apiClient.getData('${AppConstants.geocodeUri}'
        '?lat=${latlng.latitude}&lng=${latlng.longitude}'
    );
  }

  String getUserAddress(){
    return sharedPreferences.getString(AppConstants.userAddress)??"";
  }

  Future<Response> addAddress(AddressModel addressModel) async{
    return await apiClient.postData(AppConstants.addUserAddress, addressModel.toJson());
  }

  Future<Response> getAllAddress() async{
    return await apiClient.getData(AppConstants.addressListUri);
  }

  Future<bool> saveUserAddress(String address) async{
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.token)!);
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  Future<Response> searchLocation(String text) async{
    return await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  Future<Response> setLocation(String placeID) async{
    return await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
  }
}