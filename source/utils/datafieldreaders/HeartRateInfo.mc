// source/utils/HeartRateInfo.mc
using Toybox.Lang;

class HeartRateInfo {
  var heartRate as Lang.Number or Null;
  var inActivity as Lang.Boolean;
  var hasData as Lang.Boolean;

  function initialize(hr as Lang.Number or Null, inActivity as Lang.Boolean,
                      hasData as Lang.Boolean) {
    self.heartRate = hr;
    self.inActivity = inActivity;
    self.hasData = hasData;
  }

  function toString() as Lang.String {
    var hr = heartRate != null ? heartRate.toString() : "null";
    return "HeartRateInfo { heartRate: " + hr + ", inActivity: " + inActivity +
           ", hasData: " + hasData + " }";
  }
}