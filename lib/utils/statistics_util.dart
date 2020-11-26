import 'dart:math';

import 'package:gms_admin/models/truck_location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';

class StatisticsUtil {
  Future<int> addStops({List<TruckLocation> locations}) async {
    int count = 0;
    locations.map((e) {
      if (e != locations.last &&
          locations[locations.indexOf(e) + 1]
                  .uploadTime
                  .difference(e.uploadTime) >
              Duration(minutes: 2)) {
        count++;
      }
    }).toList();
    return count;
  }

  List getDumpingCount(List<TruckLocation> locations) {
    List<TruckLocation> dumpingLocations = [];
    Duration totalDumpingTime = Duration(minutes: 0);
    List<Point> dumpingArea = [
      Point(13.341320873955144, 74.75151016828592),
      Point(13.332421681680591, 74.74937654791862),
      Point(13.327698150749073, 74.75908756256104),
      Point(13.337766737857178, 74.76276613532096)
    ];
    int count = 0;
    bool insideDump = false;
    locations.map((e) {
      if (insideDump) {
        dumpingLocations.add(e);
        if (!PolyUtils.containsLocationPoly(
            Point(e.latitude, e.longitude), dumpingArea)) {
          totalDumpingTime += dumpingLocations.last.uploadTime
              .difference(dumpingLocations.first.uploadTime);
          dumpingLocations.clear();
          insideDump = false;
        }
      } else {
        if (PolyUtils.containsLocationPoly(
            Point(e.latitude, e.longitude), dumpingArea)) {
          dumpingLocations.add(e);
          count++;
          insideDump = true;
        }
      }
    }).toList();
    if (dumpingLocations.length > 2) {
      totalDumpingTime += dumpingLocations.last.uploadTime
          .difference(dumpingLocations.first.uploadTime);
      dumpingLocations.clear();
    }
    return [count, totalDumpingTime];
  }
}
