// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.6.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

abstract class Rust {
  Future<String> getNodeInfo({required NetworkInfo networkInfo, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetNodeInfoConstMeta;

  Future<String> generateMnemonic({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGenerateMnemonicConstMeta;

  Future<String> createWalletAccount(
      {required NetworkInfo networkInfo,
      required WalletInfo walletInfo,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kCreateWalletAccountConstMeta;

  Future<String> generateAddress(
      {required WalletInfo walletInfo, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGenerateAddressConstMeta;

  Future<String> requestFunds(
      {required NetworkInfo networkInfo,
      required WalletInfo walletInfo,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kRequestFundsConstMeta;

  Future<BaseCoinBalance> checkBalance(
      {required WalletInfo walletInfo, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kCheckBalanceConstMeta;

  Future<String> createDecentralizedIdentifier(
      {required NetworkInfo networkInfo,
      required WalletInfo walletInfo,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kCreateDecentralizedIdentifierConstMeta;

  Future<String> binToHex(
      {required String val, required int len, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBinToHexConstMeta;
}

class BaseCoinBalance {
  /// Total amount
  final int total;

  /// Balance that can currently be spent
  final int available;

  const BaseCoinBalance({
    required this.total,
    required this.available,
  });
}

class NetworkInfo {
  final String nodeUrl;
  final String faucetUrl;

  const NetworkInfo({
    required this.nodeUrl,
    required this.faucetUrl,
  });
}

class WalletInfo {
  final String alias;
  final String mnemonic;
  final String strongholdPassword;
  final String strongholdFilepath;
  final String lastAddress;

  const WalletInfo({
    required this.alias,
    required this.mnemonic,
    required this.strongholdPassword,
    required this.strongholdFilepath,
    required this.lastAddress,
  });
}