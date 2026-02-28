using Toybox.System;
using Toybox.Time;
using Toybox.Lang;

// global convenience function
// Rename function to avoid symbol collision with the property 'isSimulator'
function checkIsSimulator() {
  var devSettings = System.getDeviceSettings();
  System.print("checkIsSimulator simulator part number: " +
               devSettings.partNumber + " expected pattern: 006-BXXXX-XX");

  // 1. Check the official property if the device supports it
  // clang-format off
    if (devSettings has :isSimulator) {
  // clang-format off
        // Explicitly compare to true to avoid type confusion
        if (devSettings.isSimulator == true) {
            System.print("checkIsSimulator isSimulator");
            return true;
        }
    }
    
    // 2. Fallback check using the Simulator Part Number
    // (006-B0000-00 is the standard simulator part number)
    var partNumber = devSettings.partNumber;

    if (partNumber != null && 
        partNumber.length() >= 5 && 
        partNumber.substring(0, 5).equals("006-B")) {
        // Part number starts with "006-B"
        System.print("checkIsSimulator Part number starts with 006-B");
        return true;
    }
    
    System.print("checkIsSimulator Not in simulator");
    return false;
}

function formatISO(moment as Time.Moment) as Lang.String {
    var info = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
    
    return Lang.format("$1$-$2$-$3$ $4$:$5$:$6$", [
        info.year,
        info.month.format("%02d"),
        info.day.format("%02d"),
        info.hour.format("%02d"),
        info.min.format("%02d"),
        info.sec.format("%02d")
    ]);
}