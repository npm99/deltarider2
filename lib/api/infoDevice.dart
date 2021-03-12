import 'dart:async';

import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'order_api.dart';

import 'dart:convert';

Future getId() async {
  var deviceInfo = DeviceInfoPlugin();
  String tokenFirebase;
  try {
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      tokenFirebase = token;
      // print("Token : $token");
    });
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      // print(_readIosDeviceInfo(iosDeviceInfo, tokenFirebase));
      return _readIosDeviceInfo(
          iosDeviceInfo, tokenFirebase); // unique ID on iOS

    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      // print(_readAndroidBuildData(androidDeviceInfo,tokenFirebase));
      return _readAndroidBuildData(
          androidDeviceInfo, tokenFirebase); // unique ID on Android

    }
  } on PlatformException {
    Map<String, dynamic> deviceData = <String, dynamic>{
      'Error:': 'Failed to get platform version.'
    };
    print(deviceData);
  }
}

Map<String, dynamic> _readAndroidBuildData(
    AndroidDeviceInfo build, String tokenFirebase) {
  return <String, dynamic>{
    'platform': 'Android',
    'token': tokenFirebase,
    // 'version.securityPatch': build.version.securityPatch,
    // 'version.sdkInt': build.version.sdkInt,
    'version': build.version.release,
    // 'version.previewSdkInt': build.version.previewSdkInt,
    // 'version.incremental': build.version.incremental,
    // 'version.codename': build.version.codename,
    // 'version.baseOS': build.version.baseOS,
    // 'board': build.board,
    // 'bootloader': build.bootloader,
    // 'brand': build.brand,
    // 'device': build.device,
    // 'display': build.display,
    // 'fingerprint': build.fingerprint,
    // 'hardware': build.hardware,
    // 'host': build.host,
    // 'id': build.id,
    // 'manufacturer': build.manufacturer,
    // 'model': build.model,
    // 'product': build.product,
    // 'supported32BitAbis': build.supported32BitAbis,
    // 'supported64BitAbis': build.supported64BitAbis,
    // 'supportedAbis': build.supportedAbis,
    // 'tags': build.tags,
    // 'type': build.type,
    // 'isPhysicalDevice': build.isPhysicalDevice,
    'uuid': build.androidId, //UUID
    // 'systemFeatures': build.systemFeatures,
  };
}

Map<String, dynamic> _readIosDeviceInfo(
    IosDeviceInfo data, String tokenFirebase) {
  return <String, dynamic>{
    'platform': 'IOS',
    'token': tokenFirebase,
    // 'name': data.name,
    // 'systemName': data.systemName,
    // 'systemVersion': data.systemVersion,
    // 'model': data.model,
    // 'localizedModel': data.localizedModel,
    'uuid': data.identifierForVendor, //UUID
    // 'isPhysicalDevice': data.isPhysicalDevice,
    // 'utsname.sysname:': data.utsname.sysname,
    // 'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    // 'utsname.machine:': data.utsname.machine,
  };
}

DeviceInfo deviceInfoFromJson(String str) =>
    DeviceInfo.fromJson(json.decode(str));

String deviceInfoToJson(DeviceInfo data) => json.encode(data.toJson());

class DeviceInfo {
  DeviceInfo({
    this.platform,
    this.token,
    this.version,
    this.uuid,
  });

  String platform;
  String token;
  String version;
  String uuid;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
        platform: json["platform"],
        token: json["token"],
        version: json["version"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "platform": platform,
        "token": token,
        "version": version,
        "uuid": uuid,
      };
}
