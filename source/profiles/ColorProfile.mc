using Toybox.Lang;

// Base class for all color profiles
class ColorProfile {
  public var handbgcolor as Lang.Number;
  public var handfgcolor as Lang.Number;
  public var handcentercolor as Lang.Number;
  public var secondfgcolor as Lang.Number;
  public var facebgcolor as Lang.Number;
  public var facebordercolor as Lang.Number;
  public var daybgcolor as Lang.Number;
  public var daynamecolor as Lang.Number;
  public var daynumbercolor as Lang.Number;
  public var dayoutlinecolor as Lang.Number;
  public var hourmarkercolor as Lang.Number;
  public var minutetickcolor as Lang.Number;
  public var numbercolor as Lang.Number;
  public var batteryfull as Lang.Number;
  public var batteryempty as Lang.Number;
  public var datafieldcolor as Lang.Number;
  public var bluethootactivecolor as Lang.Number;
  public var bluethootinactivecolor as Lang.Number;

  function initialize() {
    // Default values
    handbgcolor = 0x000000;
    handfgcolor = 0xffffff;
    handcentercolor = 0xffffff;
    secondfgcolor = 0x000000;
    facebgcolor = 0x000000;
    facebordercolor = 0xffffff;
    daybgcolor = 0x000000;
    daynamecolor = 0xffffff;
    daynumbercolor = 0xffffff;
    dayoutlinecolor = 0xffffff;
    hourmarkercolor = 0xffffff;
    minutetickcolor = 0xffffff;
    numbercolor = 0xffffff;
    batteryfull = 0x26a924;
    batteryempty = 0xff0000;
    datafieldcolor = 0xffffff;
    bluethootactivecolor = 0x00ff00;
    bluethootinactivecolor = 0xff0000;
  }

  function getName() as Lang.String { return "Base"; }

  function toDictionary() as Lang.Dictionary {
    return { "HandBgColor" => handbgcolor,
             "HandFgColor" => handfgcolor,
             "SecondFgColor" => secondfgcolor,
             "FaceBgColor" => facebgcolor,
             "FaceBorderColor" => facebordercolor,
             "HandCenterColor" => handcentercolor,
             "DayBgColor" => daybgcolor,
             "DayNameColor" => daynamecolor,
             "DayNumberColor" => daynumbercolor,
             "DayOutlineColor" => dayoutlinecolor,
             "HourMarkerColor" => hourmarkercolor,
             "MinuteTickColor" => minutetickcolor,
             "NumberColor" => numbercolor,
             "BatteryFullColor" => batteryfull,
             "BatteryEmptyColor" => batteryempty,
             "DataFieldColor" => datafieldcolor,
             "BlueToothActiveColor" => bluethootactivecolor,
             "BlueToothInActiveColor" => bluethootinactivecolor };
  }

  function applyFromDictionary(dict as Lang.Dictionary) as Void {
    handbgcolor = dict.get("HandBgColor") as Lang.Number;
    handfgcolor = dict.get("HandFgColor") as Lang.Number;
    secondfgcolor = dict.get("SecondFgColor") as Lang.Number;
    facebgcolor = dict.get("FaceBgColor") as Lang.Number;
    facebordercolor = dict.get("FaceBorderColor") as Lang.Number;
    handcentercolor = dict.get("HandCenterColor") as Lang.Number;
    daybgcolor = dict.get("DayBgColor") as Lang.Number;
    daynamecolor = dict.get("DayNameColor") as Lang.Number;
    daynumbercolor = dict.get("DayNumberColor") as Lang.Number;
    dayoutlinecolor = dict.get("DayOutlineColor") as Lang.Number;
    hourmarkercolor = dict.get("HourMarkerColor") as Lang.Number;
    minutetickcolor = dict.get("MinuteTickColor") as Lang.Number;
    numbercolor = dict.get("NumberColor") as Lang.Number;
    batteryfull = dict.get("BatteryFullColor") as Lang.Number;
    batteryempty = dict.get("BatteryEmptyColor") as Lang.Number;
    datafieldcolor = dict.get("DataFieldColor") as Lang.Number;
    bluethootactivecolor = dict.get("BlueToothActiveColor") as Lang.Number;
    bluethootinactivecolor = dict.get("BlueToothInActiveColor") as Lang.Number;
  }
}