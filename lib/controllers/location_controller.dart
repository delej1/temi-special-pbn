import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/data/api/api_checker.dart';
import 'package:temis_special_snacks/data/repository/location_repo.dart';
import 'package:temis_special_snacks/models/address_model.dart';
import 'package:temis_special_snacks/models/response_model.dart';
import 'package:google_maps_webservice/src/places.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});

  bool _loading = false;
  late Position _position;
  late Position _pickPosition;

  Placemark _placemark = Placemark();
  Placemark _pickPlacemark =Placemark();

  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList=>_addressList;

  late List<AddressModel> _allAddressList;
  List<AddressModel> get allAddressList => _allAddressList;

  final List<String> _addressTypeList=["home", "office", "others"];
  List<String> get addressTypeList => _addressTypeList;

  int _addressTypeIndex=0;
  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  bool _updateAddressData=true;
  bool _changeAddress=true;

  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;

  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;

  List<Prediction> _predictionList = [];



  void setMapController(GoogleMapController mapController){
    _mapController=mapController;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async{
    if(_updateAddressData){
      _loading=true;
      update();
      try{
        if(fromAddress){
          _position=Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1
          );
        }else{
          _pickPosition=Position(
              latitude: position.target.latitude,
              longitude: position.target.longitude,
              timestamp: DateTime.now(),
              heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1
          );
        }
        if(_changeAddress){
          String _address = await getAddressFromGeocode(
            LatLng(
                position.target.latitude, position.target.longitude)
          );
          fromAddress?_placemark=Placemark(name: _address):
          _pickPlacemark=Placemark(name: _address);
        }else{
          _changeAddress = true;
        }
      }catch(e){
        print(e.toString());
      }
      _loading = false;
      update();
    }else{
      _updateAddressData=true;
    }
  }

  Future<String> getAddressFromGeocode(LatLng latlng) async{
    String _address = "Unknown Location Found";
    Response response = await locationRepo.getAddressFromGeocode(latlng);
    if(response.body["status"]=='OK'){
      _address = response.body["results"][0]['formatted_address'].toString();
    }else{
      print("Error getting the google api");
    }
    update();
    return _address;
  }

  late Map<String, dynamic> _getAddress;
  Map<String, dynamic> get getAddress => _getAddress;

  AddressModel getUserAddress(){
    late AddressModel _addressModel;
    _getAddress = jsonDecode(locationRepo.getUserAddress());//json decodes string to map
    try{
      _addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    }catch(e){
      print(e.toString());
    }
    return _addressModel;
  }

  void setAddressTypeIndex(int index){
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async{
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if(response.statusCode==200){
      await getAddressList();
      String message = response.body["message"];
      responseModel = ResponseModel(true, message);
      await saveUserAddress(addressModel);
    }else{
      responseModel = ResponseModel(false, response.statusText!);
      showCustomSnackBar("Couldn't save the address");
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList() async{
    Response response = await locationRepo.getAllAddress();
    if(response.statusCode==200){
      _addressList=[];
      _allAddressList=[];
      response.body.forEach((address){
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    }else{
      _addressList=[];
      _allAddressList=[];
    }
    update();
  }

  Future<bool> saveUserAddress(AddressModel addressModel) async{
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  void clearAddressList(){
    _addressList=[];
    _allAddressList=[];
    update();
  }

  String getUserAddressFromLocalStorage(){
    return locationRepo.getUserAddress();
  }

  void setAddAddressData(){
    _position=_pickPosition;
    _placemark=_pickPlacemark;
    _updateAddressData=false;
    update();
  }


  Future<List<Prediction>> searchLocation(BuildContext context, String text) async{
    if(text.isNotEmpty){
      Response response = await locationRepo.searchLocation(text);
      if(response.statusCode==200&&response.body['status']=='OK'){
        _predictionList=[];
        response.body['predictions'].forEach((prediction)
        =>_predictionList.add(Prediction.fromJson(prediction)));
      }else{
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  setLocation(String placeID, String address, GoogleMapController mapController) async{
    _loading = true;
    update();
    PlacesDetailsResponse detail;
    Response response = await locationRepo.setLocation(placeID);
    detail = PlacesDetailsResponse.fromJson(response.body);
    _pickPosition = Position(
      latitude: detail.result.geometry!.location.lat,
      longitude: detail.result.geometry!.location.lng,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1
    );
    _pickPlacemark = Placemark(name: address);
    _changeAddress = false;
    if(!mapController.isNull){
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(
          detail.result.geometry!.location.lat,
          detail.result.geometry!.location.lng,
        ), zoom: 17)
      ));
    }
    _loading = false;
    update();
  }
}