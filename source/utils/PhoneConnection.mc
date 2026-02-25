using Toybox.Lang;

class PhoneConnection {
  private static var _instance as PhoneConnection?;

  // Get singleton instance
  static function getInstance() as PhoneConnection {
    if (_instance == null) {
      _instance = new PhoneConnection();
    }
    return _instance;
  }

  // Private constructor
  private function initialize() {}

  function getConnectionStatus() {
    return System.getDeviceSettings().phoneConnected;
  }
}

// Global convenience function
function getPhoneConnection() as PhoneConnection {
  return PhoneConnection.getInstance();
}
