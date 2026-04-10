// source/drawing/SvgHandDrawer.mc
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Lang;

class Svg01Drawer extends HandBaseDrawer {

  function initialize() { HandBaseDrawer.initialize(); }

  // ─── Minute hand ─────────────────────────────────────────────────────────
  //
  // SVG source (center 100,200, points UP, total forward length 200):
  //   Outer: (100,185) (95,180) (95,5) (100,0) (105,5) (105,180)
  //   Inner: (100,177.5) (97.5,175) (97.5,10) (100,7.5) (102.5,10) (102.5,175)
  //
  // Normalized: forward = (200-y)/200,  lateral = (x-100)/5
  //   Outer forward ratios:  0.075, 0.10, 0.975, 1.0, 0.975, 0.10
  //   Outer lateral ratios:  0,    -1.0, -1.0,   0,   1.0,   1.0
  //   Inner forward ratios:  0.1125, 0.125, 0.95, 0.9625, 0.95, 0.125
  //   Inner lateral ratios:  0,     -1.0,  -1.0,  0,      1.0,  1.0

  protected function drawMinuteHand(dc, angle, length, width, centerX, centerY,
                                    profile) as Void {
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);

    // Outer shell — uses handbgcolor
    if (profile.handbgcolor != profile.facebgcolor) {
      // outerHalfWidth = width * (5/5) = width * 1.0
      var outerW = width.toFloat();
      var pts = buildMinuteOuterPolygon(centerX, centerY, cos, sin,
                                        length.toFloat(), outerW);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    // Inner accent — uses handfgcolor
    if (profile.handfgcolor != profile.handbgcolor) {
      // innerHalfWidth = width * (2.5/5) = width * 0.5
      var innerW = width.toFloat() * 0.5;
      var pts = buildMinuteInnerPolygon(centerX, centerY, cos, sin,
                                        length.toFloat(), innerW);
      dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }
  }

  private function buildMinuteOuterPolygon(cx, cy, cos, sin, l,
                                           w) as Lang.Array<Lang.Number> {
    return buildPolygon(cx, cy, cos, sin, l, w, [
      [0.075, 0.0], [0.10, -1.0], [0.975, -1.0], [1.0, 0.0], [0.975, 1.0],
      [0.10, 1.0]
    ]);
  }

  private function buildMinuteInnerPolygon(cx, cy, cos, sin, l,
                                           w) as Lang.Array<Lang.Number> {
    return buildPolygon(cx, cy, cos, sin, l, w, [
      [0.1125, 0.0], [0.125, -1.0], [0.95, -1.0], [0.9625, 0.0], [0.95, 1.0],
      [0.125, 1.0]
    ]);
  }

  // ─── Hour hand ───────────────────────────────────────────────────────────
  //
  // SVG source (center 100,200, points RIGHT, total forward length 160):
  //   Outer: (115,200) (120,192.5) (255,192.5) (260,200) (255,207.5)
  //   (120,207.5) Inner: (120,200) (125,195) (250,195) (255,200) (250,205)
  //   (125,205)
  //
  // Normalized: forward = (x-100)/160,  lateral = (200-y)/7.5
  //   Outer fwd:  0.09375  0.125  0.96875  1.0  0.96875  0.125
  //   Outer lat:  0.0      1.0    1.0      0.0 -1.0     -1.0
  //   Inner fwd:  0.125    0.15625 0.9375  0.96875 0.9375 0.15625
  //   Inner lat:  0.0      1.0     1.0     0.0    -1.0   -1.0

  protected function drawHourHand(dc, angle, length, width, centerX, centerY,
                                  profile) as Void {
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);

    if (profile.handbgcolor != profile.facebgcolor) {
      // outerHalfWidth = width * (7.5/7.5) = width * 1.0
      var outerW = width.toFloat();
      var pts = buildHourOuterPolygon(centerX, centerY, cos, sin,
                                      length.toFloat(), outerW);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    if (profile.handfgcolor != profile.handbgcolor) {
      // innerHalfWidth = width * (5.0/7.5) = width * 0.667
      var innerW = width.toFloat() * 0.667;
      var pts = buildHourInnerPolygon(centerX, centerY, cos, sin,
                                      length.toFloat(), innerW);
      dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }
  }

  private function buildHourOuterPolygon(cx, cy, cos, sin, l,
                                         w) as Lang.Array<Lang.Number> {
    return buildPolygon(cx, cy, cos, sin, l, w, [
      [0.09375, 0.0], [0.125, 1.0], [0.96875, 1.0], [1.0, 0.0], [0.96875, -1.0],
      [0.125, -1.0]
    ]);
  }

  private function buildHourInnerPolygon(cx, cy, cos, sin, l,
                                         w) as Lang.Array<Lang.Number> {
    return buildPolygon(cx, cy, cos, sin, l, w, [
      [0.125, 0.0], [0.15625, 1.0], [0.9375, 1.0], [0.96875, 0.0],
      [0.9375, -1.0], [0.15625, -1.0]
    ]);
  }

  // ─── Second hand ─────────────────────────────────────────────────────────
  //
  // SVG: line from (100, 215) to (100, 390)
  // Center at (100, 200), points DOWN (opposite of minute)
  // Tail: 15/190 = 0.0789 of total forward length behind center
  // Total forward = 190 units

  protected function drawSecondHand(dc, second, centerX, centerY, radius,
                                    penWidth, profile) as Void {
    var secondAngle = (second * Math.PI) / 30 - Math.PI / 2;
    dc.setColor(profile.secondfgcolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(penWidth);

    var cos = Math.cos(secondAngle);
    var sin = Math.sin(secondAngle);

    // Tail: 15/190 = ~0.0789 behind center
    // Tip:  190/190 = 1.0 (scaled to 75% of radius to match original scaling
    // strategy)
    var tailRatio = 0.0789;
    var tipRatio = 0.75;

    var x1 = (centerX - cos * radius * tailRatio).toNumber();
    var y1 = (centerY - sin * radius * tailRatio).toNumber();
    var x2 = (centerX + cos * radius * tipRatio).toNumber();
    var y2 = (centerY + sin * radius * tipRatio).toNumber();

    dc.drawLine(x1, y1, x2, y2);
  }
}