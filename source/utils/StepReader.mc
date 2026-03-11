using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Lang;

class StepReader extends Reader {

  public function initialize() { Reader.initialize(); }

  // Steps during an active workout session
  private function getActivitySteps() as Lang.Number or Null {
    // Activity.Info has no steps field — use ActivityMonitor even during
    // workout ActivityMonitor.steps is the device's running daily total
    return getMonitorSteps();
  }

  // Steps from daily activity monitor (always available)
  private function getMonitorSteps() as Lang.Number or Null {
    var monitorInfo = ActivityMonitor.getInfo();
    if (monitorInfo != null && monitorInfo.steps != null) {
      _logger.debug("StepReader", "steps from monitor: " + monitorInfo.steps +
                                      " info: " + monitorInfo.toString());
      return monitorInfo.steps;
    }
    return null;
  }

  public function getSteps() as Lang.Number or Null {
    // Both paths use ActivityMonitor — Activity.Info has no steps field
    return getMonitorSteps();
  }
}