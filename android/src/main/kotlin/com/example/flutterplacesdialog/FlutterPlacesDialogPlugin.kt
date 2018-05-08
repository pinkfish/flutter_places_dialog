package com.example.flutterplacesdialog

import android.app.Activity
import android.content.Intent
import android.location.Location
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.location.places.ui.PlacePicker
import com.google.android.gms.location.places.ui.PlaceAutocomplete
import com.google.android.gms.location.places.Place
import com.google.android.gms.common.GoogleApiAvailability

class FlutterPlacesDialogPlugin(val activity: Activity) : MethodCallHandler, io.flutter.plugin.common.PluginRegistry.ActivityResultListener {
    var placeResult: Result? = null
    val REQUEST_GOOGLE_PLAY_SERVICES = 1000
    var PLACE_PICKER_REQUEST: Int = 42

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "flutter_places_dialog")
            var plugin = FlutterPlacesDialogPlugin(activity = registrar.activity())
            channel.setMethodCallHandler(plugin)
            registrar.addActivityResultListener(plugin)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method.equals("setApiKey")) {
            // Don't really need to do anything here, maybe.
            System.out.println("Need to setup google-service.json on android");
            result.success(false)
        } else if (call.method.equals("showPlacesPicker")) {
            val code = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(activity)
            if (GoogleApiAvailability.getInstance().showErrorDialogFragment(activity, code, REQUEST_GOOGLE_PLAY_SERVICES)) {
                return
            }

            var intentBuilder = PlacePicker.IntentBuilder()
            activity.startActivityForResult(intentBuilder.build(activity), PLACE_PICKER_REQUEST)

            placeResult = result
            return
        } else {
            result.notImplemented()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        System.out.println("onActivityResult " + requestCode + " " + resultCode);
        if (requestCode == PLACE_PICKER_REQUEST) {
            if (resultCode == Activity.RESULT_OK) {
                if (data == null) {
                    System.out.println("data is null!!!!");
                }
                var selectedPlace = PlacePicker.getPlace(this.activity, data)
                var northeast = mapOf(
                        "latitude" to selectedPlace.getViewport()?.northeast?.latitude,
                        "longitude" to selectedPlace.getViewport()?.northeast?.longitude
                )
                var southwest = mapOf(
                        "latitude" to selectedPlace.getViewport()?.southwest?.latitude,
                        "longitude" to selectedPlace.getViewport()?.southwest?.longitude
                )
                var bounds = mapOf(
                        "northeast" to northeast,
                        "southwest" to southwest
                )

                var result = mapOf(
                        "address" to selectedPlace.getAddress().toString(),
                        "placeid" to selectedPlace.getId(),
                        "latitude" to selectedPlace.getLatLng().latitude,
                        "longitude" to selectedPlace.getLatLng().longitude,
                        "name" to selectedPlace.getName().toString(),
                        "phoneNumber" to selectedPlace.getPhoneNumber().toString(),
                        "priceLevel" to selectedPlace.getPriceLevel(),
                        "rating" to selectedPlace.getRating(),
                        "bounds" to bounds
                )

                placeResult?.success(result)

                return true
            } else if (resultCode == Activity.RESULT_CANCELED) {
                if (data == null) {
                    System.out.println("data is null!!!!");
                }
                placeResult?.error("PICK_FAILED", "Error getting place", null);
                return true
            } else if (resultCode == PlaceAutocomplete.RESULT_ERROR) {
                if (data == null) {
                    System.out.println("data is null!!!!");
                }
                System.out.println(PlaceAutocomplete.getStatus(this.activity, data));
                placeResult?.error("PICK_FAILED", "Invalid API Code: "
                        + PlaceAutocomplete.getStatus(this.activity, data), null);
            }
        }
        return false
    }
}

