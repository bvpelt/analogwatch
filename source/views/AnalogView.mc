using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Timer;

class AnalogView extends WatchUi
.WatchFace {
  private static var _instance as AnalogView ? ;
  private var _logger;
  private var _propertieUtility;

  // Utilities
  private var _faceDrawer;
  private var _handDrawer as HandBaseDrawer;
  private var _dateDrawer;
  private var _dataFieldDrawer;
  private var _layoutCalculator;
  // private var _heartRateReader as HeartRateReader;

  // Current state
  private var _currentProfile as ColorProfile;
  private var _layout as Lang.Dictionary = {};
  private var _layoutCalculated as Lang.Boolean = false;

  // Track if buffer needs redrawing
  private var _bufferDirty as Lang.Boolean = true;
  private var _secondTimer as Timer.Timer or Null;

  // Settings
  private var _updateEverySecond = true;
  private var _useOuterCircle = true;
  private var _showBackgroundImage = true;
  private var _dataFieldNorth = 0;
  private var _dataFieldSouth = 1;
  private var _dataFieldWest = 2;
  private var _logoName = 0;

  // Resources
  private var _iconFont;
  private var _analogFont;
  private var _backgroundBuffer as Graphics.BufferedBitmap ? ;
  private var _backgroundImage as WatchUi.BitmapResource or
      Graphics.BitmapReference or Null;

  // Constants
  private const SECOND_PEN_WIDTH = 3;
  private const MINUTE_TICK_PEN_WIDTH = 2;
  private const START_ANGLE = 90;

  // Logo family constants
  private const LOGO_NONE = 0;
  private const LOGO_VAV = 1;
  private const LOGO_BETHEL = 2;
  private const LOGO_KRUIS = 3;

  private var _logoVariant = LOGO_KRUIS; // only used for CustomProfile

  private function initialize() {
    WatchFace.initialize();
    _logger = getLogger();
    _propertieUtility = getPropertieUtility();

    // Initialize drawers
    _faceDrawer = new FaceDrawer();
    _handDrawer = new Svg03Drawer(); // new HandDrawer();
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

  function onUpdateHeartbeat() as Void { WatchUi.requestUpdate(); }

  function onShow() as Void {
    _logger.debug("AnalogView", "=== AnalogView onShow ===");

    if (_updateEverySecond) {
      _secondTimer = new Timer.Timer();
      _secondTimer.start(method(: onUpdateHeartbeat), 1000,
                         true); // true = repeat
    }
  }

  function onHide() {
    _logger.debug("AnalogView", "=== AnalogView onHide");
    if (_secondTimer != null) {
      _secondTimer.stop();
      _secondTimer = null;
    }
  }

  public function updateSettings() {
    _logger.debug("AnalogView", "==== updateSettings ====");

    // Read settings
    var profileId = _propertieUtility.getPropertyNumber("ColorProfile", 0);
    _updateEverySecond =
        _propertieUtility.getPropertyBoolean("UpdateSeconds", true);
    _useOuterCircle =
        _propertieUtility.getPropertyBoolean("UseOuterCircle", true);
    _showBackgroundImage =
        _propertieUtility.getPropertyBoolean("ShowBackgroundImage", false);
    _dataFieldNorth = _propertieUtility.getPropertyNumber("DataFieldNorth", 0);
    _dataFieldSouth = _propertieUtility.getPropertyNumber("DataFieldSouth", 1);
    _dataFieldWest = _propertieUtility.getPropertyNumber("DataFieldWest", 2);
    _logoName = _propertieUtility.getPropertyNumber("LogoName", 1);
    _logoVariant = _propertieUtility.getPropertyNumber("LogoVariant", 3);

    // Load profile
    _currentProfile = ProfileFactory.createProfile(profileId);
    _logger.debug("AnalogView", "Loaded profile: " + _currentProfile.getName());

    // Save profile colors for custom profile use
    saveProfileToProperties();

    _layoutCalculated = false;
    _bufferDirty = true; // <-- add this
    WatchUi.requestUpdate();
  }

  private function saveProfileToProperties() as Void {
    var colorDict = _currentProfile.toDictionary();
    var keys = colorDict.keys();

    for (var i = 0; i < keys.size(); i++) {
      var key = keys[i] as Lang.String;
      var value = colorDict[key] as Lang.Number;
      _logger.trace("AnalogView",
                    "saveProfileToProperties key: " + key + " value: " + value);
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

    if (_showBackgroundImage) {
      _backgroundImage = loadLogoForCurrentProfile();
      _logger.debug("AnalogView",
                    "Loaded logo image _backgroundImage: " + _backgroundImage);
    } else {
      _backgroundImage = null;
    }

    // Create buffer if possible
    getBufferedBitmap(dc);

    _layoutCalculated = true;
    _bufferDirty = true; // <-- buffer must be redrawn after layout
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

  private function loadLogoForCurrentProfile()
      as Graphics.BitmapReference or Null {
    if (_logoName == LOGO_NONE) {
      return null;
    }

    // Non-custom profiles auto-select their color variant
    // Custom profile uses the manually selected variant
    var variant = _currentProfile.getName().equals("Custom")
                      ? _logoVariant
                      : _currentProfile.getColorVariant();

    var resourceId = resolveLogoResource(_logoName, variant);
    if (resourceId == null) {
      return null;
    }

    return Application.loadResource(resourceId) as Graphics.BitmapReference;
  }

  private function resolveLogoResource(family as Lang.Number,
                                       variant as Lang.Number)
      as Lang.ResourceId or Null {

    // VAV family
    if (family == LOGO_VAV) {
      if (variant == VARIANT_BLACK) {
        return Rez.Drawables.VAVLogoBlack;
      }
      if (variant == VARIANT_BLUE) {
        return Rez.Drawables.VAVLogoBlue;
      }
      if (variant == VARIANT_BLUE_STEEL) {
        return Rez.Drawables.VAVLogoBlueSteel;
      }
      if (variant == VARIANT_CLASSIC) {
        return Rez.Drawables.VAVLogoClassic;
      }
      if (variant == VARIANT_GRAY) {
        return Rez.Drawables.VAVLogoGray;
      }
      if (variant == VARIANT_ORANGE) {
        return Rez.Drawables.VAVLogoOrange;
      }
      if (variant == VARIANT_WHITE) {
        return Rez.Drawables.VAVLogoWhite;
      }
      if (variant == VARIANT_WHITISH) {
        return Rez.Drawables.VAVLogoWhiteish;
      }
    }

    // BETHEL family
    if (family == LOGO_BETHEL) {
      if (variant == VARIANT_BLACK) {
        return Rez.Drawables.BETHELLogoBlack;
      }
      if (variant == VARIANT_BLUE) {
        return Rez.Drawables.BETHELLogoBlue;
      }
      if (variant == VARIANT_BLUE_STEEL) {
        return Rez.Drawables.BETHELLogoBlueSteel;
      }
      if (variant == VARIANT_CLASSIC) {
        return Rez.Drawables.BETHELLogoClassic;
      }
      if (variant == VARIANT_GRAY) {
        return Rez.Drawables.BETHELLogoGray;
      }
      if (variant == VARIANT_ORANGE) {
        return Rez.Drawables.BETHELLogoOrange;
      }
      if (variant == VARIANT_WHITE) {
        return Rez.Drawables.BETHELLogoWhite;
      }
      if (variant == VARIANT_WHITISH) {
        return Rez.Drawables.BETHELLogoWhiteish;
      }
    }

    // KRUIS family
    if (family == LOGO_KRUIS) {
      if (variant == VARIANT_BLACK) {
        return Rez.Drawables.KRUISLogoBlack;
      }
      if (variant == VARIANT_BLUE) {
        return Rez.Drawables.KRUISLogoBlue;
      }
      if (variant == VARIANT_BLUE_STEEL) {
        return Rez.Drawables.KRUISLogoBlueSteel;
      }
      if (variant == VARIANT_CLASSIC) {
        return Rez.Drawables.KRUISLogoClassic;
      }
      if (variant == VARIANT_GRAY) {
        return Rez.Drawables.KRUISLogoGray;
      }
      if (variant == VARIANT_ORANGE) {
        return Rez.Drawables.KRUISLogoOrange;
      }
      if (variant == VARIANT_WHITE) {
        return Rez.Drawables.KRUISLogoWhite;
      }
      if (variant == VARIANT_WHITISH) {
        return Rez.Drawables.KRUISLogoWhiteish;
      }
    }

    return null;
  }

  // Manual logo selection — only used for CustomProfile
  private function getLogoResourceIdFromSetting(logoName as Lang.Number)
      as Lang.ResourceId or Null {
    _logger.debug("AnalogView",
                  "getLogoResourceIdFromSetting logoName: " + logoName);
    if (logoName == 1) {
      return Rez.Drawables.VAVLogoBlack;
    }
    if (logoName == 2) {
      return Rez.Drawables.VAVLogoBlue;
    }
    if (logoName == 3) {
      return Rez.Drawables.VAVLogoBlueSteel;
    }
    if (logoName == 4) {
      return Rez.Drawables.VAVLogoClassic;
    }
    if (logoName == 5) {
      return Rez.Drawables.VAVLogoGray;
    }
    if (logoName == 6) {
      return Rez.Drawables.VAVLogoOrange;
    }
    if (logoName == 7) {
      return Rez.Drawables.VAVLogoWhite;
    }
    if (logoName == 8) {
      return Rez.Drawables.VAVLogoWhiteish;
    }
    if (logoName == 9) {
      return Rez.Drawables.BETHELLogoBlack;
    }
    if (logoName == 10) {
      return Rez.Drawables.BETHELLogoBlue;
    }
    if (logoName == 11) {
      return Rez.Drawables.BETHELLogoBlueSteel;
    }
    if (logoName == 12) {
      return Rez.Drawables.BETHELLogoClassic;
    }
    if (logoName == 13) {
      return Rez.Drawables.BETHELLogoGray;
    }
    if (logoName == 14) {
      return Rez.Drawables.BETHELLogoOrange;
    }
    if (logoName == 15) {
      return Rez.Drawables.BETHELLogoWhite;
    }
    if (logoName == 16) {
      return Rez.Drawables.BETHELLogoWhiteish;
    }

    if (logoName == 17) {
      return Rez.Drawables.KRUISLogoBlack;
    }
    if (logoName == 18) {
      return Rez.Drawables.KRUISLogoBlue;
    }
    if (logoName == 19) {
      return Rez.Drawables.KRUISLogoBlueSteel;
    }
    if (logoName == 20) {
      return Rez.Drawables.KRUISLogoClassic;
    }
    if (logoName == 21) {
      return Rez.Drawables.KRUISLogoGray;
    }
    if (logoName == 22) {
      return Rez.Drawables.KRUISLogoOrange;
    }
    if (logoName == 23) {
      return Rez.Drawables.KRUISLogoWhite;
    }
    if (logoName == 24) {
      return Rez.Drawables.KRUISLogoWhiteish;
    }
    return null;
  }

  function onUpdate(dc as Graphics.Dc) as Void {
    _logger.trace("AnalogView", "=== onUpdate ===");

    if (!_layoutCalculated || _layout == null) {
      onLayout(dc);
    }

    if (_backgroundBuffer != null) {
      // API 4+ Devices: Use the buffer
      if (_bufferDirty) {
        drawStaticToBuffer(dc);
        _bufferDirty = false;
      }
      dc.drawBitmap(0, 0, _backgroundBuffer);
    } else {
      // API 3.x Devices (like FR55): Redraw static elements directly to screen
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
      dc.clear();
      drawStaticElements(dc);
    }

    // Draw dynamic elements on top
    if (dc has: setAntiAlias) {
      dc.setAntiAlias(true);
    }

    drawDynamicElements(dc);

    if (dc has: setAntiAlias) {
      dc.setAntiAlias(false);
    }
  }

  // Renamed and fixed — draws background image + static elements into buffer
  private function drawStaticToBuffer(dc as Graphics.Dc) as Void {
    var targetDc = (_backgroundBuffer != null) ? _backgroundBuffer.getDc() : dc;
    _logger.debug("AnalogView", "drawStaticToBuffer");

    if (targetDc has: setAntiAlias) {
      targetDc.setAntiAlias(true);
    }

    // 1. Clear
    targetDc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    targetDc.clear();

    // 2. Draw static watch elements on top of background
    drawStaticElements(targetDc);

    if (targetDc has: setAntiAlias) {
      targetDc.setAntiAlias(false);
    }
  }

  // Notice I removed the strict `Graphics.BitmapReference` type so it accepts
  // API 3 resources
  private function drawBitMap(targetDc as Graphics.Dc, image) as Void {
    var screenW = targetDc.getWidth();
    var screenH = targetDc.getHeight();

    var imageW = image.getWidth();
    var imageH = image.getHeight();

    if (imageW <= 0 || imageH <= 0) {
      return;
    }

    var drawX;
    var drawY;
    var drawW;
    var drawH;

    // Place the logo at the top (25% down the screen) instead of dead center
    if (targetDc has: drawScaledBitmap) {
      var scaleX = screenW.toFloat() / imageW.toFloat();
      var scaleY = screenH.toFloat() / imageH.toFloat();
      var scale = scaleX < scaleY ? scaleX : scaleY;

      drawW = (imageW * scale * 0.8).toNumber();
      drawH = (imageH * scale * 0.8).toNumber();
      drawX = (screenW - drawW) / 2;
      drawY = (screenH - drawH) / 2; // Upper half

      _logger.debug("AnalogView", "drawBitMap scaled x: " + drawX +
                                      " y: " + drawY + " width: " + drawW +
                                      " height: " + drawH);

      try {
        targetDc.drawScaledBitmap(drawX, drawY, drawW, drawH, image);
      } catch (e) {
        _logger.error("AnalogView",
                      "drawScaledBitmap exception: " + e.toString());
      }
    } else {
      // Fallback for FR55 and older devices
      drawX = (screenW - imageW) / 2;
      drawY = (screenH - imageH) / 2; // Upper half
      _logger.debug("AnalogView", "drawBitMap x: " + drawX + " y: " + drawY);

      try {
        targetDc.drawBitmap(drawX, drawY, image);
      } catch (e) {
        _logger.error("AnalogView", "drawBitmap exception: " + e.toString());
      }
    }
  }

  private function drawStaticElements(dc) as Void {

    var centerRadius = _layout["r004"];

    _faceDrawer.drawFace(dc, _layout, _currentProfile, _useOuterCircle,
                         centerRadius);

    _faceDrawer.drawHourMarkers(dc, _layout["hourMarkerPoints"],
                                _currentProfile);
    _faceDrawer.drawMinuteTicks(dc, _layout["minuteTickPoints"],
                                MINUTE_TICK_PEN_WIDTH, _currentProfile);
    _faceDrawer.drawNumbers(dc, _layout["numberX"], _layout["numberY"],
                            _layout["numberText"], _currentProfile);

    if (_showBackgroundImage) {
      _logger.debug(
          "AnalogView",
          "drawStaticElements _showBackgroundImage: " + _showBackgroundImage +
              " _backgroundImage width: " + _backgroundImage.getWidth() +
              " height: " + _backgroundImage.getHeight());
      drawBitMap(dc, _backgroundImage);
    }
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

    _handDrawer.drawHands(dc, clockTime, _layout, _currentProfile,
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
    _logger.debug("AnalogView", "firmwareversion: " + ds.firmwareVersion);
    _logger.debug("AnalogView",
                  "Screen: " + ds.screenWidth + "x" + ds.screenHeight);
    _logger.debug("AnalogView", "API: " + ds.monkeyVersion.toString());

    _logger.debug("AnalogView", "uniqueIdentifier: " + ds.uniqueIdentifier);

    if (ds has: heightUnits) {
      _logger.debug("AnalogView", "heightUnits: " + ds.heightUnits.toString());
    }

    if (ds has: inputButtons) {
      _logger.debug("AnalogView",
                    "inputButtons: " +
                        ViewUtil.inputButtonsToString(ds.inputButtons));
    }

    if (ds has: isEnhancedReadabilityModeEnabled) {
      _logger.debug("AnalogView",
                    "isEnhancedReadabilityModeEnabled: " +
                        ds.isEnhancedReadabilityModeEnabled.toString());
    }

    if (ds has: isGlanceModeEnabled) {

      _logger.debug("AnalogView", "isGlanceModeEnabled: " +
                                      ds.isGlanceModeEnabled.toString());
    }

    if (ds has: isTouchScreen) {
      _logger.debug("AnalogView",
                    "isTouchScreen: " + ds.isTouchScreen.toString());
    }

    if (ds has: paceUnits) {
      _logger.debug("AnalogView", "paceUnits: " + ds.paceUnits.toString());
    }

    if (ds has: phoneOperatingSystem) {
      _logger.debug("AnalogView", "phoneOperatingSystem: " +
                                      ViewUtil.phoneOperatingSystemToString(
                                          ds.phoneOperatingSystem));
    }

    if (ds has: requiresBurnInProtection) {
      _logger.debug("AnalogView",
                    "requiresBurnInProtection: " + ds.requiresBurnInProtection);
    }

    if (ds has: screenShape) {
      _logger.debug("AnalogView",
                    "screenShape: " +
                        ViewUtil.screenShapeToString(ds.screenShape));
    }

    if (DRAG_TYPE_START has: vibrateOn) {
      _logger.debug("AnalogView", "vibrateOn: " + ds.vibrateOn);
    }
  }
}

function getAnalogView() as AnalogView { return AnalogView.getInstance(); }