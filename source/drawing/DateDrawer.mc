using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Lang;

class DateDrawer {
  function drawDateInfo(dc, centerY, dateBoxMaxlen, dateBoxY, dateBoxHeight,
                        dateBoxSpacing, dateBoxOutlinePenWidth,
                        profile) as Void {
    var now = Gregorian.info(Time.now(), Time.FORMAT_LONG);
    var weekday = Lang.format("$1$", [now.day_of_week]);
    var dayNum = now.day;
    var dayString = dayNum < 10 ? "0" + dayNum.toString() : dayNum.toString();

    var font = Graphics.FONT_XTINY;
    var boxNumberWidth = 1.1 * dc.getTextWidthInPixels(dayString, font);
    var boxWeekdayWidth = 1.1 * dc.getTextWidthInPixels(weekday, font);

    var boxDNumberX = dateBoxMaxlen - boxNumberWidth;
    var boxWDNameX =
        dateBoxMaxlen - boxWeekdayWidth - boxNumberWidth - dateBoxSpacing;

    // Draw backgrounds
    if (profile.daybgcolor != profile.facebgcolor) {
      dc.setColor(profile.daybgcolor, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(boxWDNameX, dateBoxY, boxWeekdayWidth, dateBoxHeight);
      dc.fillRectangle(boxDNumberX, dateBoxY, boxNumberWidth, dateBoxHeight);
    }

    // Draw outlines
    if (profile.dayoutlinecolor != profile.facebgcolor) {
      dc.setColor(profile.dayoutlinecolor, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(dateBoxOutlinePenWidth);
      dc.drawRectangle(boxWDNameX, dateBoxY, boxWeekdayWidth, dateBoxHeight);
      dc.drawRectangle(boxDNumberX, dateBoxY, boxNumberWidth, dateBoxHeight);
    }

    // Draw text
    if (profile.daynamecolor != profile.facebgcolor) {
      dc.setColor(profile.daynamecolor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(boxWDNameX + boxWeekdayWidth / 2, centerY, font, weekday,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    if (profile.daynumbercolor != profile.facebgcolor) {
      dc.setColor(profile.daynumbercolor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(boxDNumberX + boxNumberWidth / 2, centerY, font, dayString,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
  }
}