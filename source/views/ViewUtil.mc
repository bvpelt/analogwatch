using Toybox.Graphics;
using Toybox.Lang;
using Toybox.ActivityMonitor;

module ViewUtil {
  var _logger = getLogger();

  public function getColor(status as Lang.Number) {
    var color;
    if (status == PhoneConnection.STATUS_CONNECTED) {
      color = Graphics.COLOR_GREEN;
    } else if (status == PhoneConnection.STATUS_CONNECTING) {
      color = Graphics.COLOR_YELLOW;
    } else {
      color = Graphics.COLOR_RED;
    }

    return color;
  }

  public function drawBlueTooth(dc as Graphics.Dc, x, y, font, status) as Void {
    dc.setColor(getColor(status), Graphics.COLOR_TRANSPARENT);
    var bluetoothIcon = "\ue904";
    dc.drawText(x, y, font, bluetoothIcon,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  public function drawBattery(dc as Graphics.Dc, x, y, font, percentage) {
    var batterySymbol = mapPercentageToBatterySymbol(percentage);
    dc.drawText(x, y, font, batterySymbol,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  public function drawSteps(dc as Graphics.Dc, x, y, font,
                            info as ActivityMonitor.Info) {
    var steps = 0;
    if (info != null && info.steps != null) {
      steps = info.steps;

      dc.drawText(x, y, font, steps,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
  }

  public function drawDistance(dc as Graphics.Dc, x, y, font,
                               info as ActivityMonitor.Info) {
    var distance = 0;
    if (info != null && info.distance != null) {
      distance = info.distance / 100; // convert from cm to m
      var displayString = "";

      if (distance < 1000) {
        // Format as integer meters
        displayString = distance.format("%d") + " m";
      } else {
        // Convert to km and format with 2 decimal places
        var km = distance.toFloat() / 1000.0;
        displayString = km.format("%.2f") + " km";
      }

      dc.drawText(x, y, font, displayString,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
  }

  function mapPercentageToBatterySymbol(percentage) {
    var empty = "\ue909";
    var quart = "\ue906";
    var half = "\ue907";
    var threequart = "\ue908";
    var full = "\ue90a";

    var batterySymbol;

    if (percentage >= 0 && percentage < 25) {
      batterySymbol = empty;
    } else if (percentage >= 25 && percentage < 50) {
      batterySymbol = quart;
    } else if (percentage >= 50 && percentage < 75) {
      batterySymbol = half;
    } else if (percentage >= 75 && percentage < 95) {
      batterySymbol = threequart;
    } else {
      batterySymbol = full;
    }

    _logger.trace("ViewUtil",
                  "mapPercentageToBatterySymbol percentage: " + percentage +
                      " symbol: " + batterySymbol.toString());
    return batterySymbol;
  }
}