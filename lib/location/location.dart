import 'dart:async';

import 'package:deltarider2/api/toJsonReceiveOrders.dart';
import 'package:deltarider2/location/message.dart';
import 'package:deltarider2/recieve/detail_receive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main_order.dart';
import 'package:deltarider2/api/toJsonLocation.dart';
import 'package:deltarider2/api/order_api.dart';
import 'package:deltarider2/main_order.dart';
import 'package:deltarider2/show_modal_app_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageLocations extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<PageLocations> {
  GoogleMapController _controller;
  List<Locations> list = new List();
  List<ReceiveOrders> listReceive = new List();
  Set<Marker> _markers = {};
  int _icon = 0, _index = 0, _count = 0;
  bool _show = false;
  BitmapDescriptor _markerIcon, _myIcon;
  MapType _currentMapType = MapType.normal;
  final GlobalKey scaffoldKey = new GlobalKey();
  Map<MarkerId, Marker> markers = {};
  Timer timer;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.terrain;
      _icon += 1;
      print(_icon);
      if (_icon == 2) {
        _icon = 0;
      }
    });
  }

  void _onClickMap() {
    setState(() {
      _show = true;
    });
  }

  void movePosition() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            // Will be fetching in the next step
            position.latitude,
            position.longitude,
          ),
          zoom: 15.0,
        ),
      ),
    );
  }

  // Future<Uint8List> getByteFromAssert(String path, ){
  //
  //
  //   return ;
  // }

  Future _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
      String icon = "assets/images/map-marker.png";
      setState(() {
        if (isIOS) {
          icon = "assets/images/map-marker32.png";
        }
      });

      ImageConfiguration configuration = ImageConfiguration();
      BitmapDescriptor bmpd =
          await BitmapDescriptor.fromAssetImage(configuration, icon);
      // BitmapDescriptor mbmpd = await BitmapDescriptor.fromAssetImage(
      //     configuration, 'assets/images/location.png');
      setState(() {
        _markerIcon = bmpd;
        // _myIcon = mbmpd;
      });
    }
  }

  Future<void> goToMessage(int i) async {
    Locations loData = list[i];
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MessageLocation(
              locations: loData,
            )));
  }

  Future getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    List _list = await fetchLocation();
    List _listReceive = await fetchReceiveOrders();
    print('getCurrentLocation');
    setState(() {
      position = res;
      list = _list;
      listReceive = _listReceive;
      for (int i = 0; i < list.length; i++) {
        Locations locations = list[i];
        _markers.add(new Marker(
            markerId: MarkerId(locations.memberId),
            position: LatLng(locations.location.lat, locations.location.lng),
            icon: _markerIcon,
            infoWindow: InfoWindow(
              title: 'ID : ${locations.orderIdRes}',
              snippet: 'คุณ ${locations.member.mmName}',
            ),
            onTap: () {
              setState(() {
                print(i);
                _index = i;
                _onClickMap();
              });
            }));
      }
    });
  }

  Future updateLocation() async {
    _markers = {};
    Position res = await Geolocator.getCurrentPosition();
    List _list = await fetchLocation();
    List _listReceive = await fetchReceiveOrders();
    print('updateLocation');
    setState(() {
      position = res;
      list = _list;
      listReceive = _listReceive;
      for (int i = 0; i < list.length; i++) {
        Locations locations = list[i];
        _markers.add(new Marker(
            markerId: MarkerId(locations.memberId),
            position: LatLng(locations.location.lat, locations.location.lng),
            icon: _markerIcon,
            infoWindow: InfoWindow(
              title: 'ID : ${locations.orderIdRes}',
              snippet: 'คุณ ${locations.member.mmName}',
            ),
            onTap: () {
              setState(() {
                print(i);
                _index = i;
                _onClickMap();
              });
            }));
      }
    });
  }

  Future<void> callNow(String phone) async {
    String url = 'tel://${phone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'call not possible';
    }
  }

  FutureOr onGoBack() {
    getCurrentLocation();
    setState(() {});
    print('fff');
  }

  @override
  void initState() {
    //reload();
    getCurrentLocation();
    databaseChat.onValue.listen((event) {
      print(event.snapshot.value);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getCurrentLocation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return Scaffold(
        key: scaffoldKey,
        body: position == null
            ? SpinKitRing(
                color: Colors.deepPurple[500],
                lineWidth: 5,
              )
            : Stack(
                children: [
                  GoogleMap(
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    buildingsEnabled: true,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: true,
                    mapType: _currentMapType,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 15.0),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      if (list == null) {
                        getCurrentLocation();
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buttonMap(
                              icon: Icons.map,
                              color: Colors.blue[200],
                              function: _onMapTypeButtonPressed),
                          buttonMap(
                              icon: Icons.my_location, function: movePosition),
                        ],
                      ),
                    ),
                  ),
                  _show ? showMapSheet() : Padding(padding: EdgeInsets.zero)
                ],
              ));
  }

  Widget showMapSheet() {
    Locations locations = list[_index];
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.all(5),
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: 140,
          child: InkWell(
            onTap: () {
              print('ss');
              int indexReceive = listReceive
                  .indexWhere((item) => item.orderId == locations.orderId);
              print(
                  'indexReceive ${listReceive.indexWhere((item) => item.orderId == locations.orderId)}');
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ReceiveDetail(listReceive[indexReceive])))
                  .whenComplete(() {
                print('sss');
                setState(() {
                  _show = false;
                });
                updateLocation();
              });
            },
            child: Card(
                elevation: 30,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Container(
                    //padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    child: DefaultTextStyle(
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black12,
                          backgroundImage: locations.member.picUrl.isNotEmpty
                              ? NetworkImage(
                                  locations.member.picUrl,
                                  scale: 10,
                                )
                              : AssetImage('assets/images/person_logo.png'),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              '${locations.member.mmName}',
                              overflow: TextOverflow.ellipsis,
                            )),
                            ButtonBar(
                              alignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              //buttonMinWidth: 100,
                              children: [
                                ClipOval(
                                  child: Material(
                                    color: Colors.blue[500], // button color
                                    child: InkWell(
                                      child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Icon(
                                            Icons.navigation_rounded,
                                            color: Colors.white,
                                          )),
                                      onTap: () {
                                        openMapsSheet(context,
                                            latLng: locations.location.lat,
                                            lngLng: locations.location.lng);
                                      },
                                    ),
                                  ),
                                ),
                                ClipOval(
                                  child: Material(
                                    color: Colors.teal[300], // button color
                                    child: InkWell(
                                      child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Icon(
                                            Icons.message,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                                      onTap: () {
                                        goToMessage(_index);
                                      },
                                    ),
                                  ),
                                ),
                                locations.member.phoneId.isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.zero,
                                      )
                                    : ClipOval(
                                        child: Material(
                                          color:
                                              Colors.cyan[500], // button color
                                          child: InkWell(
                                            child: SizedBox(
                                                width: 35,
                                                height: 35,
                                                child: Icon(
                                                  Icons.local_phone_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                )),
                                            onTap: () {
                                              callNow(locations.member.phoneId);
                                            },
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('ID : '),
                                    Flexible(
                                        child: Text('${locations.orderIdRes}',
                                            overflow: TextOverflow.ellipsis))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('เวลาสั่ง : '),
                                    Flexible(
                                        child: Text('${locations.timeStart}',
                                            overflow: TextOverflow.ellipsis))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('ราคารวม : '),
                                    Flexible(
                                        child: Text(
                                            '${locations.sumPrice}  บาท',
                                            overflow: TextOverflow.ellipsis))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('การชำระ : '),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        //side: BorderSide(width: 5, color: Colors.green)
                                      ),
                                      color: locations.paymentType == '0'
                                          ? Colors.red[800]
                                          : Colors.green,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        alignment: Alignment.center,
                                        child: Text(
                                          locations.paymentType == '0'
                                              ? 'เก็บเงินปลายทาง'
                                              : 'โอนแล้ว',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))),
          ),
        ));
  }

  Widget buttonMap(
      {@required IconData icon, Color color, @required Function function}) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 5.0,
            spreadRadius: 0.5,
          )
        ],
      ),
      child: ClipOval(
        child: Material(
          color: color == null ? Colors.white : color, // button color
          child: InkWell(
            //splashColor: Colors.orange, // inkwell color
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                icon,
                color: Colors.black54,
              ),
            ),
            onTap: () {
              function();
              onGoBack();
              //databaseRider.reference().child('528').remove();
              // ToastMe().showToastCenter(text: 'aaaa',color: Colors.black);
            },
          ),
        ),
      ),
    );
  }
}
