import 'dart:async';

import 'package:flutter/services.dart';

enum PriceLevel {
  Unknown,
  Free,
  Cheap,
  Medium,
  High,
  Expensive
}

class PlaceLatLong {
  PlaceLatLong({this.latitude, this.longitude});
  num latitude;
  num longitude;
}

class PlaceBounds {
  PlaceBounds({this.northeast, this.southwest});
  PlaceLatLong northeast;
  PlaceLatLong southwest;
}

class PlaceDetails {
  PlaceDetails(
      {this.address,
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
  PriceLevel priceLevel;
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
    Map<dynamic, dynamic> data = await _channel.invokeMethod("showPlacesPicker");
    print("Places data $data");
    PlaceDetails details = new PlaceDetails();
    details.name = data["name"];
    details.address = data["address"];
    details.placeid = data["placeid"];
    details.location = new PlaceLatLong();
    details.location.longitude = data["longitude"];
    details.location.latitude = data["latitude"];
    details.phoneNumber = data["phoneNumber"];
    switch (data["priceLevel"]) {
      case -1:
        details.priceLevel = PriceLevel.Unknown;
        break;
      case 0:
        details.priceLevel= PriceLevel.Free;
        break;
      case 1:
        details.priceLevel = PriceLevel.Cheap;
        break;
      case 2:
        details.priceLevel = PriceLevel.Medium;
        break;
      case 3:
        details.priceLevel= PriceLevel.High;
        break;
      case 4:
        details.priceLevel = PriceLevel.Expensive;
        break;
      default:
        details.priceLevel = PriceLevel.Unknown;
        break;
    }
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
