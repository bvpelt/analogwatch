using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.Application.Properties;

class AnalogView extends WatchUi
.WatchFace {
  private static var _instance as AnalogView ? ;
  private var _logger;
  private var _propertieUtility;
  private var _iconFont;

  private var _radius = 0;
  private var _centerX = 0;
  private var _centerY = 0;

  // Colors
  private var _handbgcolor;     // = 0x504949;
  private var _handfgcolor;     // = 0xff0000;
  private var _handcentercolor; // = _handfgcolor;

  private var _facebgcolor;     // = 0x000000;
  private var _facebordercolor; // = 0xc0c0c0;

  private var _daybgcolor;      // = 0x000000;
  private var _daynamecolor;    // = 0xff3333;
  private var _day_numbercolor; // = 0xa0a0a0;
  private var _dayoutlinecolor; // = 0xc0c0c0;

  private var _hourmarkercolor; // = 0xffffff;
  private var _minutetickcolor; // = 0xa0a0a0;
  private var _numbercolor;     // = 0xffffff;

  private var _batteryfull;  // = 0x26A924 green
  private var _batteryempty; // = 0xff0000 red

  private var _updateEverySecond = true; // default value

  private var _outerPenWidth;
  private var _innerPenWidth;
  private var _bluetoothx;
  private var _bluetoothy;
  private var _loadPenWidth;
  private var _arcRadius;
  private var _startAngle = 90;
  private var _secondPenWidth = 3;     // 3 pixels for secondhand
  private var _minuteTickPenWidth = 2; // 2 pixels for minute ticks

  // Profile definitions
  private const PROFILE_CLASSIC = 0;
  private const PROFILE_BLUE_STEEL = 1;
  private const PROFILE_ORANGE = 2;
  private const PROFILE_WHITE = 3;
  private const PROFILE_CUSTOM = 4;

  // New variables for Partial Updates
  private var _backgroundBuffer as Graphics.BufferedBitmap ? ;

  // Cache for performance optimization
  private var _hourMarkerPoints as Lang.Array ? ;
  private var _minuteTickPoints as Lang.Array ? ;

  // Individual number position variables (cleaner than nested arrays)
  private var _numberX as Lang.Array    ? ;
  private var _numberY as Lang.Array    ? ;
  private var _numberText as Lang.Array ? ;

  // Individual radius multiples
  private var _r097 as Lang.Number = 0;
  private var _r090 as Lang.Number = 0;
  private var _r088 as Lang.Number = 0;
  private var _r070 as Lang.Number = 0;
  private var _r055 as Lang.Number = 0;
  private var _r035 as Lang.Number = 0;
  private var _r025 as Lang.Number = 0;
  private var _r004 as Lang.Number = 0;
  //  private var _r007 as Lang.Number = 0;
  private var _tickLength as Lang.Number = 0;
  private var _triangleHeight as Lang.Number = 0;
  private var _triangleBase as Lang.Number = 0;

  // Date box positions
  private var _dateBoxHeight as Lang.Number = 0;
  private var _dateBoxSpacing as Lang.Number = 0;
  private var _dateBoxMaxlen as Lang.Number = 0;
  private var _dateBoxY as Lang.Number = 0;
  private var _dateBoxOutlinePenWidth as Lang.Number = 0;

  private var _layoutCalculated as Lang.Boolean = false;

  // Constructor
  private function initialize() {
    WatchFace.initialize();
    _logger = getLogger();
    _propertieUtility = getPropertieUtility();
    _logger.debug("AnalogView", "Initializing AnalogView");

    var deviceSettings = System.getDeviceSettings();
    _logger.debug("AnalogView",
                  "firmwareversion: " + deviceSettings.firmwareVersion);
    _logger.debug("AnalogView",
                  "monkeyVersion: " + deviceSettings.monkeyVersion.toString());
    _logger.debug("AnalogView", "partNumber: " + deviceSettings.partNumber);
    _logger.debug("AnalogView", "screenHeight: " + deviceSettings.screenHeight);
    _logger.debug("AnalogView", "screenWidth: " + deviceSettings.screenWidth);
    _logger.debug("AnalogView",
                  "uniqueIdentifier: " + deviceSettings.uniqueIdentifier);
    if (deviceSettings has: heightUnits) {
      _logger.debug("AnalogView",
                    "heightUnits: " + deviceSettings.heightUnits.toString());
    }

    if (deviceSettings has: inputButtons) {
      _logger.debug("AnalogView",
                    "inputButtons: " + ViewUtil.inputButtonsToString(
                                           deviceSettings.inputButtons));
    }

    if (deviceSettings has: isEnhancedReadabilityModeEnabled) {
      _logger.debug(
          "AnalogView",
          "isEnhancedReadabilityModeEnabled: " +
              deviceSettings.isEnhancedReadabilityModeEnabled.toString());
    }

    if (deviceSettings has: isGlanceModeEnabled) {

      _logger.debug("AnalogView",
                    "isGlanceModeEnabled: " +
                        deviceSettings.isGlanceModeEnabled.toString());
    }

    if (deviceSettings has: isTouchScreen) {
      _logger.debug("AnalogView", "isTouchScreen: " +
                                      deviceSettings.isTouchScreen.toString());
    }

    if (deviceSettings has: paceUnits) {
      _logger.debug("AnalogView",
                    "paceUnits: " + deviceSettings.paceUnits.toString());
    }

    if (deviceSettings has: phoneOperatingSystem) {
      _logger.debug("AnalogView", "phoneOperatingSystem: " +
                                      ViewUtil.phoneOperatingSystemToString(
                                          deviceSettings.phoneOperatingSystem));
    }

    if (deviceSettings has: requiresBurnInProtection) {
      _logger.debug("AnalogView", "requiresBurnInProtection: " +
                                      deviceSettings.requiresBurnInProtection);
    }

    if (deviceSettings has: screenShape) {
      _logger.debug("AnalogView",
                    "screenShape: " + ViewUtil.screenShapeToString(
                                          deviceSettings.screenShape));
    }

    if (deviceSettings has: vibrateOn) {
      _logger.debug("AnalogView", "vibrateOn: " + deviceSettings.vibrateOn);
    }
    // Load settings immediately on startup
    updateSettings();
  }

  // Get singleton instance
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

  // This is called when the view is hidden/closed
  function onHide() { _logger.debug("AnalogView", "=== AnalogView onHide"); }

  public function updateSettings() {
    _logger.debug("AnalogView", "==== Updatesettings AnalogView ====");

    var profile = _propertieUtility.getPropertyNumber("ColorProfile", 0);

    _updateEverySecond =
        _propertieUtility.getPropertyBoolean("UpdateSeconds", true);
    _logger.debug("AnalogView",
                  "==== Initialize AnalogView - Update every second: " +
                      _updateEverySecond.toString() + " ====");

    if (profile == null) {
      profile = PROFILE_CLASSIC;
    }

    _logger.debug("AnalogView", "==== Initializing AnalogView with profile: " +
                                    profile.toString() + " ====");

    // Apply predefined profile or load custom values
    if (profile == PROFILE_CLASSIC) {
      applyClassicProfile();
    } else if (profile == PROFILE_BLUE_STEEL) {
      applyBlueSteelProfile();
    } else if (profile == PROFILE_ORANGE) {
      applyOrangeProfile();
    } else if (profile == PROFILE_WHITE) {
      applyWhiteProfile();
    } else if (profile == PROFILE_CUSTOM) {
      loadCustomColors();
    } else {
      applyClassicProfile(); // Default fallback
    }

    // Invalidate cached background buffer when colors change
    _layoutCalculated = false;

    WatchUi.requestUpdate();
  }
  // oud
  public function updateSettingsxx() {
    _logger.debug("AnalogView", "==== Updatesettings AnalogView ====");

    var profile = _propertieUtility.getPropertyNumber("ColorProfile", 0);

    _updateEverySecond =
        _propertieUtility.getPropertyBoolean("UpdateSeconds", true);
    _logger.debug("AnalogView",
                  "==== Initialize AnalogView - Update every second: " +
                      _updateEverySecond.toString() + " ====");

    if (profile == null) {
      profile = PROFILE_CLASSIC;
    }

    _logger.debug("AnalogView", "==== Initializing AnalogView with profile: " +
                                    profile.toString() + " ====");

    // Apply predefined profile or load custom values
    if (profile == PROFILE_CLASSIC) {
      applyClassicProfile();
    } else if (profile == PROFILE_BLUE_STEEL) {
      applyBlueSteelProfile();
    } else if (profile == PROFILE_ORANGE) {
      applyOrangeProfile();
    } else if (profile == PROFILE_WHITE) {
      applyWhiteProfile();
    } else if (profile == PROFILE_CUSTOM) {
      loadCustomColors();
    } else {
      applyClassicProfile(); // Default fallback
    }

    WatchUi.requestUpdate();
  }

  private function applyClassicProfile() {
    _logger.debug("AnalogView", "=== Applying Classic Profile ===");
    _handbgcolor = 0x504949;     // { "charcoal", "#504949" },
    _handfgcolor = 0xff0000;     // { "red", "#ff0000" },
    _facebgcolor = 0x000000;     // { "black", "#000000" },
    _facebordercolor = 0xc0c0c0; // { "silver", "#c0c0c0" },
    _handcentercolor = 0xff0000; // { "red", "#ff0000" },
    _daybgcolor = 0x000000;      // { "black", "#000000" },
    _daynamecolor = 0xff3333;    // { "cinnabar", "#ff3333" },
    _day_numbercolor = 0xa0a0a0; // { "cool steel", "#a0a0a0" },
    _dayoutlinecolor = 0xc0c0c0; // { "silver", "#c0c0c0" },
    _hourmarkercolor = 0xffffff; // { "white", "#ffffff" },
    _minutetickcolor = 0xa0a0a0; // { "cool steel", "#a0a0a0" },
    _numbercolor = 0xffffff;     // { "white", "#ffffff" },
    _batteryfull = 0x26a924;     // { "green" , "#26a924" },
    _batteryempty = 0xff0000;    // { "red", "#ff0000" },
  }

  private function applyBlueSteelProfile() {
    _logger.debug("AnalogView", "=== Applying Blue Steel Profile ===");
    _handbgcolor = 0x0d2c54;     // {"oxford navy", "#0d2c54"}
    _handfgcolor = 0x00a6ed;     // {"fresh sky", "#00a6ed"},
    _facebgcolor = 0x061a40;     // {"prussian blue", "#061a40"},
    _facebordercolor = 0x061a40; // {"prussian blue", "#061a40"},
    _handcentercolor = 0x061a40; // {"prussian blue", "#061a40"},
    _daybgcolor = 0x061a40;      // {"prussian blue", "#061a40"},
    _daynamecolor = 0xffffff;    // {"white", "#ffffff" }
    _day_numbercolor = 0xffffff; // {"white", "#ffffff" }
    _dayoutlinecolor = 0x0d2c54; // {"oxford navy", "#0d2c54"}
    _hourmarkercolor = 0xffffff; // {"white", "#ffffff" }
    _minutetickcolor = 0xffffff; // {"white", "#ffffff" }
    _numbercolor = 0x00a6ed;     // {"fresh sky", "#00a6ed"},
    _batteryfull = 0x26a924;     // { "green" , "#26a924" },
    _batteryempty = 0xff0000;    // { "red", "#ff0000" },
  }

  private function applyOrangeProfile() {
    _logger.debug("AnalogView", "=== Applying Orange Profile ===");
    _handbgcolor = 0xffcdbc;     // {"almond silk", "#ffcdbc"}
    _handfgcolor = 0xf5853f;     // {"pumpkin spice","#f5853f"},
    _facebgcolor = 0x130303;     // {"coffee bean", "#130303"},
    _facebordercolor = 0x130303; // {"coffee bean", "#130303"},
    _handcentercolor = 0xf5853f; // {"pumpkin spice","#f5853f"},
    _daybgcolor = 0x130303;      // {"coffee bean", "#130303"},
    _daynamecolor = 0xf5853f;    // {"pumpkin spice","#f5853f"},
    _day_numbercolor = 0xf5853f; // {"pumpkin spice","#f5853f"},
    _dayoutlinecolor = 0xc0c0c0; // {"silver", "#c0c0c0" },
    _hourmarkercolor = 0xf5853f; // {"pumpkin spice","#f5853f"},
    _minutetickcolor = 0xf5853f; // {"pumpkin spice","#f5853f"},
    _numbercolor = 0xf5853f;     // {"pumpkin spice","#f5853f"},
    _batteryfull = 0x26a924;     // { "green" , "#26a924" },
    _batteryempty = 0xff0000;    // { "red", "#ff0000" },
  }

  private function applyWhiteProfile() {
    _logger.debug("AnalogView", "=== Applying White Profile ===");
    _handbgcolor = 0xc0c0c0;     // { "silver", "#c0c0c0" },
    _handfgcolor = 0x000000;     // { "black", "#000000" },
    _facebgcolor = 0xc0c0c0;     // { "silver", "#c0c0c0" },
    _facebordercolor = 0x000000; // { "black", "#000000" },
    _handcentercolor = 0xc0c0c0; // { "silver", "#c0c0c0" },
    _daybgcolor = 0xc0c0c0;      // { "silver", "#c0c0c0" },
    _daynamecolor = 0x000000;    // { "black", "#000000" },
    _day_numbercolor = 0x000000; // { "black", "#000000" },
    _dayoutlinecolor = 0xc0c0c0; // { "silver", "#c0c0c0" },
    _hourmarkercolor = 0x000000; // { "black", "#000000" },
    _minutetickcolor = 0x000000; // { "black", "#000000" },
    _numbercolor = 0x000000;     // { "black", "#000000" },
    _batteryfull = 0x26a924;     // { "green" , "#26a924" },
    _batteryempty = 0xff0000;    // { "red", "#ff0000" },
  }

  private function loadCustomColors() {
    _logger.debug("AnalogView",
                  "=== Loading custom colors from properties ===");

    // Load each color from properties
    _handbgcolor = _propertieUtility.getPropertyNumber("HandBgColor", 0x504949);
    _handfgcolor = _propertieUtility.getPropertyNumber("HandFgColor", 0xff0000);
    _facebgcolor = _propertieUtility.getPropertyNumber("FaceBgColor", 0x000000);
    _facebordercolor =
        _propertieUtility.getPropertyNumber("FaceBorderColor", 0xc0c0c0);
    _handcentercolor =
        _propertieUtility.getPropertyNumber("HandCenterColor", 0xff0000);
    _daybgcolor = _propertieUtility.getPropertyNumber("DayBgColor", 0x000000);
    _daynamecolor =
        _propertieUtility.getPropertyNumber("DayNameColor", 0xff3333);
    _day_numbercolor =
        _propertieUtility.getPropertyNumber("DayNumberColor", 0xa0a0a0);
    _dayoutlinecolor =
        _propertieUtility.getPropertyNumber("DayOutlineColor", 0xc0c0c0);
    _hourmarkercolor =
        _propertieUtility.getPropertyNumber("HourMarkerColor", 0xffffff);
    _minutetickcolor =
        _propertieUtility.getPropertyNumber("MinuteTickColor", 0xa0a0a0);
    _numbercolor = _propertieUtility.getPropertyNumber("NumberColor", 0xffffff);
    _batteryfull =
        _propertieUtility.getPropertyNumber("BatteryFullColor", 0x26a924);
    _batteryempty =
        _propertieUtility.getPropertyNumber("BatteryEmptyColor", 0xff0000);
  }

  function onLayout(dc) {
    _logger.debug("AnalogView", "=== Layout AnalogView ===");

    // Check if we need to recalculate at all
    var needsRecalculation = !_layoutCalculated || _centerX == 0 ||
                             _centerY == 0 || _centerX != dc.getWidth() / 2 ||
                             _centerY != dc.getHeight() / 2;

    if (!needsRecalculation) {
      _logger.debug("AnalogView",
                    "Layout already calculated, skipping recalculation");
      return;
    }

    _centerX = dc.getWidth() / 2;
    _centerY = dc.getHeight() / 2;
    var minDimension = _centerX < _centerY ? _centerX : _centerY;
    _radius = minDimension * 0.95;

    _outerPenWidth = (_radius * 0.06).toNumber();
    if (_outerPenWidth < 1) {
      _outerPenWidth = 1;
    }
    _innerPenWidth = (_radius * 0.01).toNumber();
    if (_innerPenWidth < 1) {
      _innerPenWidth = 1;
    }

    _bluetoothx = (_centerX).toNumber();
    _bluetoothy = (_centerY - _radius * 0.50).toNumber();

    _loadPenWidth = (_radius * 0.05).toNumber();
    if (_loadPenWidth < 1) {
      _loadPenWidth = 1;
    }

    _arcRadius = (_radius * 0.92).toNumber();

    _iconFont = WatchUi.loadResource(Rez.Fonts.IconFont);

    // PRE-CALCULATE COMMON RADIUS MULTIPLES
    _r097 = (_radius * 0.97).toNumber();
    _r090 = (_radius * 0.90).toNumber();
    _r088 = (_radius * 0.88).toNumber();
    _r070 = (_radius * 0.70).toNumber();
    _r055 = (_radius * 0.55).toNumber();
    _r035 = (_radius * 0.035).toNumber();
    _r025 = (_radius * 0.025).toNumber();
    _r004 = (_radius * 0.04).toNumber();
    //    _r007 = (_radius * 0.07).toNumber();
    _tickLength = (_radius * 0.04).toNumber();
    _triangleHeight = (_radius * 0.07).toNumber();
    _triangleBase = (_radius * 0.04).toNumber();

    // PRE-CALCULATE HOUR MARKER POSITIONS
    _hourMarkerPoints = new[12];
    for (var i = 0; i < 12; i++) {
      var angle = (i * Math.PI) / 6;
      var cosAngle = Math.cos(angle);
      var sinAngle = Math.sin(angle);
      var perpAngle = angle + Math.PI / 2;
      var cosPerAngle = Math.cos(perpAngle);
      var sinPerAngle = Math.sin(perpAngle);

      var xOuter = (_centerX + cosAngle * _r088).toNumber();
      var yOuter = (_centerY + sinAngle * _r088).toNumber();

      var xBase1 = (xOuter + cosPerAngle * (_triangleBase / 2)).toNumber();
      var yBase1 = (yOuter + sinPerAngle * (_triangleBase / 2)).toNumber();
      var xBase2 = (xOuter - cosPerAngle * (_triangleBase / 2)).toNumber();
      var yBase2 = (yOuter - sinPerAngle * (_triangleBase / 2)).toNumber();

      var xTip = (_centerX + cosAngle * (_r088 - _triangleHeight)).toNumber();
      var yTip = (_centerY + sinAngle * (_r088 - _triangleHeight)).toNumber();

      _hourMarkerPoints[i] = [[xBase1, yBase1], [xBase2, yBase2], [xTip, yTip]];
    }

    // PRE-CALCULATE MINUTE TICK POSITIONS
    _minuteTickPoints = [];
    for (var i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        var angle = (i * Math.PI) / 30;
        var cosAngle = Math.cos(angle);
        var sinAngle = Math.sin(angle);

        var xStart = (_centerX + cosAngle * _r088).toNumber();
        var yStart = (_centerY + sinAngle * _r088).toNumber();
        var xEnd = (_centerX + cosAngle * (_r088 - _tickLength)).toNumber();
        var yEnd = (_centerY + sinAngle * (_r088 - _tickLength)).toNumber();

        _minuteTickPoints.add([xStart, yStart, xEnd, yEnd]);
      }
    }

    // PRE-CALCULATE NUMBER POSITIONS
    _numberX = new[12];
    _numberY = new[12];
    _numberText = new[12];
    var numbers = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    for (var i = 0; i < 12; i++) {
      var angle = (i * Math.PI) / 6 - Math.PI / 2;
      _numberX[i] = (_centerX + Math.cos(angle) * _r070).toNumber();
      _numberY[i] = (_centerY + Math.sin(angle) * _r070).toNumber();
      _numberText[i] = numbers[i].toString();
    }

    // PRE-CALCULATE DATE BOX POSITIONS
    var boxHeight = (_radius * 0.19).toNumber();
    var boxSpacing = (_radius * 0.03).toNumber();
    var maxlen = (_centerX + _radius * 0.60).toNumber();

    _dateBoxHeight = boxHeight;
    _dateBoxSpacing = boxSpacing;
    _dateBoxMaxlen = maxlen;
    _dateBoxY = _centerY.toNumber() - boxHeight / 2;
    _dateBoxOutlinePenWidth =
        (_radius * 0.008).toNumber() < 1 ? 1 : (_radius * 0.008).toNumber();

    // Initialize the off-screen buffer - skip on memory-constrained devices
    _backgroundBuffer = null;

    var deviceSettings = System.getDeviceSettings();
    var apiVersion = deviceSettings.monkeyVersion;

    // Only create BufferedBitmap on API 4.0+ devices (they have more memory)
    // API 3.2 devices like FR645 Music often run out of memory
    if (apiVersion != null && apiVersion[0] >= 4 &&
        Graphics has: BufferedBitmap) {
      _logger.debug("AnalogView", "Creating buffered bitmap for API " +
                                      apiVersion[0] + "." + apiVersion[1] +
                                      " device");

      var bitmapOptions =
          { : width => dc.getWidth(), : height => dc.getHeight() };

      if (Graphics has: createBufferedBitmap) {
        _logger.debug("AnalogView", "Using createBufferedBitmap method");
        var bufferRef = Graphics.createBufferedBitmap(bitmapOptions);
        _backgroundBuffer = bufferRef.get();
      } else {
        _logger.debug("AnalogView", "Using BufferedBitmap constructor");
        _backgroundBuffer = new Graphics.BufferedBitmap(bitmapOptions);
      }

      if (_backgroundBuffer != null) {
        _logger.debug("AnalogView", "Buffered bitmap created successfully");
      } else {
        _logger.debug("AnalogView", "Buffered bitmap creation returned null");
      }
    } else {
      if (apiVersion != null) {
        _logger.debug("AnalogView", "Skipping BufferedBitmap - API " +
                                        apiVersion[0] + "." + apiVersion[1] +
                                        " device (need 4.0+)");
      } else {
        _logger.debug("AnalogView",
                      "Skipping BufferedBitmap - API version unknown");
      }
    }

    _layoutCalculated = true;
    _logger.debug("AnalogView", "Layout calculations complete");
  }

  function onUpdate(dc) {
    _logger.trace("AnalogView", "=== AnalogView onUpdate ===");

    if (_centerX == 0 || _centerY == 0) {
      onLayout(dc); // Safety fallback
    }

    // 1. Check if we need to redraw the static background
    // We only redraw the buffer if settings changed or it's empty
    var targetDc = dc;

    if (_backgroundBuffer != null) {
      _logger.trace("AnalogView", "Use background buffer");
      // If we have a buffer, we draw the static face into IT, not the screen
      targetDc = _backgroundBuffer.getDc();
    }

    if (targetDc has: setAntiAlias) {
      targetDc.setAntiAlias(true);
    }

    // 2. Draw Static Elements to the Buffer (or Screen if no buffer)
    // ONLY do this if we actually need to refresh the background
    // (For simplicity, we do it every frame here, but ideally you cache this)
    targetDc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    targetDc.clear();

    // Pass targetDc (the buffer) to these functions
    drawFace(targetDc);
    drawHourMarkers(targetDc);
    drawMinuteTicks(targetDc);
    drawNumbers(targetDc);

    // 3. If we used a buffer, copy it to the real screen now
    if (_backgroundBuffer != null) {
      dc.drawBitmap(0, 0, _backgroundBuffer);
    }
    if (targetDc has: setAntiAlias) {
      targetDc.setAntiAlias(false);
    }
    _logger.trace("AnalogView", "Use device context");

    // 4. Draw Dynamic Elements (Battery, Date, Hands) directly on Screen
    // These change often, so we draw them on top of the bitmap
    if (dc has: setAntiAlias) {
      dc.setAntiAlias(true);
    }
    drawLoad(dc);
    drawDateInfo(dc);
    drawTime(dc); // Draws Hour/Minute hands (and second hand if High Power)
    drawBluetoothStatus(dc);
    if (dc has: setAntiAlias) {
      dc.setAntiAlias(false);
    }
  }

  private function drawBluetoothStatus(dc as Graphics.Dc) as Void {
    var phoneConnection = getPhoneConnection();
    var status = phoneConnection.getConnectionStatus();

    _logger.trace("AnalogView", "Draw bluetooth status: " + status + " at x: " +
                                    _bluetoothx + " y: " + _bluetoothy);

    ViewUtil.drawBlueTooth(dc, _bluetoothx, _bluetoothy, _iconFont, status);
  }

  private function drawFace(dc) {
    _logger.trace("AnalogView", "drawFace");

    // Dark background
    dc.setColor(_facebgcolor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(_centerX, _centerY, _r097);

    // Outer silver ring
    dc.setColor(_facebordercolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(_outerPenWidth);
    dc.drawCircle(_centerX, _centerY, _r097);

    dc.setPenWidth(_innerPenWidth);
    dc.drawCircle(_centerX, _centerY, _r090);

    // Center point
    dc.setColor(_handcentercolor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(_centerX, _centerY, _r004);
  }

  private function drawLoad(dc) {
    // var startAngle = 90;
    var loadPercentage = System.getSystemStats().battery;
    var sweepAngle = (loadPercentage / 100.0) * 360;

    // Green portion (loaded)
    dc.setColor(_batteryfull, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(_loadPenWidth);
    dc.drawArc(_centerX, _centerY, _arcRadius, Graphics.ARC_CLOCKWISE,
               _startAngle, _startAngle - sweepAngle);

    // Red portion (remaining)
    dc.setColor(_batteryempty, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(_centerX, _centerY, _arcRadius, Graphics.ARC_CLOCKWISE,
               _startAngle - sweepAngle, _startAngle);
  }

  private function drawHourMarkers(dc) {
    _logger.trace("AnalogView", "drawHourMarkers");

    if (_hourMarkerPoints == null) {
      return; // Safety check
    }

    dc.setColor(_hourmarkercolor, Graphics.COLOR_TRANSPARENT);

    for (var i = 0; i < 12; i++) {
      dc.fillPolygon(_hourMarkerPoints[i]);
    }
  }

  private function drawMinuteTicks(dc) {
    if (_minuteTickPoints == null) {
      return; // Safety check
    }

    dc.setColor(_minutetickcolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(_minuteTickPenWidth);
    _logger.trace("AnalogView", "Minuteticks penwidth: " + _minuteTickPenWidth);

    for (var i = 0; i < _minuteTickPoints.size(); i++) {
      var tick = _minuteTickPoints[i] as Lang.Array;
      dc.drawLine(tick[0], tick[1], tick[2], tick[3]);
    }
  }

  private function drawNumbers(dc) {
    if (_numberX == null || _numberY == null || _numberText == null) {
      return;
    }

    dc.setColor(_numbercolor, Graphics.COLOR_TRANSPARENT);
    var font = Graphics.FONT_XTINY;

    for (var i = 0; i < 12; i++) {
      dc.drawText(_numberX[i] as Lang.Number, _numberY[i] as Lang.Number, font,
                  _numberText[i] as Lang.String,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
  }

  private function drawDateInfo(dc) {
    var now = Gregorian.info(Time.now(), Time.FORMAT_LONG);
    var weekday = Lang.format("$1$", [now.day_of_week]);
    var dayNum = now.day;
    var dayString = dayNum < 10 ? "0" + dayNum.toString() : dayNum.toString();

    var font = Graphics.FONT_XTINY;
    var boxNumberWidth = 1.1 * dc.getTextWidthInPixels(dayString, font);
    var boxWeekdayWidth = 1.1 * dc.getTextWidthInPixels(weekday, font);

    var boxDNumberX = _dateBoxMaxlen - boxNumberWidth;
    var boxWDNameX =
        _dateBoxMaxlen - boxWeekdayWidth - boxNumberWidth - _dateBoxSpacing;

    // Weekday box
    dc.setColor(_daybgcolor, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(boxWDNameX, _dateBoxY, boxWeekdayWidth, _dateBoxHeight);

    dc.setColor(_dayoutlinecolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(_dateBoxOutlinePenWidth);
    dc.drawRectangle(boxWDNameX, _dateBoxY, boxWeekdayWidth, _dateBoxHeight);

    dc.setColor(_daynamecolor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(boxWDNameX + boxWeekdayWidth / 2, _centerY, font, weekday,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    // Day box
    dc.setColor(_daybgcolor, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(boxDNumberX, _dateBoxY, boxNumberWidth, _dateBoxHeight);

    dc.setColor(_dayoutlinecolor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(_dateBoxOutlinePenWidth);
    dc.drawRectangle(boxDNumberX, _dateBoxY, boxNumberWidth, _dateBoxHeight);

    dc.setColor(_day_numbercolor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(boxDNumberX + boxNumberWidth / 2, _centerY, font, dayString,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  private function drawTime(dc) {
    var clockTime = System.getClockTime();
    var hour = clockTime.hour % 12;
    var minute = clockTime.min;
    var second = clockTime.sec;

    // Hour hand
    var hourAngle =
        (hour * Math.PI) / 6 + (minute * Math.PI) / 360 - Math.PI / 2;
    drawHand(dc, hourAngle, _r055, _r035);

    // Minute hand
    var minuteAngle =
        (minute * Math.PI) / 30 + (second * Math.PI) / 1800 - Math.PI / 2;
    drawHand(dc, minuteAngle, _r070, _r025);

    if (_updateEverySecond) {
      // Second hand
      var secondAngle = (second * Math.PI) / 30 - Math.PI / 2;
      dc.setColor(_handfgcolor, Graphics.COLOR_TRANSPARENT);

      _logger.trace("AnalogView",
                    "drawTime secondhand penwidth: " + _secondPenWidth);
      dc.setPenWidth(_secondPenWidth);

      var cosAngle = Math.cos(secondAngle);
      var sinAngle = Math.sin(secondAngle);

      var x1 = (_centerX - cosAngle * _radius * 0.1).toNumber();
      var y1 = (_centerY - sinAngle * _radius * 0.1).toNumber();
      var x2 = (_centerX + cosAngle * _radius * 0.75).toNumber();
      var y2 = (_centerY + sinAngle * _radius * 0.75).toNumber();
      dc.drawLine(x1, y1, x2, y2);
    }
  }

  private function drawHand(dc, angle, length, width) {
    var cosAngle = Math.cos(angle);
    var sinAngle = Math.sin(angle);
    var l = length;
    var w = width;

    // Outline hand
    var points = [
      [_centerX, _centerY],
      [_centerX - sinAngle * w * 0.5, _centerY + cosAngle * w * 0.5],
      [
        _centerX + (cosAngle * l) / 15 - sinAngle * w * 0.5,
        _centerY + (sinAngle * l) / 15 + cosAngle * w * 0.5,
      ],
      [
        _centerX + (cosAngle * 2 * l) / 15 - sinAngle * w * 1.5,
        _centerY + (sinAngle * 2 * l) / 15 + cosAngle * w * 1.5,
      ],
      [
        _centerX + (cosAngle * 10 * l) / 15 - sinAngle * w * 1.5,
        _centerY + (sinAngle * 10 * l) / 15 + cosAngle * w * 1.5,
      ],
      [
        _centerX + (cosAngle * 11 * l) / 15 - sinAngle * w * 0.5,
        _centerY + (sinAngle * 11 * l) / 15 + cosAngle * w * 0.5,
      ],
      [
        _centerX + cosAngle * l - sinAngle * w * 0.5,
        _centerY + sinAngle * l + cosAngle * w * 0.5,
      ],
      [
        _centerX + cosAngle * l + sinAngle * w * 0.5,
        _centerY + sinAngle * l - cosAngle * w * 0.5,
      ],
      [
        _centerX + (cosAngle * 11 * l) / 15 + sinAngle * w * 0.5,
        _centerY + (sinAngle * 11 * l) / 15 - cosAngle * w * 0.5,
      ],
      [
        _centerX + (cosAngle * 10 * l) / 15 + sinAngle * w * 1.5,
        _centerY + (sinAngle * 10 * l) / 15 - cosAngle * w * 1.5,
      ],
      [
        _centerX + (cosAngle * 2 * l) / 15 + sinAngle * w * 1.5,
        _centerY + (sinAngle * 2 * l) / 15 - cosAngle * w * 1.5,
      ],
      [
        _centerX + (cosAngle * l) / 15 + sinAngle * w * 0.5,
        _centerY + (sinAngle * l) / 15 - cosAngle * w * 0.5,
      ],
      [_centerX + sinAngle * w * 0.5, _centerY - cosAngle * w * 0.5],
      [_centerX, _centerY],
    ];

    dc.setColor(_handbgcolor, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(points);

    // Inside line hand
    var innerPoints = [
      [_centerX + (cosAngle * 2 * l) / 15, _centerY + (sinAngle * 2 * l) / 15],
      [
        _centerX + (cosAngle * 2.8 * l) / 15 - sinAngle * w * 0.8,
        _centerY + (sinAngle * 2.8 * l) / 15 + cosAngle * w * 0.8,
      ],
      [
        _centerX + (cosAngle * 9.2 * l) / 15 - sinAngle * w * 0.8,
        _centerY + (sinAngle * 9.2 * l) / 15 + cosAngle * w * 0.8,
      ],
      [
        _centerX + (cosAngle * 10.2 * l) / 15,
        _centerY + (sinAngle * 10.2 * l) / 15,
      ],
      [
        _centerX + (cosAngle * 9.2 * l) / 15 + sinAngle * w * 0.8,
        _centerY + (sinAngle * 9.2 * l) / 15 - cosAngle * w * 0.8,
      ],
      [
        _centerX + (cosAngle * 2.8 * l) / 15 + sinAngle * w * 0.8,
        _centerY + (sinAngle * 2.8 * l) / 15 - cosAngle * w * 0.8,
      ],
      [_centerX + (cosAngle * 2 * l) / 15, _centerY + (sinAngle * 2 * l) / 15],
    ];

    dc.setColor(_handfgcolor, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(innerPoints);
  }

  function onEnterSleep() {
    _logger.debug("AnalogView", "=== Entering sleep mode ===");
  }

  function onExitSleep() {
    _logger.debug("AnalogView", "=== Exiting sleep mode ===");
  }
}

// Global convenience function
function getAnalogView() as AnalogView { return AnalogView.getInstance(); }
