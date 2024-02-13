import 'coin_type_enum.dart';
import 'network_type_enum.dart';

class Network {
  final int id;
  final String name;
  final String url;
  final NetworkType networkType; // Use "networkType.value"
  final String coin; // e.g. "RMS" (inverse "SMR") for Shimmer TESTNET
  final CoinType
      coinType; // BIP44 Coin Type; Use "coinType.value" for int value
  String faucetUrl = ''; // optional
  String? faucetApiUrl = ''; // optional
  String mqttStream = ''; // optional

  Network(
    this.id,
    this.name,
    this.url,
    this.networkType,
    this.coin,
    this.coinType, {
    faucetUrl,
    this.faucetApiUrl,
    mqttStream,
  });
}
