// source/drawing/Svg03Drawer.mc
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Lang;

class Svg03Drawer extends HandBaseDrawer {
  private var _logger;

  function initialize() {
    HandBaseDrawer.initialize();
    _logger = getLogger();
  }

  function drawHands(dc, clockTime, layout as Lang.Dictionary, profile,
                     updateEverySecond, secondPenWidth) as Void {
    var hour = clockTime.hour % 12;
    var minute = clockTime.min;
    var second = clockTime.sec;

    var centerX = layout["centerX"];
    var centerY = layout["centerY"];
    var radius = layout["radius"];
    var r055 = layout["r055"];
    var r070 = layout["r070"];
    var r035 = layout["r035"];
    var r025 = layout["r025"];

    var hourAngle =
        (hour * Math.PI) / 6.0 + (minute * Math.PI) / 360.0 - Math.PI / 2.0;

    var minuteAngle =
        (minute * Math.PI) / 30.0 + (second * Math.PI) / 1800.0 - Math.PI / 2.0;

    drawHourHand(dc, hourAngle, r055, r035, centerX, centerY, profile);
    drawMinuteHand(dc, minuteAngle, r070, r025, centerX, centerY, profile);

    if (updateEverySecond && profile.secondfgcolor != profile.facebgcolor) {
      drawSecondHand(dc, second, centerX, centerY, radius, secondPenWidth,
                     profile);
    }

    drawCenterCap(dc, centerX, centerY, r025, profile);
  }

  // ── Minute hand ───────────────────────────────────────────────────────────
  // Shape: needle pointing forward
  //
  //   fwd →  0.10  0.25        0.85  1.00
  //   lat       0  ±1.0        ±1.0   0.0
  //
  //   tail●─────────────────────────►tip
  //       └──────────────────────┘
  //         rect body         triangle tip

  private function drawMinuteHand(dc, angle, length, width, centerX, centerY,
                                  profile) as Void {
    var cos = Math.cos(angle).toFloat();
    var sin = Math.sin(angle).toFloat();
    var l = length.toFloat();
    var w = width.toFloat();

    // Outer shell — (fwd, lat) normalized: lat ±1.0 scaled by w
    if (profile.handbgcolor != profile.facebgcolor) {
      var pts = buildPolygon(centerX, centerY, cos, sin, l, w, [
        [0.10f, 0.0f],  // tail center
        [0.25f, -1.0f], // body start left
        [0.85f, -1.0f], // body end left / triangle base left
        [1.00f, 0.0f],  // tip
        [0.85f, 1.0f],  // body end right / triangle base right
        [0.25f, 1.0f]   // body start right
      ]);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    // Inner accent — same shape, narrower (50% width) and slightly inset
    if (profile.handfgcolor != profile.handbgcolor) {
      var iw = w * 0.5f;
      var pts = buildPolygon(centerX, centerY, cos, sin, l, iw, [
        [0.25f, 0.0f], [0.30f, -1.0f], [0.82f, -1.0f], [0.90f, 0.0f],
        [0.82f, 1.0f], [0.30f, 1.0f]
      ]);
      dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }
  }

  // ── Hour hand ─────────────────────────────────────────────────────────────
  // Shape: wider needle with arrowhead and decorative circle
  //
  //   fwd →  0.10  0.25        0.85  0.90
  //   lat       0  ±1.0        ±1.0   0.0
  //
  //   tail●─────────────────────────►tip
  //             ●  ← circle at fwd=0.55

  private function drawHourHand(dc, angle, length, width, centerX, centerY,
                                profile) as Void {
    var cos = Math.cos(angle).toFloat();
    var sin = Math.sin(angle).toFloat();
    var l = length.toFloat();
    var w = width.toFloat();

    // Outer shell
    if (profile.handbgcolor != profile.facebgcolor) {
      var pts = buildPolygon(centerX, centerY, cos, sin, l, w, [
        [0.10f, 0.0f],  // tail center
        [0.25f, -1.0f], // body start left
        [0.75f, -1.0f], // body end left
        [0.90f, 0.0f],  // tip
        [0.75f, 1.0f],  // body end right
        [0.25f, 1.0f]   // body start right
      ]);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    // Inner accent
    if (profile.handfgcolor != profile.handbgcolor) {
      var iw = w * 0.46f;
      var pts = buildPolygon(centerX, centerY, cos, sin, l, iw, [
        [0.25f, 0.0f], [0.30f, -1.0f], [0.55f, -1.0f], [0.65f, 0.0f],
        [0.55f, 1.0f], [0.30f, 1.0f]
      ]);
      dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }

    // Decorative circle on hand body at fwd=0.55
    var circleR = (w * 2.0f).toNumber();
    if (circleR < 2) {
      circleR = 2;
    }
    var bcx = (centerX + cos * l * 0.55f).toNumber();
    var bcy = (centerY + sin * l * 0.55f).toNumber();
    dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(bcx, bcy, circleR);
    dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
    dc.drawCircle(bcx, bcy, circleR);
  }

  // ── Second hand ───────────────────────────────────────────────────────────

  private function drawSecondHand(dc, second, centerX, centerY, radius,
                                  penWidth, profile) as Void {
    var angle = (second * Math.PI) / 30.0 - Math.PI / 2.0;
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);

    // Line: tail 10% behind center, tip 75% forward
    var x1 = (centerX - cos * radius * 0.10f).toNumber();
    var y1 = (centerY - sin * radius * 0.10f).toNumber();
    var x2 = (centerX + cos * radius * 0.75f).toNumber();
    var y2 = (centerY + sin * radius * 0.75f).toNumber();

    dc.setColor(profile.secondfgcolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(penWidth);
    dc.drawLine(x1, y1, x2, y2);

    // Decorative circle at tail end
    var tailR = (radius * 0.06f).toNumber();
    if (tailR < 4) {
      tailR = 4;
    }
    dc.fillCircle(x1, y1, tailR);
  }

  // ── Center cap ────────────────────────────────────────────────────────────

  private function drawCenterCap(dc, centerX, centerY, width, profile) as Void {
    var r = (width * 0.9f).toNumber();
    if (r < 3) {
      r = 3;
    }
    dc.setColor(profile.handcentercolor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(centerX, centerY, r);
    dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
    dc.drawCircle(centerX, centerY, r);
  }

  // ── Core polygon builder ──────────────────────────────────────────────────
  //
  // shape[i] = [forwardRatio, lateralRatio]
  //   forwardRatio : 0.0=center, 1.0=tip, negative=behind center
  //   lateralRatio : -1.0=full left, 0.0=centerline, +1.0=full right
  //   l = hand length in pixels
  //   w = hand half-width in pixels
  //
  // Screen transform:
  //   x = cx + cos*fwd - sin*lat
  //   y = cy + sin*fwd + cos*lat

  private function buildPolygon(
      cx, cy, cos, sin, l, w,
      shape as Lang.Array<Lang.Array<Lang.Float>>) as Lang.Array<Lang.Number> {
    var pts = new[shape.size()];
    for (var i = 0; i < shape.size(); i++) {
      var fwd = (shape[i][0] as Lang.Float) * l;
      var lat = (shape[i][1] as Lang.Float) * w;
      pts[i] = [
        (cx + cos * fwd - sin * lat).toNumber(),
        (cy + sin * fwd + cos * lat).toNumber()
      ];
    }
    return pts;
  }
}