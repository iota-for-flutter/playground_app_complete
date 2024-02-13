// https://wiki.iota.org/shimmer/iota.rs/libraries/nodejs/references/enums/CoinType
// e.g. "CoinType.iota.index" returns 0
// https://tech-lead.medium.com/advanced-enums-in-flutter-a8f2e2702ffd
enum CoinType {
  iota(4218),
  shimmer(4219);

  // can add more properties or getters/methods if needed
  final int value;

  // can use named parameters if you want
  const CoinType(this.value);
}
