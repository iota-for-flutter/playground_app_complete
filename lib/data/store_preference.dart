import 'package:shared_preferences/shared_preferences.dart';

class StorePreference {
  static const _networkId = "NETWORKID";
  static const _nodeInfo = "NODEINFO";
  static const _mnemonic = "MNEMONIC";
  static const _lastAddress = "LASTADDRESS";

  setNetworkId(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_networkId, value);
  }

  Future<int> getNetworkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int result = prefs.getInt(_networkId) ?? 0;
    return result;
  }

  setNodeInfo(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_nodeInfo, value);
  }

  Future<String> getNodeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(_nodeInfo) ?? '';
    return result;
  }

  setMnemonic(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_mnemonic, value);
  }

  Future<String> getMnemonic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(_mnemonic) ?? '';
    return result;
  }

  setLastAddress(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_lastAddress, value);
  }

  Future<String> getLastAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(_lastAddress) ?? '';
    return result;
  }
}
