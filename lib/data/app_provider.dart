import 'package:flutter/material.dart';

import '../models/network.dart';
import 'store_preference.dart';
import 'constants.dart';

class AppProvider with ChangeNotifier {
  AppProvider() {
    loadPreferenceData();
  }

  final List<Network> _networks = NetworkList.networks;
  int _networkId = 0;
  String _nodeInfo = '';
  String _mnemonic = '';
  String _lastAddress = '';
  int _balanceTotal = 0;
  int _balanceAvailable = 0;

  StorePreference preferences = StorePreference();
  void loadPreferenceData() async {
    //print('Load Preferences');
    _networkId = await preferences.getNetworkId();
    _nodeInfo = await preferences.getNodeInfo();
    _mnemonic = await preferences.getMnemonic();
    _lastAddress = await preferences.getLastAddress();
  }

  int get networkId => _networkId;

  set networkId(int value) {
    _networkId = value;
    preferences.setNetworkId(_networkId);
    notifyListeners();
  }

  String get nodeInfo => _nodeInfo;

  set nodeInfo(String value) {
    _nodeInfo = value;
    preferences.setNodeInfo(_nodeInfo);
    notifyListeners();
  }

  String get mnemonic => _mnemonic;

  set mnemonic(String value) {
    _mnemonic = value;
    preferences.setMnemonic(_mnemonic);
    notifyListeners();
  }

  String get lastAddress => _lastAddress;

  set lastAddress(String value) {
    _lastAddress = value;
    preferences.setLastAddress(_lastAddress);
    notifyListeners();
  }

  List<Network> get networks {
    return [..._networks];
  }

  Network get currentNetwork {
    final int index =
        _networks.indexWhere((element) => element.id == _networkId);
    Network result = _networks[0];
    if (index > 0) {
      result = _networks[index];
    }
    return result;
  }

  void addNetwork(Network network) {
    _networks.add(network);
    notifyListeners();
  }

  int get balanceTotal => _balanceTotal;

  set balanceTotal(int value) {
    _balanceTotal = value;
    notifyListeners();
  }

  int get balanceAvailable => _balanceAvailable;

  set balanceAvailable(int value) {
    _balanceAvailable = value;
    notifyListeners();
  }
}
