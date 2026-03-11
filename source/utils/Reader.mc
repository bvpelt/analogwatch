using Toybox.Lang;
using Toybox.Activity;

class Reader {
  // Activity timer states
  // private const TIMER_STATE_OFF = 0;
  private const TIMER_STATE_ON = 1;
  private const TIMER_STATE_PAUSED = 2;

  protected var _logger;

  public function initialize() { _logger = getLogger(); }

  function isInActivity() as Lang.Boolean {
    var _activityInfo = Activity.getActivityInfo();

    if (_activityInfo == null) {
      return false;
    }

    // timerState is the most reliable indicator
    // ON or PAUSED both mean an activity has been started
    var state = _activityInfo.timerState;
    _logger.debug("Reader",
                  "activityInfo: " + _activityInfo + " + state result: " +
                      (state == TIMER_STATE_ON || state == TIMER_STATE_PAUSED));
    return (state == TIMER_STATE_ON || state == TIMER_STATE_PAUSED);
  }
}