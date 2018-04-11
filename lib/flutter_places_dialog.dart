import 'dart:async';

import 'package:flutter/services.dart';

class PlaceLatLong {
  PlaceLatLong({this.latitude, this.longitude});
  num latitude;
  num longitude;
}

class PlaceBounds {
  PlaceBounds({
    this.northeast,
    this.southwest});
  PlaceLatLong northeast;
  PlaceLatLong southwest;
}

class PlaceDetails {
  PlaceDetails({
    this.address,
    this.placeid,
    this.location,
    this.name,
    this.phoneNumber,
    this.priceLevel,
    this.rating,
    this.bounds});
  String address;
  String placeid;
  PlaceLatLong location;
  String name;
  String phoneNumber;
  num priceLevel;
  num rating;
  PlaceBounds bounds;
}

class FlutterPlacesDialog {
  static const MethodChannel _channel =
      const MethodChannel('flutter_places_dialog');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> setGoogleApiKey(String key) async {
    bool ret = await _channel.invokeMethod("setApiKey", key);
    print("Initialized api key $key $ret");
    return ret;
  }

  static Future<PlaceDetails> getPlacesDialog() async {
    print('Opening places dialog');
   dynamic newData = await _channel.invokeMethod("showPlacePicker");
print('result $newData');
    Map<String, dynamic> data = await _channel.invokeMethod("showPlacesPicker");
    PlaceDetails details = new PlaceDetails();
    details.name = data["name"];
    details.address = data["address"];
    details.placeid = data["placeid"];
    details.location = new PlaceLatLong();
    details.location.longitude = data["longitude"];
    details.location.latitude = data["latitude"];
    details.phoneNumber = data["phoneNumber"];
    details.priceLevel = data["priceLevel"];
    details.rating = data["rating"];
    details.bounds = new PlaceBounds();
    details.bounds.northeast = new PlaceLatLong();
    details.bounds.northeast.latitude = data["bounds"]["northeast"]["latitude"];
    details.bounds.northeast.latitude =
    data["bounds"]["northeast"]["longitude"];
    details.bounds.southwest = new PlaceLatLong();
    details.bounds.northeast.latitude = data["bounds"]["southwest"]["latitude"];
    details.bounds.northeast.latitude =
    data["bounds"]["southwest"]["longitude"];
    return details;
  }
}
