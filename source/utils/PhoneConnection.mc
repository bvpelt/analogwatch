using Toybox.Lang;

class PhoneConnection {
  private static var _instance as PhoneConnection?;

  // Known status levels
  enum {
    STATUS_DISCONNECTED = 0,
    STATUS_CONNECTING = 1,
    STATUS_CONNECTED = 2,
  }

  private var _connectionStatus as Lang.Number;

  // Get singleton instance
  static function getInstance() as PhoneConnection {
    if (_instance == null) {
      _instance = new PhoneConnection();
    }
    return _instance;
  }

  // Private constructor
  private function initialize() { _connectionStatus = STATUS_CONNECTED; }

  public function updateConnectionStatus(status) { _connectionStatus = status; }

  function getConnectionStatus() { return _connectionStatus; }
}

// Global convenience function
function getPhoneConnection() as PhoneConnection {
  return PhoneConnection.getInstance();
}
