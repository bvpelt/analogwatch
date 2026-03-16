using Toybox.Activity;
using Toybox.SensorHistory;
using Toybox.Lang;

class HeartRateReader extends Reader {

  public function initialize() { Reader.initialize(); }

  // Returns live HR from active workout
  private function getActivityHeartRate() as Lang.Number or Null {
    var _activityInfo = Activity.getActivityInfo();
    if (_activityInfo != null && _activityInfo.currentHeartRate != null) {
      _logger.trace("HeartRateRader",
                    "current hartrate: " + _activityInfo.currentHeartRate);
      return _activityInfo.currentHeartRate;
    }
    return null;
  }

  // Returns most recent HR from sensor history (resting)
  private function getRestingHeartRate() as Lang.Number or Null {
    if (!(Toybox has: SensorHistory) ||
        !(SensorHistory has: getHeartRateHistory)) {
      return null;
    }

    var iterator = SensorHistory.getHeartRateHistory(
        { : period => 1, : order => SensorHistory.ORDER_NEWEST_FIRST });

    var sample = iterator.next();
    if (sample != null && sample.data != null) {
      _logger.trace("HeartRateRader",
                    "fallback sensor history current hartrate: " +
                        sample.data.toNumber());

      return sample.data.toNumber();
    }
    return null;
  }

  // Main method — auto-selects correct source
  function getHeartRate() as Lang.Number or Null {
    if (isInActivity()) {
      return getActivityHeartRate();
    }
    return getRestingHeartRate();
  }

  // Returns HR with metadata — fully typed, no warnings
  function getHeartRateInfo() as HeartRateInfo {
    var inActivity = isInActivity();
    var hr = inActivity ? getActivityHeartRate() : getRestingHeartRate();
    var hrinfo = new HeartRateInfo(hr, inActivity, hr != null);
    _logger.trace("HeartRateRader", "info: " + hrinfo.toString());

    return hrinfo;
  }
}