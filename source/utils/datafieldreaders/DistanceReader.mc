using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Lang;

class DistanceReader extends Reader {

  public function initialize() { Reader.initialize(); }

  // Current workout session distance
  private function getActivityDistance() as Lang.Number or Null {
    var info = Activity.getActivityInfo();
    if (info != null && info.elapsedDistance != null) {
      return info.elapsedDistance;
    }
    return null;
  }

  // Daily total distance from activity monitor
  private function getDailyDistance() as Lang.Number or Null {
    return ActivityMonitor.getInfo().distance;
  }

  public function getDistance() as Lang.Number or Null {
    if (isInActivity()) {
      return getActivityDistance(); // session km
    }
    return getDailyDistance(); // daily total km
  }
}