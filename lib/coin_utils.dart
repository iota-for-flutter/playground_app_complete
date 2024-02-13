import 'package:intl/intl.dart';

String displayBalance(int receivedBalance, String coinCurrency) {
  double totalDouble = receivedBalance / 1000000;
  String totalString =
      NumberFormat.simpleCurrency(name: '$coinCurrency ', decimalDigits: 6)
          .format(totalDouble);
  return totalString;
}
