using Toybox.Lang;

class ProfileFactory {
  static const PROFILE_CLASSIC = 0;
  static const PROFILE_BLUE_STEEL = 1;
  static const PROFILE_BLUE = 2;
  static const PROFILE_ORANGE = 3;
  static const PROFILE_WHITE = 4;
  static const PROFILE_WHITISH = 5;
  static const PROFILE_BLACK = 6;
  static const PROFILE_CUSTOM = 7;

  static function createProfile(profileId as Lang.Number) as ColorProfile {
    var profile;

    if (profileId == PROFILE_CLASSIC) {
      profile = new ClassicProfile();
    } else if (profileId == PROFILE_BLUE_STEEL) {
      profile = new BlueSteelProfile();
    } else if (profileId == PROFILE_BLUE) {
      profile = new BlueProfile();
    } else if (profileId == PROFILE_ORANGE) {
      profile = new OrangeProfile();
    } else if (profileId == PROFILE_WHITE) {
      profile = new WhiteProfile();
    } else if (profileId == PROFILE_WHITISH) {
      profile = new WhitishProfile();
    } else if (profileId == PROFILE_BLACK) {
      profile = new BlackProfile();
    } else if (profileId == PROFILE_CUSTOM) {
      profile = new CustomProfile();
    } else {
      profile = new ClassicProfile(); // Default
    }

    return profile;
  }
}