using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Lang;

class CalorieReader extends Reader {

  public function initialize() { Reader.initialize(); }

  private function getInActivityCalories() as Lang.Number or Null {
    var info = Activity.getActivityInfo();
    if (info != null) {
      return info.calories;
    }
    return null;
  }

  private function getNotInActivityCalories() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return (info != null && info.calories != null) ? info.calories : 0;
  }

  public function getCalories() as Lang.Number or Null {
    if (isInActivity()) {
      _logger.trace("CalorieReader",
                    "isInactivity calories: " + getInActivityCalories());
      return getInActivityCalories();
    }
    _logger.trace("CalorieReader",
                  "Not isInactivity calories: " + getNotInActivityCalories());
    return getNotInActivityCalories();
  }
}