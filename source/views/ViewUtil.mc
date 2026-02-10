using Toybox.Graphics;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.System;

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

  /*
  BUTTON_INPUT_SELECT	0x00000001
  API Level 1.2.0

  BUTTON_INPUT_UP	0x00000002
  API Level 1.2.0

  BUTTON_INPUT_DOWN	0x00000004
  API Level 1.2.0

  BUTTON_INPUT_MENU	0x00000008
  API Level 1.2.0

  BUTTON_INPUT_CLOCK	0x00000010
  API Level 3.1.0

  BUTTON_INPUT_DOWN_LEFT	0x00000020
  API Level 3.1.0

  BUTTON_INPUT_DOWN_RIGHT	0x00000040
  API Level 3.1.0

  BUTTON_INPUT_ESC	0x00000080
  API Level 3.1.0

  BUTTON_INPUT_FIND	0x00000100
  API Level 3.1.0

  BUTTON_INPUT_LAP	0x00000200
  API Level 3.1.0

  BUTTON_INPUT_LEFT	0x00000400
  API Level 3.1.0

  BUTTON_INPUT_LIGHT	0x00000800
  API Level 3.1.0

  BUTTON_INPUT_MODE	0x00001000
  API Level 3.1.0

  BUTTON_INPUT_PAGE	0x00002000
  API Level 3.1.0

  BUTTON_INPUT_POWER	0x00004000
  API Level 3.1.0

  BUTTON_INPUT_RESET	0x00008000
  API Level 3.1.0

  BUTTON_INPUT_RIGHT	0x00010000
  API Level 3.1.0

  BUTTON_INPUT_SPORT	0x00020000
  API Level 3.1.0

  BUTTON_INPUT_START	0x00040000
  API Level 3.1.0

  BUTTON_INPUT_UP_LEFT	0x00080000
  API Level 3.1.0

  BUTTON_INPUT_UP_RIGHT	0x00100000
  API Level 3.1.0

  BUTTON_INPUT_ZIN	0x00200000
  API Level 3.1.0

  BUTTON_INPUT_ZOUT	0x00400000
  API Level 3.1.0

  */
  public function inputButtonsToString(inputButtons as System.ButtonInputs) {
    var buttons = "";

    if (inputButtons & System.BUTTON_INPUT_SELECT) {
      buttons = buttons + "BUTTON_INPUT_SELECT ";
    }
    if (inputButtons & System.BUTTON_INPUT_UP) {
      buttons = buttons + "BUTTON_INPUT_UP ";
    }
    if (inputButtons & System.BUTTON_INPUT_DOWN) {
      buttons = buttons + "BUTTON_INPUT_DOWN ";
    }
    if (inputButtons & System.BUTTON_INPUT_MENU) {
      buttons = buttons + "BUTTON_INPUT_MENU ";
    }
    if (inputButtons & System.BUTTON_INPUT_CLOCK) {
      buttons = buttons + "BUTTON_INPUT_CLOCK ";
    }
    if (inputButtons & System.BUTTON_INPUT_DOWN_LEFT) {
      buttons = buttons + "BUTTON_INPUT_DOWN_LEFT ";
    }
    if (inputButtons & System.BUTTON_INPUT_DOWN_RIGHT) {
      buttons = buttons + "BUTTON_INPUT_DOWN_RIGHT ";
    }
    if (inputButtons & System.BUTTON_INPUT_ESC) {
      buttons = buttons + "BUTTON_INPUT_ESC ";
    }
    if (inputButtons & System.BUTTON_INPUT_FIND) {
      buttons = buttons + "BUTTON_INPUT_FIND ";
    }
    if (inputButtons & System.BUTTON_INPUT_LAP) {
      buttons = buttons + "BUTTON_INPUT_LAP ";
    }
    if (inputButtons & System.BUTTON_INPUT_LEFT) {
      buttons = buttons + "BUTTON_INPUT_LEFT ";
    }
    if (inputButtons & System.BUTTON_INPUT_LIGHT) {
      buttons = buttons + "BUTTON_INPUT_LIGHT ";
    }
    if (inputButtons & System.BUTTON_INPUT_MODE) {
      buttons = buttons + "BUTTON_INPUT_MODE ";
    }
    if (inputButtons & System.BUTTON_INPUT_PAGE) {
      buttons = buttons + "BUTTON_INPUT_PAGE ";
    }
    if (inputButtons & System.BUTTON_INPUT_POWER) {
      buttons = buttons + "BUTTON_INPUT_POWER ";
    }
    if (inputButtons & System.BUTTON_INPUT_RESET) {
      buttons = buttons + "BUTTON_INPUT_RESET ";
    }
    if (inputButtons & System.BUTTON_INPUT_RIGHT) {
      buttons = buttons + "BUTTON_INPUT_RIGHT ";
    }
    if (inputButtons & System.BUTTON_INPUT_SPORT) {
      buttons = buttons + "BUTTON_INPUT_SPORT ";
    }
    if (inputButtons & System.BUTTON_INPUT_START) {
      buttons = buttons + "BUTTON_INPUT_START ";
    }
    if (inputButtons & System.BUTTON_INPUT_UP_LEFT) {
      buttons = buttons + "BUTTON_INPUT_UP_LEFT ";
    }
    if (inputButtons & System.BUTTON_INPUT_UP_RIGHT) {
      buttons = buttons + "BUTTON_INPUT_UP_RIGHT ";
    }
    if (inputButtons & System.BUTTON_INPUT_ZIN) {
      buttons = buttons + "BUTTON_INPUT_ZIN ";
    }
    if (inputButtons & System.BUTTON_INPUT_ZOUT) {
      buttons = buttons + "BUTTON_INPUT_ZOUT ";
    }

    return buttons;
  }
  /*
  PHONE_OS_NOT_KNOWN	0
  API Level 5.1.0

  PHONE_OS_ANDROID	1
  API Level 5.1.0

  PHONE_OS_IOS	2
  API Level 5.1.0

  */
  public function phoneOperatingSystemToString(
      phoneOperatingSystem as System.PhoneOperatingSystem) {
    var pos = "";

    if (phoneOperatingSystem != null) {
      if (phoneOperatingSystem == System.PHONE_OS_NOT_KNOWN) {
        pos = "PHONE_OS_NOT_KNOWN";
      } else if (phoneOperatingSystem == System.PHONE_OS_ANDROID) {
        pos = "PHONE_OS_ANDROID";
      } else if (phoneOperatingSystem == System.PHONE_OS_IOS) {
        pos = "PHONE_OS_IOS";
      } else {
        pos = "undefined";
      }
    }
    return pos;
  }

  /*
  SCREEN_SHAPE_ROUND	1
  API Level 1.2.0

  SCREEN_SHAPE_SEMI_ROUND	2
  API Level 1.2.0

  SCREEN_SHAPE_RECTANGLE	3
  API Level 1.2.0

  SCREEN_SHAPE_SEMI_OCTAGON	4
  API Level 3.3.0
  */
  public function screenShapeToString(screenShape as System.ScreenShape) {
    var shape = "";

    if (screenShape != null) {
      if (screenShape == System.SCREEN_SHAPE_ROUND) {
        shape = "SCREEN_SHAPE_ROUND";
      } else if (screenShape == System.SCREEN_SHAPE_SEMI_ROUND) {
        shape = "SCREEN_SHAPE_SEMI_ROUND";
      } else if (screenShape == System.SCREEN_SHAPE_RECTANGLE) {
        shape = "SCREEN_SHAPE_RECTANGLE";
      } else if (screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON) {
        shape = "SCREEN_SHAPE_SEMI_OCTAGON";
      } else {
        shape = "undefined";
      }
    }
    return shape;
  }
}