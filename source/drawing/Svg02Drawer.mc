// source/drawing/Svg02Drawer.mc
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Lang;

// Implements watch hands derived from wp-15.svg
// Minute hand: pentagon arrow (triangle tip + rectangular body)
// Hour  hand:  rectangle with arrowhead tip + decorative circle
// Second hand: thin line with tail circle
class Svg02Drawer extends HandBaseDrawer {

  function initialize() { HandBaseDrawer.initialize(); }

  // ── Minute hand ───────────────────────────────────────────────────────────
  //
  // Shape from SVG "Small" layer — pentagon (arrow pointing forward):
  //
  //        tip (1.0, 0.0)
  //       /              \
    //  (0.929, -1.0)  (0.929, +1.0)   ← triangle base = body top
  //      |                |
  //  (0.129, -1.0)  (0.129, +1.0)   ← body base
  //
  // Inner accent is same shape, scaled to 50% half-width, slightly shorter

  protected function drawMinuteHand(dc, angle, length, width, centerX, centerY,
                                    profile) as Void {
    var cos = Math.cos(angle).toFloat();
    var sin = Math.sin(angle).toFloat();
    var l = length.toFloat();
    var w = width.toFloat();

    // Outer shell
    if (profile.handbgcolor != profile.facebgcolor) {
      var pts = buildPolygon(centerX, centerY, cos, sin, l, w, [
        [0.129f, -1.0f], // body base left
        [0.929f, -1.0f], // body top left / triangle base left
        [1.000f, 0.0f],  // tip
        [0.929f, 1.0f],  // body top right / triangle base right
        [0.129f, 1.0f]   // body base right
      ]);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    // Inner accent
    if (profile.handfgcolor != profile.handbgcolor) {
      var iw = w * 0.5f;
      var pts = buildPolygon(centerX, centerY, cos, sin, l, iw, [
        [0.158f, -1.0f], [0.894f, -1.0f], [0.958f, 0.0f], [0.894f, 1.0f],
        [0.158f, 1.0f]
      ]);
      dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }
  }

  // ── Hour hand ─────────────────────────────────────────────────────────────
  //
  // Shape from SVG "Big" layer — rectangle with arrowhead + circle accent:
  //
  //  (-0.083,-1.0)─────────(0.962,-1.0)
  //       |                      \
    //       |                    (1.0, 0.0) ← arrowhead tip
  //       |                      /
  //  (-0.083,+1.0)─────────(0.962,+1.0)
  //
  //  Inner accent: same shape from (0.096) to arrowhead at (0.979)
  //  Circle accent: at forward ratio 0.884, radius = 3.82 × half-width

  protected function drawHourHand(dc, angle, length, width, centerX, centerY,
                                  profile) as Void {
    var cos = Math.cos(angle).toFloat();
    var sin = Math.sin(angle).toFloat();
    var l = length.toFloat();
    var w = width.toFloat();

    // Outer shell
    if (profile.handbgcolor != profile.facebgcolor) {
      var pts = buildPolygon(centerX, centerY, cos, sin, l, w, [
        [-0.083f, 1.0f], // tail top
        [0.962f, 1.0f],  // arrow base top
        [1.000f, 0.0f],  // arrow tip
        [0.962f, -1.0f], // arrow base bottom
        [-0.083f, -1.0f] // tail bottom
      ]);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    // Inner accent (narrower, shorter tail)
    if (profile.handfgcolor != profile.handbgcolor) {
      var iw = w * 0.46f;
      var pts = buildPolygon(centerX, centerY, cos, sin, l, iw, [
        [0.096f, 1.0f], [0.943f, 1.0f], [0.979f, 0.0f], [0.943f, -1.0f],
        [0.096f, -1.0f]
      ]);
      dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    // Decorative filled circle on hand body
    // From SVG: bol_inside at forward=0.884, radius ≈ 3.82 × half-width
    // var circleR = (w * 3.82f).toNumber();
    var circleR = (w * 1).toNumber();
    if (circleR < 2) {
      circleR = 2;
    }
    // var cx = (centerX + cos * l * 0.884f).toNumber();
    // var cy = (centerY + sin * l * 0.884f).toNumber();

    var cx = (centerX + cos * l * 0.6f).toNumber();
    var cy = (centerY + sin * l * 0.6f).toNumber();

    dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(cx, cy, circleR);
    dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
    dc.drawCircle(cx, cy, circleR);
  }

  // ── Second hand ───────────────────────────────────────────────────────────
  //
  // From SVG "Second" layer:
  // Thin line, tail starts 0.083 × radius behind center,
  // tip extends 0.75 × radius forward.
  // Decorative circle at tail end.

  protected function drawSecondHand(dc, second, centerX, centerY, radius,
                                    penWidth, profile) as Void {
    var angle = (second * Math.PI) / 30.0 - Math.PI / 2.0;
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);

    var tailRatio = 0.083f;
    var tipRatio = 0.75f;

    var x1 = (centerX - cos * radius * tailRatio).toNumber();
    var y1 = (centerY - sin * radius * tailRatio).toNumber();
    var x2 = (centerX + cos * radius * tipRatio).toNumber();
    var y2 = (centerY + sin * radius * tipRatio).toNumber();

    dc.setColor(profile.secondfgcolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(penWidth);
    dc.drawLine(x1, y1, x2, y2);

    // Tail decorative circle (from Center layer second circle)
    var tailR = (radius * 0.038f).toNumber();
    // if (tailR < 2) {
    //   tailR = 2;
    // }

    if (tailR < 10) {
      tailR = 10;
    }

    x1 = (centerX + cos * radius * 0.6f).toNumber();
    y1 = (centerY + sin * radius * 0.6f).toNumber();
    dc.fillCircle(x1, y1, tailR);
  }

  // ── Center cap ────────────────────────────────────────────────────────────
  // Drawn last so it always appears on top of all hands.
  // From SVG "Center" layer: green-outlined circle at pivot point.
  /*
    private function drawCenterCap(dc, centerX, centerY, width, profile) as Void
    { var r = (width * 0.9f).toNumber(); if (r < 2) { r = 2;
      }
      dc.setColor(profile.handcentercolor, Graphics.COLOR_TRANSPARENT);
      dc.fillCircle(centerX, centerY, r);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.drawCircle(centerX, centerY, r);
    }
  */
}