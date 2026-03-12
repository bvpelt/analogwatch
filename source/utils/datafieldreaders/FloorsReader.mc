using Toybox.ActivityMonitor;
using Toybox.Lang;

class FloorsReader extends Reader {

  public function initialize() { Reader.initialize(); }

  public function getFloorsClimbed() as Lang.Number or Null {
    // ActivityMonitor is the only source — no activity distinction needed
    return ActivityMonitor.getInfo().floorsClimbed;
  }
}