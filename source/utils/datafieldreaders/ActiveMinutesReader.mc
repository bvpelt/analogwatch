using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Lang;

class ActiveMinutesReader extends Reader {

  private const MODERATE = 1;
  private const VIGOROUS = 2;
  private const TOTAL = 3;

  public function initialize() { Reader.initialize(); }

  // Current workout session elapsed time
  private function getSessionTime() as Lang.String or Null {
    var info = Activity.getActivityInfo();
    if (info == null || info.timerTime == null) {
      return null;
    }

    // timerTime is in milliseconds
    var totalSeconds = info.timerTime / 1000;
    var hours = totalSeconds / 3600;
    var minutes = (totalSeconds % 3600) / 60;
    var seconds = totalSeconds % 60;

    if (hours > 0) {
      return hours.format("%d") + ":" + minutes.format("%02d") + ":" +
             seconds.format("%02d"); // 1:23:45
    }
    return minutes.format("%d") + ":" + seconds.format("%02d"); // 23:45
  }

  // Daily active minutes from ActivityMonitor
  private function getDailyActiveMinutes(activityKind) as Lang.String {
    var info = ActivityMonitor.getInfo();
    if (info.activeMinutesDay == null) {
      return "--";
    }
    return formatActivities(info.activeMinutesDay, activityKind);
  }

  private function formatActivities(activity, activityKind) {
    var response = "";
    if (activity != null) {

      if (activityKind == TOTAL) {
        var total = activity.total != null ? activity.total : 0;
        response = total;
      } else if (activityKind == VIGOROUS) {
        var vigorous = activity.vigorous != null ? activity.vigorous : 0;
        response = vigorous;
      } else if (activityKind == MODERATE) {
        var moderate = activity.moderate != null ? activity.moderate : 0;
        response = moderate;
      }
    }
    return response;
  }

  private function getActiveMinutes(activityKind) as Lang.String {
    if (isInActivity()) {
      // Show session elapsed time during workout
      var sessionTime = getSessionTime();
      return sessionTime != null ? sessionTime : "--";
    }
    // Show daily active minutes when not in workout
    return getDailyActiveMinutes(activityKind);
  }

  public function getModerateActiveMinutes() as Lang.String {

    return getActiveMinutes(MODERATE);
  }

  public function getVigorousActiveMinutes() as Lang.String {

    return getActiveMinutes(VIGOROUS);
  }

  public function getTotalActiveMinutes() as Lang.String {

    return getActiveMinutes(TOTAL);
  }
}