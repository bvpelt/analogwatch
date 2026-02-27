using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class DataFieldDrawer {
  //  private var _logger;
  private var _activityUtility;

  const DATAFIELD_NONE = 0;
  const DATAFIELD_STEPS = 1;
  const DATAFIELD_CALORIES = 2;
  const DATAFIELD_DISTANCE = 3;
  const DATAFIELD_FLOORS = 4;
  const DATAFIELD_ACTIVE_MINUTES = 5;
  const DATAFIELD_BATTERY = 6;
  const DATAFIELD_HEART_RATE = 7;

  function initialize() {
    //  _logger = getLogger();
    _activityUtility = getActivityUtility();
  }

  function drawDataField(dc, x, y, dataFieldType, analogFont, profile) as Void {
    if (dataFieldType == DATAFIELD_NONE ||
        profile.datafieldcolor == profile.facebgcolor) {
      return;
    }

    var value = "";
    var symbolChar = "";
    var font = Graphics.FONT_XTINY;

    // Get value and symbol based on type
    var data = getDataFieldData(dataFieldType);
    value = data[0];
    symbolChar = data[1];

    // Draw
    dc.setColor(profile.datafieldcolor, Graphics.COLOR_TRANSPARENT);

    var valueWidth = dc.getTextWidthInPixels(value, font);
    var symbolWidth = dc.getTextWidthInPixels(symbolChar, analogFont);
    var spacing = 3;
    var totalWidth = valueWidth + spacing + symbolWidth;

    var valueX = x - (totalWidth / 2);
    dc.drawText(valueX, y, font, value,
                Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

    var symbolX = valueX + valueWidth + spacing;
    dc.drawText(symbolX, y, analogFont, symbolChar,
                Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  private function getDataFieldData(dataFieldType) as Lang.Array {
    var value = "";
    var symbol = "";

    if (dataFieldType == DATAFIELD_STEPS) {
      var steps = _activityUtility.getSteps();
      value = steps != null ? steps.toString() : "--";
      symbol = "\uF006";
    } else if (dataFieldType == DATAFIELD_CALORIES) {
      var calories = _activityUtility.getCalories();
      value = calories != null ? calories.toString() : "--";
      symbol = "\uF008";
    } else if (dataFieldType == DATAFIELD_DISTANCE) {
      var distance = _activityUtility.getDistance();
      value = distance != null ? (distance / 100000.0).format("%.2f") : "--";
      symbol = "\uF011";
    } else if (dataFieldType == DATAFIELD_FLOORS) {
      var floors = _activityUtility.getFloorsClimbed();
      value = floors != null ? floors.toString() : "--";
      symbol = "\uF00E";
    } else if (dataFieldType == DATAFIELD_ACTIVE_MINUTES) {
      var activeMin = _activityUtility.getActiveMinutesDay();
      value = activeMin != null ? activeMin.toString() : "--";
      symbol = "\uF013";
    } else if (dataFieldType == DATAFIELD_BATTERY) {
      var battery = System.getSystemStats().battery;
      value = battery.format("%.0f") + "%";
      symbol = getBatterySymbol(battery);
    } else if (dataFieldType == DATAFIELD_HEART_RATE) {
      value = "--";
      symbol = "\uF010";
    }

    return [value, symbol];
  }

  private function getBatterySymbol(battery) as Lang.String {
    if (battery > 87) {
      return "\uF009";
    } else if (battery > 62) {
      return "\uF00A";
    } else if (battery > 37) {
      return "\uF00B";
    } else if (battery > 12) {
      return "\uF00C";
    } else {
      return "\uF00D";
    }
  }

  function drawBluetooth(dc, x, y, iconFont, profile) as Void {
    var phoneConnection = getPhoneConnection();
    var status = phoneConnection.getConnectionStatus();
    var color =
        status ? profile.bluethootactivecolor : profile.bluethootinactivecolor;
    ViewUtil.drawBlueTooth(dc, x, y, iconFont, color);
  }
}