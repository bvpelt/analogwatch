using Toybox.Graphics;
using Toybox.Lang;

class FaceDrawer {
  private var _logger;

  function initialize() { _logger = getLogger(); }

  function drawFace(dc, layout as Lang.Dictionary, profile, useOuterCircle,
                    centerRadius) as Void {
    _logger.trace("FaceDrawer", "Drawing face");

    var centerX = layout["centerX"];
    var centerY = layout["centerY"];
    var r097 = layout["r097"];
    var r090 = layout["r090"];
    //   var r004 = layout["r004"];
    var outerPenWidth = layout["outerPenWidth"];
    var innerPenWidth = layout["innerPenWidth"];

    dc.setColor(profile.facebgcolor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(centerX, centerY, r097);

    if (useOuterCircle) {
      dc.setColor(profile.facebordercolor, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(outerPenWidth);
      dc.drawCircle(centerX, centerY, r097);
    }

    dc.setPenWidth(innerPenWidth);
    dc.drawCircle(centerX, centerY, r090);

    if (profile.handcentercolor != profile.facebgcolor) {
      _logger.debug("FaceDrawer", "drawFace centerRadius: " + centerRadius);
      dc.setColor(profile.handcentercolor, Graphics.COLOR_TRANSPARENT);
      dc.fillCircle(centerX, centerY, centerRadius);
    }
  }

  function drawBattery(dc, centerX, centerY, arcRadius, startAngle,
                       loadPenWidth, profile) as Void {
    var loadPercentage = System.getSystemStats().battery;
    var sweepAngle = (loadPercentage / 100.0) * 360;

    _logger.trace("AnalogWatch",
                  "FraceDrawer drawBattery loadPercentage: " + loadPercentage +
                      " sweepAngle: " + sweepAngle);

    /*
    To prevent overdrawing at sweep angle 360 or 0 only allow empty or full to
    draw
    */
    if (sweepAngle < 359.9) {
      dc.setColor(profile.batteryempty, Graphics.COLOR_TRANSPARENT);
      dc.drawArc(centerX, centerY, arcRadius, Graphics.ARC_CLOCKWISE,
                 startAngle - sweepAngle, startAngle);
    }

    if (sweepAngle > 0.1) {
      dc.setColor(profile.batteryfull, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(loadPenWidth);
      dc.drawArc(centerX, centerY, arcRadius, Graphics.ARC_CLOCKWISE,
                 startAngle, startAngle - sweepAngle);
    }
  }

  function drawHourMarkers(dc, hourMarkerPoints as Lang.Array?,
                           profile) as Void {
    if (hourMarkerPoints == null ||
        profile.hourmarkercolor == profile.facebgcolor) {
      return;
    }

    dc.setColor(profile.hourmarkercolor, Graphics.COLOR_TRANSPARENT);
    for (var i = 0; i < 12; i++) {
      dc.fillPolygon(hourMarkerPoints[i]);
    }
  }

  function drawMinuteTicks(dc, minuteTickPoints as Lang.Array?,
                           minuteTickPenWidth, profile) as Void {
    if (minuteTickPoints == null ||
        profile.minutetickcolor == profile.facebgcolor) {
      return;
    }

    dc.setColor(profile.minutetickcolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(minuteTickPenWidth);

    for (var i = 0; i < minuteTickPoints.size(); i++) {
      var tick = minuteTickPoints[i] as Lang.Array;
      dc.drawLine(tick[0], tick[1], tick[2], tick[3]);
    }
  }

  function drawNumbers(dc, numberX as Lang.Array?, numberY as Lang.Array?,
                       numberText as Lang.Array?, profile) as Void {
    if (numberX == null || numberY == null || numberText == null ||
        profile.numbercolor == profile.facebgcolor) {
      return;
    }

    dc.setColor(profile.numbercolor, Graphics.COLOR_TRANSPARENT);
    var font = Graphics.FONT_XTINY;

    for (var i = 0; i < 12; i++) {
      dc.drawText(numberX[i] as Lang.Number, numberY[i] as Lang.Number, font,
                  numberText[i] as Lang.String,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
  }
}