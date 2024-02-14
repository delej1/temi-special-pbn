import 'package:temis_special_snacks/models/cart_model.dart';

class PlaceOrderBody {
  List<CartModel>? _cart;
  late int _orderAmount;
  late String _address;
  late String _latitude;
  late String _longitude;
  late String _contactPersonName;
  late String _contactPersonNumber;
  late String _contactPersonEmail;
  late int _userId;
  late String _orderReference;
  late String _orderStatus;
  late String _orderType;
  late String _orderTime;

  PlaceOrderBody(
      {required List<CartModel> cart,
        required int orderAmount,
        required String address,
        required String latitude,
        required String longitude,
        required String contactPersonName,
        required String contactPersonNumber,
        required String contactPersonEmail,
        required int userId,
        required String orderReference,
        required String orderStatus,
        required String orderType,
        required String orderTime,
      }){
    this._cart = cart;
    this._orderAmount = orderAmount;
    this._address = address;
    this._latitude = latitude;
    this._longitude = longitude;
    this._contactPersonName = contactPersonName;
    this._contactPersonNumber = contactPersonNumber;
    this._contactPersonEmail = contactPersonEmail;
    this._userId = userId;
    this._orderReference = orderReference;
    this._orderStatus = orderStatus;
    this._orderType = orderType;
    this._orderTime = orderTime;
  }

  List<CartModel> get cart => _cart!;
  int get orderAmount => _orderAmount;
  String get address => _address;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get contactPersonName => _contactPersonName;
  String get contactPersonNumber => _contactPersonNumber;
  String get contactPersonEmail => _contactPersonEmail;
  int get userId => _userId;
  String get orderReference => _orderReference;
  String get orderStatus => _orderStatus;
  String get orderType => _orderType;
  String get orderTime => _orderTime;

  PlaceOrderBody.fromJson(Map<dynamic, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart!.add(CartModel.fromJson(v));
      });
    }
    _orderAmount = json['order_amount'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
    _contactPersonEmail = json['contact_person_email'];
    _userId = json['user_id'];
    _orderReference = json['order_reference'];
    _orderStatus = json['order_status'];
    _orderType = json['order_type'];
    _orderTime = json['order_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this._cart != null) {
      data['cart'] = this._cart!.map((v) => v.toJson()).toList();
    }
    data['order_amount'] = this._orderAmount;
    data['address'] = this._address;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['contact_person_name'] = this._contactPersonName;
    data['contact_person_number'] = this._contactPersonNumber;
    data['contact_person_email'] = this._contactPersonEmail;
    data['user_id'] = this._userId;
    data['order_reference'] = this._orderReference;
    data['order_status'] = this._orderStatus;
    data['order_type'] = this._orderType;
    data['order_time'] = this._orderTime;
    return data;
  }
}