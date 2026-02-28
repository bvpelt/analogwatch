using Toybox.ActivityMonitor;
using Toybox.Lang;

class ActivityUtility {
  private static var _instance as ActivityUtility?;
  private var _logger;
  private var _lastHartSampleTime;

  // Private constructor
  private function initialize() {
    // Don't store _info here - fetch it fresh each time
    _logger = getLogger();
    _lastHartSampleTime = null;
  }

  // Get singleton instance
  static function getInstance() as ActivityUtility {
    if (_instance == null) {
      _instance = new ActivityUtility();
    }
    return _instance;
  }

  private function formatActivities(activity) {
    var response = "";
    if (activity != null) {
      // Always convert to strings or use 0 for null values
      //      var moderate = activity.moderate != null ? activity.moderate : 0;
      var total = activity.total != null ? activity.total : 0;
      //      var vigorous = activity.vigorous != null ? activity.vigorous : 0;
      /*
            response = Lang.format("moderate: $1$ total: $2$ vigorous: $3$",
                                   [moderate, total, vigorous]);
      */
      response = total;
    }
    return response;
  }

  /*
    activeMinutesDay as ActivityMonitor.ActiveMinutes or Null
    The number of active minutes for the current day.
  */
  function getActiveMinutesDay() as Lang.String {
    var info = ActivityMonitor.getInfo();
    return formatActivities(info.activeMinutesDay);
  }

  /*
   activeMinutesWeek as ActivityMonitor.ActiveMinutes or Null
   The number of active minutes for the current week.
  */
  function getActiveMinutesWeek() as ActivityMonitor.ActiveMinutes or Null {
    var info = ActivityMonitor.getInfo();
    return formatActivities(info.activeMinutesWeek);
  }

  /*
  calories as Lang.Number or Null
  The calories burned so far for the current day in kilocalories (kCal).
  */
  function getCalories() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.calories;
  }

  /*
  distance as Lang.Number or Null
  The distance traveled for the current day in centimeters (cm).
  */
  function getDistance() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.distance;
  }

  /*
  floorsClimbed as Lang.Number or Null
  The floors climbed for the current day.
  */
  function getFloorsClimbed() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.floorsClimbed;
  }

  /*
  floorsClimbedGoal as Lang.Number or Null
  The floors climbed goal for the current day.
  */
  function getFloorsClimbedGoal() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.floorsClimbedGoal;
  }

  /*
  floorsDescended as Lang.Number or Null
  The floors descended for the current day.
  */
  function getFloorsDescended() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.floorsDescended;
  }

  /*
  metersClimbed as Lang.Number or Null
  The meters climbed for the current day.
  */
  function getMetersClimbed() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.metersClimbed;
  }

  /*
  metersDescended as Lang.Number or Null
  The meters descended for the current day.
  */
  function getMetersDescended() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.metersDescended;
  }

  /*
  respirationRate as Lang.Number or Null
  The respiration rate for the current day.
  */
  function getRespirationRate() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.respirationRate;
  }

  /*
  steps as Lang.Number or Null
  The number of steps taken for the current day.
  */
  function getSteps() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.steps;
  }

  /*
  stepGoal as Lang.Number or Null
  The user's step goal for the current day.
  */
  function getStepGoal() as Lang.Number or Null {
    var info = ActivityMonitor.getInfo();
    return info.stepGoal;
  }

  function getHeartRate() {
    // get a HeartRateIterator object; oldest sample first
    var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
    var previous = hrIterator.next(); // get the previous HR
                                      // get the last
    var lastHartRate = null;

    while (true) {
      var sample = hrIterator.next();
      if (null != sample) { // null check
        if (sample.heartRate !=
                ActivityMonitor.INVALID_HR_SAMPLE // check for invalid samples
            && previous.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
          _lastHartSampleTime = sample.when;
          lastHartRate = sample.heartRate;
          _logger.trace("ActivityUtility", "lastHartSampleTime: " +
                                               formatISO(_lastHartSampleTime) +
                                               " hartrate: " + lastHartRate);
        }
      }
      break;
    }

    return lastHartRate;
  }
}

function getActivityUtility() as ActivityUtility {
  return ActivityUtility.getInstance();
}