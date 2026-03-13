using Toybox.Lang;

class ClassicProfile extends ColorProfile {
  function initialize() {
    ColorProfile.initialize();
    handbgcolor = 0xffb400;
    handfgcolor = 0x960200;
    secondfgcolor = handbgcolor;
    facebgcolor = handfgcolor;
    facebordercolor = facebgcolor;
    handcentercolor = handbgcolor;
    daybgcolor = handfgcolor;
    daynamecolor = handbgcolor;
    daynumbercolor = handbgcolor;
    dayoutlinecolor = handbgcolor;
    hourmarkercolor = handcentercolor;
    minutetickcolor = handcentercolor;
    numbercolor = handcentercolor;
    batteryfull = handbgcolor;
    batteryempty = handfgcolor;
    datafieldcolor = handcentercolor;
    bluethootactivecolor = 0x00ff00;
    bluethootinactivecolor = 0xff0000;
  }

  function getName() as Lang.String { return "Classic"; }
}

class BlueSteelProfile extends ColorProfile {
  function initialize() {
    ColorProfile.initialize();
    handbgcolor = 0xffffff;
    handfgcolor = 0x61a40;
    secondfgcolor = 0xff0000;
    facebgcolor = handfgcolor;
    facebordercolor = facebgcolor;
    handcentercolor = handbgcolor;
    daybgcolor = handfgcolor;
    daynamecolor = handbgcolor;
    daynumbercolor = handbgcolor;
    dayoutlinecolor = handfgcolor;
    hourmarkercolor = handbgcolor;
    minutetickcolor = handbgcolor;
    numbercolor = handbgcolor;
    batteryfull = 0x26a924;
    batteryempty = 0xff0000;
    datafieldcolor = batteryfull;
    bluethootactivecolor = 0x00ff00;
    bluethootinactivecolor = 0xff0000;
  }

  function getName() as Lang.String { return "Blue Steel"; }
}

class BlueProfile extends ColorProfile {
  function initialize() {
    ColorProfile.initialize();
    handbgcolor = 0xffffff;
    handfgcolor = 0x0353a4;
    secondfgcolor = handbgcolor;
    facebgcolor = handfgcolor;
    facebordercolor = facebgcolor;
    handcentercolor = handbgcolor;
    daybgcolor = handfgcolor;
    daynamecolor = handbgcolor;
    daynumbercolor = handbgcolor;
    dayoutlinecolor = handfgcolor;
    hourmarkercolor = handbgcolor;
    minutetickcolor = handbgcolor;
    numbercolor = handbgcolor;
    batteryfull = 0x26a924;
    batteryempty = 0xff0000;
    datafieldcolor = batteryfull;
    bluethootactivecolor = 0x00ff00;
    bluethootinactivecolor = 0xff0000;
  }

  function getName() as Lang.String { return "Blue"; }
}

class OrangeProfile extends ColorProfile {
  function initialize() {
    ColorProfile.initialize();
    handbgcolor = 0x000000;
    handfgcolor = 0xffb400;
    secondfgcolor = handbgcolor;
    facebgcolor = handfgcolor;
    facebordercolor = facebgcolor;
    handcentercolor = handbgcolor;
    daybgcolor = handfgcolor;
    daynamecolor = handbgcolor;
    daynumbercolor = handbgcolor;
    dayoutlinecolor = handfgcolor;
    hourmarkercolor = handbgcolor;
    minutetickcolor = handbgcolor;
    numbercolor = handbgcolor;
    batteryfull = 0x26a924;
    batteryempty = handbgcolor;
    datafieldcolor = batteryfull;
    bluethootactivecolor = 0x00ff00;
    bluethootinactivecolor = 0xff0000;
  }

  function getName() as Lang.String { return "Orange"; }
}

class WhiteProfile extends ColorProfile {
  function initialize() {
    ColorProfile.initialize();
    handbgcolor = 0x000000;
    handfgcolor = 0xffffff;
    secondfgcolor = handbgcolor;
    facebgcolor = handfgcolor;
    facebordercolor = facebgcolor;
    handcentercolor = handbgcolor;
    daybgcolor = handfgcolor;
    daynamecolor = handbgcolor;
    daynumbercolor = handbgcolor;
    dayoutlinecolor = handbgcolor;
    hourmarkercolor = handbgcolor;
    minutetickcolor = handbgcolor;
    numbercolor = handbgcolor;
    batteryfull = 0x26a924;
    batteryempty = 0xff0000;
    datafieldcolor = batteryfull;
    bluethootactivecolor = 0x00ff00;
    bluethootinactivecolor = 0xff0000;
  }

  function getName() as Lang.String { return "White"; }
}

class WhitishProfile extends ColorProfile {
  function initialize() {
    ColorProfile.initialize();
    handbgcolor = 0x000000;
    handfgcolor = 0xffffff;
    secondfgcolor = handbgcolor;
    facebgcolor = 0xe2f3e4;
    facebordercolor = handbgcolor;
    handcentercolor = handbgcolor;
    daybgcolor = facebgcolor;
    daynamecolor = handbgcolor;
    daynumbercolor = handbgcolor;
    dayoutlinecolor = facebgcolor;
    hourmarkercolor = 0x061a40;
    minutetickcolor = handbgcolor;
    numbercolor = handbgcolor;
    batteryfull = 0x26a924;
    batteryempty = 0xff0000;
    datafieldcolor = 0xb20a1b;
    bluethootactivecolor = 0x00ff00;
    bluethootinactivecolor = 0xff0000;
  }

  function getName() as Lang.String { return "Whitish"; }
}

class BlackProfile extends ColorProfile {
  function initialize() {
    ColorProfile.initialize();
    handbgcolor = 0x000000;
    handfgcolor = 0xffffff;
    secondfgcolor = handfgcolor;
    facebgcolor = handbgcolor;
    facebordercolor = facebgcolor;
    handcentercolor = handfgcolor;
    daybgcolor = handbgcolor;
    daynamecolor = handfgcolor;
    daynumbercolor = handfgcolor;
    dayoutlinecolor = handbgcolor;
    hourmarkercolor = handfgcolor;
    minutetickcolor = handfgcolor;
    numbercolor = handfgcolor;
    batteryfull = 0x26a924;
    batteryempty = 0xff0000;
    datafieldcolor = batteryfull;
    bluethootactivecolor = 0x00ff00;
    bluethootinactivecolor = 0xff0000;
  }

  function getName() as Lang.String { return "Black"; }
}

class CustomProfile extends ColorProfile {
  private var _propertieUtility;

  function initialize() {
    ColorProfile.initialize();
    _propertieUtility = getPropertieUtility();
    loadFromProperties();
  }

  function loadFromProperties() as Void {
    handbgcolor = _propertieUtility.getPropertyNumber("HandBgColor", 0x504949);
    handfgcolor = _propertieUtility.getPropertyNumber("HandFgColor", 0xff0000);
    secondfgcolor =
        _propertieUtility.getPropertyNumber("SecondFgColor", 0x504949);
    facebgcolor = _propertieUtility.getPropertyNumber("FaceBgColor", 0x000000);
    facebordercolor =
        _propertieUtility.getPropertyNumber("FaceBorderColor", 0xc0c0c0);
    handcentercolor =
        _propertieUtility.getPropertyNumber("HandCenterColor", 0xff0000);
    daybgcolor = _propertieUtility.getPropertyNumber("DayBgColor", 0x000000);
    daynamecolor =
        _propertieUtility.getPropertyNumber("DayNameColor", 0xff3333);
    daynumbercolor =
        _propertieUtility.getPropertyNumber("DayNumberColor", 0xa0a0a0);
    dayoutlinecolor =
        _propertieUtility.getPropertyNumber("DayOutlineColor", 0xc0c0c0);
    hourmarkercolor =
        _propertieUtility.getPropertyNumber("HourMarkerColor", 0xffffff);
    minutetickcolor =
        _propertieUtility.getPropertyNumber("MinuteTickColor", 0xa0a0a0);
    numbercolor = _propertieUtility.getPropertyNumber("NumberColor", 0xffffff);
    batteryfull =
        _propertieUtility.getPropertyNumber("BatteryFullColor", 0x26a924);
    batteryempty =
        _propertieUtility.getPropertyNumber("BatteryEmptyColor", 0xff0000);
    datafieldcolor =
        _propertieUtility.getPropertyNumber("DataFieldColor", 0xff0000);
    bluethootactivecolor =
        _propertieUtility.getPropertyNumber("BlueToothActiveColor", 0x00ff00);
    bluethootinactivecolor =
        _propertieUtility.getPropertyNumber("BlueToothInActiveColor", 0xff0000);
  }

  function getName() as Lang.String { return "Custom"; }
}