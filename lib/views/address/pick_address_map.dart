import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temis_special_snacks/base/custom_button.dart';
import 'package:temis_special_snacks/base/custom_loader.dart';
import 'package:temis_special_snacks/controllers/location_controller.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/views/address/widgets/search_location_dialogue_page.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignup;
  final bool fromAddress;
  final GoogleMapController? googleMapController;

  const PickAddressMap({Key? key,
    required this.fromSignup,
    required this.fromAddress,
    this.googleMapController}) : super(key: key);

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  double lat = 0;
  double lng = 0;
  bool isCurrentLocation =false;

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
    if(Get.find<LocationController>().addressList.isEmpty){
        _initialPosition= LatLng(lat, lng);
        _cameraPosition=CameraPosition(target: _initialPosition, zoom: 17);
        isCurrentLocation = true;
    }else{
      if(Get.find<LocationController>().addressList.isNotEmpty){
        _initialPosition=LatLng(double.parse(Get.find<LocationController>().getAddress["latitude"]),
            double.parse(Get.find<LocationController>().getAddress["longitude"]));
        _cameraPosition=CameraPosition(target: _initialPosition, zoom: 17);
        isCurrentLocation = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    _polygon.add(Polygon(
      polygonId: const PolygonId('Temi Special'),
      points: points,
      fillColor: AppColors.mainColor.withOpacity(0.3),
      strokeColor: AppColors.mainColor,
      geodesic: true,
      strokeWidth: 4,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return isCurrentLocation?
      GetBuilder<LocationController>(builder: (locationController){
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                children: [
                  GoogleMap(initialCameraPosition: CameraPosition(
                      target: _initialPosition, zoom: 17
                  ),
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    polygons: _polygon,
                    onCameraMove: (CameraPosition cameraPosition){
                      _cameraPosition=cameraPosition;
                    },
                    onCameraIdle: (){
                      Get.find<LocationController>().updatePosition(_cameraPosition, false);
                    },
                    onMapCreated: (GoogleMapController mapController){
                    _mapController = mapController;
                    if(!widget.fromAddress){}
                    },
                  ),
                  Center(
                    child: !locationController.loading?Image.asset("assets/image/pick_marker.png",
                    height: 50, width: 50,
                    ):const CircularProgressIndicator()
                  ),
                  Positioned(
                      top: Dimensions.height45,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child: InkWell(
                        onTap: ()=>Get.dialog(LocationDialogue(mapController: _mapController)),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 25, color: AppColors.mainBlackColor,),
                              Expanded(child: Text(
                                locationController.pickPlacemark.name??'',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.font20,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              SizedBox(width: Dimensions.width10,),
                              const Icon(Icons.search, size: 25, color: AppColors.mainBlackColor,)
                            ],
                          ),
                        ),
                      )
                  ),
                  Positioned(
                      bottom: 80,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child: CustomButton(
                        buttonText: 'Pick Address',
                        onPressed: (locationController.loading)?null:(){
                          if(locationController.pickPosition.latitude!=0&&
                              locationController.pickPlacemark.name!=null){
                            if(widget.fromAddress){
                              if(widget.googleMapController!=null){
                                widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
                                    CameraPosition(target: LatLng(
                                      locationController.pickPosition.latitude,
                                      locationController.pickPosition.longitude,
                                    ))));
                                locationController.setAddAddressData();
                              }
                              Get.back();
                            }
                          }
                        },
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }):const CustomLoader();
  }
}
