using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class AnalogView extends WatchUi
.WatchFace {
  private static var _instance as AnalogView ? ;
  private var _logger;
  private var _propertieUtility;

  // Utilities
  private var _faceDrawer;
  private var _handDrawer;
  private var _dateDrawer;
  private var _dataFieldDrawer;
  private var _layoutCalculator;

  // Current state
  private var _currentProfile as ColorProfile;
  private var _layout as Lang.Dictionary = {};
  private var _layoutCalculated as Lang.Boolean = false;

  // Settings
  private var _updateEverySecond = true;
  private var _useOuterCircle = true;
  private var _dataFieldNorth = 0;
  private var _dataFieldSouth = 1;
  private var _dataFieldWest = 2;

  // Resources
  private var _iconFont;
  private var _analogFont;
  private var _backgroundBuffer as Graphics.BufferedBitmap ? ;

  // Constants
  private const SECOND_PEN_WIDTH = 3;
  private const MINUTE_TICK_PEN_WIDTH = 2;
  private const START_ANGLE = 90;

  private function initialize() {
    WatchFace.initialize();
    _logger = getLogger();
    _propertieUtility = getPropertieUtility();

    // Initialize drawers
    _faceDrawer = new FaceDrawer();
    _handDrawer = new HandDrawer();
    _dateDrawer = new DateDrawer();
    _dataFieldDrawer = new DataFieldDrawer();
    _layoutCalculator = new LayoutCalculator();

    // Default profile
    _currentProfile = new ClassicProfile();

    _logger.debug("AnalogView", "Initializing AnalogView");
    logDeviceInfo();
    updateSettings();
  }

  static function getInstance() as AnalogView {
    if (_instance == null) {
      _instance = new AnalogView();
    }
    return _instance;
  }

  function onUpdateHeartbeat() { WatchUi.requestUpdate(); }

  function onShow() as Void {
    _logger.debug("AnalogView", "=== AnalogView onShow ===");
  }

  function onHide() { _logger.debug("AnalogView", "=== AnalogView onHide"); }

  public function updateSettings() {
    _logger.debug("AnalogView", "==== updateSettings ====");

    // Read settings
    var profileId = _propertieUtility.getPropertyNumber("ColorProfile", 0);
    _updateEverySecond =
        _propertieUtility.getPropertyBoolean("UpdateSeconds", true);
    _useOuterCircle =
        _propertieUtility.getPropertyBoolean("UseOuterCircle", true);
    _dataFieldNorth = _propertieUtility.getPropertyNumber("DataFieldNorth", 0);
    _dataFieldSouth = _propertieUtility.getPropertyNumber("DataFieldSouth", 1);
    _dataFieldWest = _propertieUtility.getPropertyNumber("DataFieldWest", 2);

    // Load profile
    _currentProfile = ProfileFactory.createProfile(profileId);
    _logger.debug("AnalogView", "Loaded profile: " + _currentProfile.getName());

    // Save profile colors for custom profile use
    saveProfileToProperties();

    _layoutCalculated = false;
    WatchUi.requestUpdate();
  }

  private function saveProfileToProperties() as Void {
    var colorDict = _currentProfile.toDictionary();
    var keys = colorDict.keys();

    for (var i = 0; i < keys.size(); i++) {
      var key = keys[i] as Lang.String;
      var value = colorDict[key] as Lang.Number;
      _propertieUtility.setProperty(key, value);
    }
  }

  function onLayout(dc) {
    _logger.debug("AnalogView", "=== Layout ===");

    if (_layoutCalculated && _layout != null) {
      _logger.debug("AnalogView", "Layout already calculated");
      return;
    }

    // Calculate all layout values
    _layout = _layoutCalculator.calculateLayout(dc, _useOuterCircle);

    // Load fonts
    _iconFont = WatchUi.loadResource(Rez.Fonts.IconFont);
    _analogFont = WatchUi.loadResource(Rez.Fonts.AnalogFontSmall);

    // Create buffer if possible
    getBufferedBitmap(dc);

    _layoutCalculated = true;
    _logger.debug("AnalogView", "Layout complete");
  }

  private function getBufferedBitmap(dc) as Void {
    _backgroundBuffer = null;

    var deviceSettings = System.getDeviceSettings();
    var apiVersion = deviceSettings.monkeyVersion;

    if (apiVersion != null && apiVersion[0] >= 4 &&
        Graphics has: BufferedBitmap) {
      var bitmapOptions =
          { : width => dc.getWidth(), : height => dc.getHeight() };

      if (Graphics has: createBufferedBitmap) {
        var bufferRef = Graphics.createBufferedBitmap(bitmapOptions);
        _backgroundBuffer = bufferRef.get();
      } else {
        _backgroundBuffer = new Graphics.BufferedBitmap(bitmapOptions);
      }

      _logger.debug("AnalogView",
                    "Buffer created: " + (_backgroundBuffer != null));
    }
  }

  function onUpdate(dc) {
    _logger.trace("AnalogView", "=== onUpdate ===");

    if (!_layoutCalculated || _layout == null) {
      onLayout(dc);
    }

    // Draw static elements to buffer
    var targetDc = _backgroundBuffer != null ? _backgroundBuffer.getDc() : dc;

    if (targetDc has: setAntiAlias) {
      targetDc.setAntiAlias(true);
    }

    targetDc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    targetDc.clear();

    drawStaticElements(targetDc);

    if (targetDc has: setAntiAlias) {
      targetDc.setAntiAlias(false);
    }

    // Copy buffer to screen
    if (_backgroundBuffer != null) {
      dc.drawBitmap(0, 0, _backgroundBuffer);
    }

    // Draw dynamic elements
    if (dc has: setAntiAlias) {
      dc.setAntiAlias(true);
    }

    drawDynamicElements(dc);

    if (dc has: setAntiAlias) {
      dc.setAntiAlias(false);
    }
  }

  private function drawStaticElements(dc) as Void {
    _faceDrawer.drawFace(dc, _layout["centerX"], _layout["centerY"],
                         _layout["r097"], _layout["r090"], _layout["r004"],
                         _currentProfile, _useOuterCircle,
                         _layout["outerPenWidth"], _layout["innerPenWidth"]);

    _faceDrawer.drawHourMarkers(dc, _layout["hourMarkerPoints"],
                                _currentProfile);
    _faceDrawer.drawMinuteTicks(dc, _layout["minuteTickPoints"],
                                MINUTE_TICK_PEN_WIDTH, _currentProfile);
    _faceDrawer.drawNumbers(dc, _layout["numberX"], _layout["numberY"],
                            _layout["numberText"], _currentProfile);
  }

  private function drawDynamicElements(dc) as Void {
    _faceDrawer.drawBattery(dc, _layout["centerX"], _layout["centerY"],
                            _layout["arcRadius"], START_ANGLE,
                            _layout["loadPenWidth"], _currentProfile);

    _dateDrawer.drawDateInfo(
        dc, _layout["centerY"], _layout["dateBoxMaxlen"], _layout["dateBoxY"],
        _layout["dateBoxHeight"], _layout["dateBoxSpacing"],
        _layout["dateBoxOutlinePenWidth"], _currentProfile);

    var clockTime = System.getClockTime();
    _handDrawer.drawHands(dc, clockTime, _layout["centerX"], _layout["centerY"],
                          _layout["radius"], _layout["r055"], _layout["r070"],
                          _layout["r035"], _layout["r025"], _currentProfile,
                          _updateEverySecond, SECOND_PEN_WIDTH);

    // Data fields
    if (_dataFieldNorth == 0) {
      _dataFieldDrawer.drawBluetooth(dc, _layout["bluetoothx"],
                                     _layout["bluetoothy"], _iconFont,
                                     _currentProfile);
    } else {
      _dataFieldDrawer.drawDataField(
          dc, _layout["dataFieldNorthX"], _layout["dataFieldNorthY"],
          _dataFieldNorth, _analogFont, _currentProfile);
    }

    _dataFieldDrawer.drawDataField(dc, _layout["dataFieldSouthX"],
                                   _layout["dataFieldSouthY"], _dataFieldSouth,
                                   _analogFont, _currentProfile);
    _dataFieldDrawer.drawDataField(dc, _layout["dataFieldWestX"],
                                   _layout["dataFieldWestY"], _dataFieldWest,
                                   _analogFont, _currentProfile);
  }

  function onEnterSleep() {
    _logger.debug("AnalogView", "=== Enter sleep ===");
  }

  function onExitSleep() { _logger.debug("AnalogView", "=== Exit sleep ==="); }

  private function logDeviceInfo() as Void {
    var ds = System.getDeviceSettings();
    _logger.debug("AnalogView", "Device: " + ds.partNumber);
    _logger.debug("AnalogView",
                  "Screen: " + ds.screenWidth + "x" + ds.screenHeight);
    _logger.debug("AnalogView", "API: " + ds.monkeyVersion.toString());
  }
}

function getAnalogView() as AnalogView { return AnalogView.getInstance(); }