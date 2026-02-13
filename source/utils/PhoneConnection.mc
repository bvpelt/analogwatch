using Toybox.Lang;

class PhoneConnection {
  private static var _instance as PhoneConnection?;

  var _deviceSettings = null;

  // Get singleton instance
  static function getInstance() as PhoneConnection {
    if (_instance == null) {
      _instance = new PhoneConnection();
    }
    return _instance;
  }

  // Private constructor
  private function initialize() {
    _deviceSettings = System.getDeviceSettings();
  }

  function getConnectionStatus() {
    if (_deviceSettings == null) {
      return false;
    }

    return _deviceSettings.phoneConnected;
  }
}

// Global convenience function
function getPhoneConnection() as PhoneConnection {
  return PhoneConnection.getInstance();
}
