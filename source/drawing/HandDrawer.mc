using Toybox.Graphics;
using Toybox.Math;
using Toybox.Lang;

class HandDrawer {
  // private var _logger;

  function initialize() { /* _logger = getLogger(); */ }

  function drawHands(dc, clockTime, centerX, centerY, radius, r055, r070, r035,
                     r025, profile, updateEverySecond, secondPenWidth) as Void {
    var hour = clockTime.hour % 12;
    var minute = clockTime.min;
    var second = clockTime.sec;

    // Hour hand
    var hourAngle =
        (hour * Math.PI) / 6 + (minute * Math.PI) / 360 - Math.PI / 2;
    drawHand(dc, hourAngle, r055, r035, centerX, centerY, profile);

    // Minute hand
    var minuteAngle =
        (minute * Math.PI) / 30 + (second * Math.PI) / 1800 - Math.PI / 2;
    drawHand(dc, minuteAngle, r070, r025, centerX, centerY, profile);

    // Second hand
    if (updateEverySecond && profile.secondfgcolor != profile.facebgcolor) {
      drawSecondHand(dc, second, centerX, centerY, radius, secondPenWidth,
                     profile);
    }
  }

  private function drawHand(dc, angle, length, width, centerX, centerY,
                            profile) as Void {
    var cosAngle = Math.cos(angle);
    var sinAngle = Math.sin(angle);
    var l = length;
    var w = width;

    if (profile.handbgcolor != profile.facebgcolor) {
      var points = buildHandPolygon(centerX, centerY, cosAngle, sinAngle, l, w);
      dc.setColor(profile.handbgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(points);
    }

    if (profile.handfgcolor != profile.handbgcolor) {
      var innerPoints =
          buildInnerHandPolygon(centerX, centerY, cosAngle, sinAngle, l, w);
      dc.setColor(profile.handfgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(innerPoints);
    }
  }

  private function drawSecondHand(dc, second, centerX, centerY, radius,
                                  penWidth, profile) as Void {
    var secondAngle = (second * Math.PI) / 30 - Math.PI / 2;
    dc.setColor(profile.secondfgcolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(penWidth);

    var cosAngle = Math.cos(secondAngle);
    var sinAngle = Math.sin(secondAngle);

    var x1 = (centerX - cosAngle * radius * 0.1).toNumber();
    var y1 = (centerY - sinAngle * radius * 0.1).toNumber();
    var x2 = (centerX + cosAngle * radius * 0.75).toNumber();
    var y2 = (centerY + sinAngle * radius * 0.75).toNumber();
    dc.drawLine(x1, y1, x2, y2);
  }

  private function buildHandPolygon(centerX, centerY, cosAngle, sinAngle, l,
                                    w) as Lang.Array {
    return [
      [centerX, centerY],
      [centerX - sinAngle * w * 0.5, centerY + cosAngle * w * 0.5],
      [
        centerX + (cosAngle * l) / 15 - sinAngle * w * 0.5,
        centerY + (sinAngle * l) / 15 + cosAngle * w * 0.5
      ],
      [
        centerX + (cosAngle * 2 * l) / 15 - sinAngle * w * 1.5,
        centerY + (sinAngle * 2 * l) / 15 + cosAngle * w * 1.5
      ],
      [
        centerX + (cosAngle * 10 * l) / 15 - sinAngle * w * 1.5,
        centerY + (sinAngle * 10 * l) / 15 + cosAngle * w * 1.5
      ],
      [
        centerX + (cosAngle * 11 * l) / 15 - sinAngle * w * 0.5,
        centerY + (sinAngle * 11 * l) / 15 + cosAngle * w * 0.5
      ],
      [
        centerX + cosAngle * l - sinAngle * w * 0.5,
        centerY + sinAngle * l + cosAngle * w * 0.5
      ],
      [
        centerX + cosAngle * l + sinAngle * w * 0.5,
        centerY + sinAngle * l - cosAngle * w * 0.5
      ],
      [
        centerX + (cosAngle * 11 * l) / 15 + sinAngle * w * 0.5,
        centerY + (sinAngle * 11 * l) / 15 - cosAngle * w * 0.5
      ],
      [
        centerX + (cosAngle * 10 * l) / 15 + sinAngle * w * 1.5,
        centerY + (sinAngle * 10 * l) / 15 - cosAngle * w * 1.5
      ],
      [
        centerX + (cosAngle * 2 * l) / 15 + sinAngle * w * 1.5,
        centerY + (sinAngle * 2 * l) / 15 - cosAngle * w * 1.5
      ],
      [
        centerX + (cosAngle * l) / 15 + sinAngle * w * 0.5,
        centerY + (sinAngle * l) / 15 - cosAngle * w * 0.5
      ],
      [centerX + sinAngle * w * 0.5, centerY - cosAngle * w * 0.5],
      [centerX, centerY]
    ];
  }

  private function buildInnerHandPolygon(centerX, centerY, cosAngle, sinAngle,
                                         l, w) as Lang.Array {
    return [
      [centerX + (cosAngle * 2 * l) / 15, centerY + (sinAngle * 2 * l) / 15],
      [
        centerX + (cosAngle * 2.8 * l) / 15 - sinAngle * w * 0.8,
        centerY + (sinAngle * 2.8 * l) / 15 + cosAngle * w * 0.8
      ],
      [
        centerX + (cosAngle * 9.2 * l) / 15 - sinAngle * w * 0.8,
        centerY + (sinAngle * 9.2 * l) / 15 + cosAngle * w * 0.8
      ],
      [
        centerX + (cosAngle * 10.2 * l) / 15,
        centerY + (sinAngle * 10.2 * l) / 15
      ],
      [
        centerX + (cosAngle * 9.2 * l) / 15 + sinAngle * w * 0.8,
        centerY + (sinAngle * 9.2 * l) / 15 - cosAngle * w * 0.8
      ],
      [
        centerX + (cosAngle * 2.8 * l) / 15 + sinAngle * w * 0.8,
        centerY + (sinAngle * 2.8 * l) / 15 - cosAngle * w * 0.8
      ],
      [centerX + (cosAngle * 2 * l) / 15, centerY + (sinAngle * 2 * l) / 15]
    ];
  }
}