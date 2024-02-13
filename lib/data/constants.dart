// Set the common device dimensions here
import '../models/coin_type_enum.dart';
import '../models/network.dart';
import '../models/network_type_enum.dart';

const mobileWidth = 1023;
const tabletWidth = 1299;

class NetworkList {
  static List<Network> networks = [
    // see: https://blog.shimmer.network/shimmer-beta-network-is-live/
    Network(
      0,
      "Official Shimmer Testnet",
      'https://api.testnet.shimmer.network',
      NetworkType.testnet,
      'SMR',
      CoinType.shimmer,
      faucetApiUrl: 'https://faucet.testnet.shimmer.network/api/enqueue',
      faucetUrl: 'https://faucet.testnet.shimmer.network',
      mqttStream: 'wss://api.testnet.shimmer.network:443/api/mqtt/v1',
    ),
  ];
}
