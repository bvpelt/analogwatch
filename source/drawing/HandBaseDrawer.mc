using Toybox.Lang;

class HandBaseDrawer {
  // private var _logger;

  function initialize() { /* _logger = getLogger(); */ }

  public function drawHands(dc, clockTime, layout as Lang.Dictionary, profile,
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

    // Hour hand
    var hourAngle =
        (hour * Math.PI) / 6 + (minute * Math.PI) / 360 - Math.PI / 2;
    drawHourHand(dc, hourAngle, r055, r035, centerX, centerY, profile);

    // Minute hand
    var minuteAngle =
        (minute * Math.PI) / 30 + (second * Math.PI) / 1800 - Math.PI / 2;
    drawMinuteHand(dc, minuteAngle, r070, r025, centerX, centerY, profile);

    // Second hand
    if (updateEverySecond && profile.secondfgcolor != profile.facebgcolor) {
      drawSecondHand(dc, second, centerX, centerY, radius, secondPenWidth,
                     profile);
    }
  }

  protected function drawHourHand(dc, hourAngle, r055, r035, centerX, centerY,
                                  profile) {
    // Throw an exception to simulate an abstract method constraint
    throw new Lang.OperationNotAllowedException(
        "Method draw() must be overridden");
  }

  protected function drawMinuteHand(dc, minuteAngle, r070, r025, centerX,
                                    centerY, profile) {
    // Throw an exception to simulate an abstract method constraint
    throw new Lang.OperationNotAllowedException(
        "Method draw() must be overridden");
  }

  protected function drawSecondHand(dc, second, centerX, centerY, radius,
                                    secondPenWidth, profile) {
    // Throw an exception to simulate an abstract method constraint
    throw new Lang.OperationNotAllowedException(
        "Method draw() must be overridden");
  }

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

  protected function buildPolygon(
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