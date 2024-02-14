import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temis_special_snacks/base/custom_app_bar.dart';
import 'package:temis_special_snacks/base/custom_loader.dart';
import 'package:temis_special_snacks/base/show_custom_snackbar.dart';
import 'package:temis_special_snacks/controllers/auth_controller.dart';
import 'package:temis_special_snacks/controllers/location_controller.dart';
import 'package:temis_special_snacks/controllers/user_controller.dart';
import 'package:temis_special_snacks/models/address_model.dart';
import 'package:temis_special_snacks/routes/route_helper.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/views/address/pick_address_map.dart';
import 'package:temis_special_snacks/widgets/app_text_field.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();

  late bool _isLogged;

  double lat = 0;
  double lng = 0;
  bool isCurrentLocation = false;

  late CameraPosition _cameraPosition;
  late LatLng _initialPosition;

  final Set<Polygon> _polygon = HashSet<Polygon>();

  List<LatLng> points = [
    const LatLng(9.104823, 7.492553),
    const LatLng(9.089623, 7.413802),
    const LatLng(9.052197, 7.432933),
    const LatLng(9.018008, 7.494148),
    const LatLng(9.052079, 7.522440),
  ];

  void _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() {
          lat = 9.057562617529577;
          lng = 7.469023713936724;
        });
      }else{
        var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          lat =position.latitude;
          lng = position.longitude;
        });
      }
    }else{
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        lat =position.latitude;
        lng = position.longitude;
      });
    }
    _cameraPosition = CameraPosition(target: LatLng(lat, lng), zoom: 17);
    _initialPosition = LatLng(lat, lng);

    if(Get.find<LocationController>().addressList.isNotEmpty){
      if(Get.find<LocationController>().getUserAddressFromLocalStorage()==""){
        Get.find<LocationController>().saveUserAddress(Get.find<LocationController>().addressList.last);
      }
      Get.find<LocationController>().getUserAddress();
      _cameraPosition=CameraPosition(target: LatLng(
          double.parse(Get.find<LocationController>().getAddress["latitude"]),
          double.parse(Get.find<LocationController>().getAddress["longitude"])
      ));
      _initialPosition =
          LatLng(
              double.parse(Get.find<LocationController>().getAddress["latitude"]),
              double.parse(Get.find<LocationController>().getAddress["longitude"]));
      _addressController.text = Get.find<LocationController>().getUserAddress().address;
      isCurrentLocation =true;
    }else{
      _cameraPosition = CameraPosition(target: LatLng(lat, lng), zoom: 17);
      _initialPosition= LatLng(lat, lng);
      isCurrentLocation =true;
    }
  }

  @override
  void initState(){
    super.initState();
    _isLogged= Get.find<AuthController>().userLoggedIn();
    if(_isLogged&&Get.find<UserController>().userModel==null){
      Get.find<UserController>().getUserInfo();
    }

    _getCurrentLocation();

    _polygon.add(Polygon(
      polygonId: const PolygonId('Temi Special'),
      points: points,
      fillColor: AppColors.mainColor.withOpacity(0.3),
      strokeColor: AppColors.mainColor,
      geodesic: true,
      strokeWidth: 4,
    ));

    _addressController.text ="";
    _contactPersonName.text="";
    _contactPersonNumber.text="";
  }

  @override
  void dispose() {
    _addressController.dispose();
    _contactPersonNumber.dispose();
    _contactPersonName.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Get.toNamed(RouteHelper.getInitial());
        return false;
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Address"),
        body: GetBuilder<UserController>(builder: (userController){
          if(userController.userModel!=null&&_contactPersonName.text.isEmpty){
            _contactPersonName.text = '${userController.userModel?.name}';
            _contactPersonNumber.text = '${userController.userModel?.phone}';
            // if(Get.find<LocationController>().addressList.isNotEmpty){
            //   _addressController.text = Get.find<LocationController>().getUserAddress().address;
            // }
          }
          return GetBuilder<LocationController>(builder: (locationController){
            _addressController.text = '${locationController.placemark.name??''}'
                '${locationController.placemark.locality??''}'
                '${locationController.placemark.postalCode??''}'
                '${locationController.placemark.country??''}';


            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Dimensions.height160,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 2, color: AppColors.mainColor,
                        )
                    ),
                    child: isCurrentLocation?Stack(
                      children: [
                        GoogleMap(initialCameraPosition:
                        CameraPosition(target: _initialPosition, zoom: 17),
                          onTap: (latlng){
                            Get.toNamed(RouteHelper.getPickAddressPage(),
                            arguments: PickAddressMap(
                              fromSignup: false,
                              fromAddress: true,
                              googleMapController: locationController.mapController,
                            ));
                          },
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: false,
                          myLocationEnabled: true,
                          polygons: _polygon,
                          onCameraIdle: (){
                            locationController.updatePosition(_cameraPosition, true);
                          },
                          onCameraMove: ((position)=>_cameraPosition=position),
                          onMapCreated: (GoogleMapController controller){
                            locationController.setMapController(controller);
                            if(Get.find<LocationController>().addressList.isEmpty){
                              //Edit code to get user location and put here
                            }
                          },
                        )
                      ],
                    ):const CustomLoader(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.width20, top: Dimensions.height20),
                    child: SizedBox(height: 50, child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: locationController.addressTypeList.length,
                        itemBuilder: (context, index){
                      return InkWell(
                        onTap: (){
                          locationController.setAddressTypeIndex(index);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20,
                              vertical: Dimensions.height20),
                          margin: EdgeInsets.only(right: Dimensions.width10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20/4),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200]!,
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                                index==0?Icons.home_filled:index==1?Icons.work:Icons.location_on,
                                color: locationController.addressTypeIndex==index?
                                AppColors.mainColor:Theme.of(context).disabledColor,
                              ),
                        ),
                      );
                    }),),
                  ),
                  SizedBox(height: Dimensions.height20,),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.width20),
                    child: BigText(text: "Delivery Address"),),
                  SizedBox(height: Dimensions.height10,),
                  AppTextField(textEditingController: _addressController, hintText: "Your address", icon: Icons.map, enabled: false, readOnly: true,),
                  SizedBox(height: Dimensions.height20,),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.width20),
                    child: BigText(text: "Contact Name"),),
                  SizedBox(height: Dimensions.height10,),
                  AppTextField(textEditingController: _contactPersonName, hintText: "Your name", icon: Icons.person, enabled: false, readOnly: true,),
                  SizedBox(height: Dimensions.height20,),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.width20),
                    child: BigText(text: "Contact Number"),),
                  SizedBox(height: Dimensions.height10,),
                  AppTextField(textEditingController: _contactPersonNumber, hintText: "Your number", icon: Icons.phone, enabled: false, readOnly: true,),
                ],
              ),
            );
          });
        }),
        bottomNavigationBar: GetBuilder<LocationController>(builder: (locationController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Dimensions.bottomHeightBar,
                padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  bottom: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                ),
                decoration: BoxDecoration(
                    color: AppColors.buttonBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20 * 2),
                      topRight: Radius.circular(Dimensions.radius20 * 2),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AddressModel _addressModel = AddressModel(addressType:
                        locationController.addressTypeList[locationController.addressTypeIndex],
                          contactPersonName: _contactPersonName.text,
                          contactPersonNumber: _contactPersonNumber.text,
                          address: _addressController.text,
                          latitude: locationController.position.latitude.toString(),
                          longitude: locationController.position.longitude.toString(),
                        );
                        locationController.addAddress(_addressModel).then((response){
                          if(response.isSuccess){
                            Get.toNamed(RouteHelper.getInitial());
                            showCustomSnackBar(title: "Success", "Added successfully");
                          }else{
                            showCustomSnackBar(title: "Error", "Couldn't save address");
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: Dimensions.height20,
                          bottom: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(Dimensions.radius20),
                          color: AppColors.mainColor,
                        ),
                        child: BigText(
                          text: "Save Address",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
