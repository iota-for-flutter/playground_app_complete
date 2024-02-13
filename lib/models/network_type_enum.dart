// https://wiki.iota.org/shimmer/iota.rs/libraries/nodejs/references/enums/Network
// e.g. "NetworkType.mainnet.index" returns 0
// https://tech-lead.medium.com/advanced-enums-in-flutter-a8f2e2702ffd
enum NetworkType {
  mainnet("Mainnet"),
  testnet("Testnet");

  // can add more properties or getters/methods if needed
  final String value;

  // can use named parameters if you want
  const NetworkType(this.value);
}
