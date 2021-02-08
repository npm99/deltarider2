import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapLauncherDemo extends StatelessWidget {
  final double latLng;
  final double lngLng;

  //PersistentBottomSheetController sheetController;

  MapLauncherDemo({Key key, this.latLng, this.lngLng}) : super(key: key);

  openMapsSheet(context) async {
    try {
      final coords = Coords(latLng, lngLng);
      //final title = "Ocean Beach";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () {
                          // map.showMarker(
                          //   coords: coords,
                          //   //title: title,
                          // );
                          Navigator.pop(context);
                          map.showDirections(
                            destination: coords,
                            //title: title,
                          );
                        },
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Navigator.pop(context);
    return Container();
  }
}
