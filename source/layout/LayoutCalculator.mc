using Toybox.Math;
using Toybox.Lang;

class LayoutCalculator {
  //  private var _logger;

  function initialize() {
    //_logger = getLogger();
  }

  function calculateLayout(dc, useOuterCircle) as Lang.Dictionary {
    var centerX = dc.getWidth() / 2;
    var centerY = dc.getHeight() / 2;
    var minDimension = centerX < centerY ? centerX : centerY;
    var radius = minDimension;

    var layout = { "centerX" => centerX,
                   "centerY" => centerY,
                   "radius" => radius,
                   "outerPenWidth" => calculatePenWidth(radius * 0.06),
                   "innerPenWidth" => calculatePenWidth(radius * 0.01),
                   "loadPenWidth" => calculatePenWidth(radius * 0.05),
                   "dateBoxOutlinePenWidth" =>
                       calculatePenWidth(radius * 0.008) };

    // Calculate radii based on outer circle setting
    if (useOuterCircle) {
      layout["r097"] = (radius * 0.97).toNumber();
      layout["r090"] = (radius * 0.90).toNumber();
      layout["r088"] = (radius * 0.88).toNumber();
      layout["r070"] = (radius * 0.70).toNumber();
      layout["arcRadius"] = (radius * 0.92).toNumber();
      layout["bluetoothy"] = (centerY - radius * 0.50).toNumber();
    } else {
      layout["r097"] = (radius * 0.97).toNumber();
      layout["r090"] = (radius * 0.97).toNumber();
      layout["r088"] = (radius * 0.95).toNumber();
      layout["r070"] = (radius * 0.77).toNumber();
      layout["arcRadius"] = (radius * 0.99).toNumber();
      layout["bluetoothy"] = (centerY - radius * 0.57).toNumber();
    }

    layout["r055"] = (radius * 0.55).toNumber();
    layout["r035"] = (radius * 0.035).toNumber();
    layout["r025"] = (radius * 0.025).toNumber();
    layout["r004"] = (radius * 0.04).toNumber();
    layout["tickLength"] = (radius * 0.04).toNumber();
    layout["triangleHeight"] = (radius * 0.07).toNumber();
    layout["triangleBase"] = (radius * 0.04).toNumber();

    // Date box
    layout["dateBoxHeight"] = (radius * 0.19).toNumber();
    layout["dateBoxSpacing"] = (radius * 0.03).toNumber();
    layout["dateBoxMaxlen"] = (centerX + radius * 0.60).toNumber();
    layout["dateBoxY"] = centerY - layout["dateBoxHeight"] / 2;

    // Data fields
    layout["dataFieldNorthX"] = centerX;
    layout["dataFieldNorthY"] = layout["bluetoothy"];
    layout["dataFieldSouthX"] = centerX;
    layout["dataFieldSouthY"] = (centerY + radius * 0.55).toNumber();
    layout["dataFieldWestX"] = (centerX - radius * 0.45).toNumber();
    layout["dataFieldWestY"] = centerY;

    layout["bluetoothx"] = centerX;

    // Pre-calculate marker positions
    layout["hourMarkerPoints"] = calculateHourMarkers(centerX, centerY, layout);
    layout["minuteTickPoints"] = calculateMinuteTicks(centerX, centerY, layout);
    var numberData = calculateNumbers(centerX, centerY, layout["r070"]);
    layout["numberX"] = numberData[0];
    layout["numberY"] = numberData[1];
    layout["numberText"] = numberData[2];

    return layout;
  }

  private function calculatePenWidth(width) as Lang.Number {
    var w = width.toNumber();
    return w < 1 ? 1 : w;
  }

  private function
  calculateHourMarkers(centerX, centerY,
                       layout as Lang.Dictionary) as Lang.Array {
    var markers = new[12];
    var r088 = layout["r088"];
    var triangleHeight = layout["triangleHeight"];
    var triangleBase = layout["triangleBase"];

    for (var i = 0; i < 12; i++) {
      var angle = (i * Math.PI) / 6;
      var cosAngle = Math.cos(angle);
      var sinAngle = Math.sin(angle);
      var perpAngle = angle + Math.PI / 2;
      var cosPerAngle = Math.cos(perpAngle);
      var sinPerAngle = Math.sin(perpAngle);

      var xOuter = (centerX + cosAngle * r088).toNumber();
      var yOuter = (centerY + sinAngle * r088).toNumber();

      var xBase1 = (xOuter + cosPerAngle * (triangleBase / 2)).toNumber();
      var yBase1 = (yOuter + sinPerAngle * (triangleBase / 2)).toNumber();
      var xBase2 = (xOuter - cosPerAngle * (triangleBase / 2)).toNumber();
      var yBase2 = (yOuter - sinPerAngle * (triangleBase / 2)).toNumber();

      var xTip = (centerX + cosAngle * (r088 - triangleHeight)).toNumber();
      var yTip = (centerY + sinAngle * (r088 - triangleHeight)).toNumber();

      markers[i] = [[xBase1, yBase1], [xBase2, yBase2], [xTip, yTip]];
    }

    return markers;
  }

  private function
  calculateMinuteTicks(centerX, centerY,
                       layout as Lang.Dictionary) as Lang.Array {
    var ticks = [];
    var r088 = layout["r088"];
    var tickLength = layout["tickLength"];

    for (var i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        var angle = (i * Math.PI) / 30;
        var cosAngle = Math.cos(angle);
        var sinAngle = Math.sin(angle);

        var xStart = (centerX + cosAngle * r088).toNumber();
        var yStart = (centerY + sinAngle * r088).toNumber();
        var xEnd = (centerX + cosAngle * (r088 - tickLength)).toNumber();
        var yEnd = (centerY + sinAngle * (r088 - tickLength)).toNumber();

        ticks.add([xStart, yStart, xEnd, yEnd]);
      }
    }

    return ticks;
  }

  private function calculateNumbers(centerX, centerY, r070) as Lang.Array {
    var numberX = new[12];
    var numberY = new[12];
    var numberText = new[12];
    var numbers = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

    for (var i = 0; i < 12; i++) {
      var angle = (i * Math.PI) / 6 - Math.PI / 2;
      numberX[i] = (centerX + Math.cos(angle) * r070).toNumber();
      numberY[i] = (centerY + Math.sin(angle) * r070).toNumber();
      numberText[i] = numbers[i].toString();
    }

    return [numberX, numberY, numberText];
  }
}