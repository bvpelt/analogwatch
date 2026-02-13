using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.System;

class AnalogApp extends Application
.AppBase {
  private var _analogView;
  private var _logger;
  private var _propertieUtility;
  //  private var _phoneConnection;
  //  private var _lastPhoneConnectionStatus;

  function initialize() {
    AppBase.initialize();
    _logger = getLogger();
    //    _phoneConnection = getPhoneConnection();
    _propertieUtility = getPropertieUtility();
    //    _lastPhoneConnectionStatus = false;
    _logger.debug("AnalogApp", "=== AnalogApp initialize START ===");

    var minimumDebugLevel =
        _propertieUtility.getPropertyNumber("MinimalDebugLevel", 0);

    if (minimumDebugLevel != null) {
      _logger.info("AnalogApp",
                   "=== Retrieved minimum debuglevel from properties: " +
                       minimumDebugLevel);
    } else {
      _logger.info("AnalogApp", "=== No minimum debuglevel property " +
                                    "found, defaulting to 0 (LEVEL_TRACE)");
      minimumDebugLevel = 0;
    }

    _logger.setMinLevel(minimumDebugLevel);
    _logger.info("AnalogApp",
                 "=== Set minimum debuglevel ===" + minimumDebugLevel);

    _logger.debug("AnalogApp", "=== AnalogApp initialize COMPLETE ===");
  }

  // Use manually tracked view
  function onHeartbeat() as Void {
    // Update the current display
    WatchUi.requestUpdate();
  }

  function onSettingsChanged() {
    _logger.info("AnalogApp", "=== Settings changed by user ===");

    // 1. Update the IsCustomProfile logic
    var profile = Application.Properties.getValue("ColorProfile");

    // If profile is 4 (Custom), set the hidden property to true
    Application.Properties.setValue("IsCustomProfile", profile == 4);

    // 2. Tell the active views to refresh their colors/settings
    // Since we use Singletons, we can call them directly
    if (_analogView == null) {
      _analogView = getAnalogView();
    }
    _analogView.updateSettings();

    // 3. Force a UI refresh
    WatchUi.requestUpdate();
  }

  function getInitialView()
      as[WatchUi.Views] or[WatchUi.Views, WatchUi.InputDelegates] {
    _logger.debug("AnalogApp", "=== getInitialView START ===");

    _logger.debug("AnalogApp", "=== Returning AnalogView ===");
    if (_analogView == null) {
      _analogView = getAnalogView();
    }
    return ([_analogView] as[WatchUi.Views]);
  }
}

function getApp() as AnalogApp { return Application.getApp() as AnalogApp; }

// global convenience function
// Rename function to avoid symbol collision with the property 'isSimulator'
function checkIsSimulatorxx() {
  var devSettings = System.getDeviceSettings();
  getLogger().debug("checkIsSimulator",
                    "simulator part number: " + devSettings.partNumber +
                        " expected pattern: 006-BXXXX-XX");

  // 1. Check the official property if the device supports it
  // clang-format off
    if (devSettings has :isSimulator) {
  // clang-format off
        // Explicitly compare to true to avoid type confusion
        if (devSettings.isSimulator == true) {
            getLogger().debug("checkIsSimulator", "isSimulator");
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
        getLogger().debug("checkIsSimulator", "Part number starts with 006-B");
        return true;
    }
    
    getLogger().debug("checkIsSimulator", "Not in simulator");
    return false;
}