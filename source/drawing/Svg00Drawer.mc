// source/drawing/HandDrawer.mc
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Lang;

class Svg00Drawer extends HandBaseDrawer {

  function initialize() { HandBaseDrawer.initialize(); }

  protected function drawHourHand(dc, hourAngle, r055, r035, centerX, centerY,
                                  profile) {
    drawHand(dc, hourAngle, r055, r035, centerX, centerY, profile);
  }

  protected function drawMinuteHand(dc, minuteAngle, r070, r025, centerX,
                                    centerY, profile) {
    drawHand(dc, minuteAngle, r070, r025, centerX, centerY, profile);
  }

  private function drawHand(dc, angle, length, width, centerX, centerY,
                            profile) as Void {
    var cos = Math.cos(angle).toFloat();
    var sin = Math.sin(angle).toFloat();
    var l = length.toFloat();
    var w = width.toFloat();

    // Outer hand — derived from original buildHandPolygon
    // lat values are multiples of w (e.g. 1.5 = 1.5 × half-width)
    if (profile.handbgcolor != profile.facebgcolor) {
      var pts = buildPolygon(centerX, centerY, cos, sin, l, w, [
        [0.000f, 0.0f],  // base center
        [0.000f, 0.5f],  // base left
        [0.067f, 0.5f],  // shoulder left narrow
        [0.133f, 1.5f],  // shoulder left wide
        [0.667f, 1.5f],  // hip left wide
        [0.733f, 0.5f],  // hip left narrow
        [1.000f, 0.5f],  // tip left
        [1.000f, -0.5f], // tip right
        [0.733f, -0.5f], // hip right narrow
        [0.667f, -1.5f], // hip right wide
        [0.133f, -1.5f], // shoulder right wide
        [0.067f, -0.5f], // shoulder right narrow
        [0.000f, -0.5f], // base right
        [0.000f, 0.0f]   // back to base center
      ]);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    // Inner accent — derived from original buildInnerHandPolygon
    if (profile.handfgcolor != profile.handbgcolor) {
      var pts = buildPolygon(centerX, centerY, cos, sin, l, w, [
        [0.133f, 0.0f],  // inner base center
        [0.187f, 0.8f],  // inner shoulder left
        [0.613f, 0.8f],  // inner hip left
        [0.680f, 0.0f],  // inner tip center
        [0.613f, -0.8f], // inner hip right
        [0.187f, -0.8f], // inner shoulder right
        [0.133f, 0.0f]   // back to inner base center
      ]);
      dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }
  }

  protected function drawSecondHand(dc, second, centerX, centerY, radius,
                                    penWidth, profile) as Void {
    var secondAngle = (second * Math.PI) / 30 - Math.PI / 2;
    var cos = Math.cos(secondAngle);
    var sin = Math.sin(secondAngle);

    dc.setColor(profile.secondfgcolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(penWidth);

    var x1 = (centerX - cos * radius * 0.1).toNumber();
    var y1 = (centerY - sin * radius * 0.1).toNumber();
    var x2 = (centerX + cos * radius * 0.75).toNumber();
    var y2 = (centerY + sin * radius * 0.75).toNumber();
    dc.drawLine(x1, y1, x2, y2);
  }
}