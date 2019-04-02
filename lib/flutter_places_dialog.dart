import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum PriceLevel { Unknown, Free, Cheap, Medium, High, Expensive }

class PlaceLatLong {
  const PlaceLatLong({
    @required this.latitude,
    @required this.longitude,
  });
  final double latitude;
  final double longitude;

  PlaceLatLong.fromJson(Map<String, dynamic> data)
      : this(
          latitude: data['latitude'],
          longitude: data['longitude'],
        );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

class PlaceBounds {
  const PlaceBounds({
    @required this.northeast,
    @required this.southwest,
  });
  final PlaceLatLong northeast;
  final PlaceLatLong southwest;

  PlaceBounds.fromJson(Map<String, dynamic> data)
      : this(
          northeast: PlaceLatLong.fromJson(data['northeast']),
          southwest: PlaceLatLong.fromJson(data['southwest']),
        );

  Map<String, dynamic> toJson() => {
        'northeast': northeast.toJson(),
        'southwest': southwest.toJson(),
      };
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

  static Future<PlaceDetails> getPlacesDialog({
    PlaceBounds bounds,
  }) async {
    print('Opening places dialog');
    Map<dynamic, dynamic> data =
        await _channel.invokeMethod("showPlacesPicker", {
      "bounds": bounds?.toJson(),
    });
    print("Places data $data");
    PlaceDetails details = new PlaceDetails();
    details.name = data["name"];
    details.address = data["address"];
    details.placeid = data["placeid"];
    details.location = new PlaceLatLong.fromJson(data);
    details.phoneNumber = data["phoneNumber"];
    switch (data["priceLevel"]) {
      case -1:
        details.priceLevel = PriceLevel.Unknown;
        break;
      case 0:
        details.priceLevel = PriceLevel.Free;
        break;
      case 1:
        details.priceLevel = PriceLevel.Cheap;
        break;
      case 2:
        details.priceLevel = PriceLevel.Medium;
        break;
      case 3:
        details.priceLevel = PriceLevel.High;
        break;
      case 4:
        details.priceLevel = PriceLevel.Expensive;
        break;
      default:
        details.priceLevel = PriceLevel.Unknown;
        break;
    }
    details.rating = data["rating"];
    details.bounds = new PlaceBounds.fromJson(data['bounds']);
    return details;
  }
}
