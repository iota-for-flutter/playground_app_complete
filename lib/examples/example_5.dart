import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/example_step.dart';
import '../theme/custom_overlay.dart';
import '../widgets/example_stepper_framework.dart';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:provider/provider.dart';
import '../coin_utils.dart';
import '../data/app_provider.dart';
import '../ffi.dart';

class Example5 extends StatefulWidget {
  const Example5({super.key, required this.title});

  final String title;

  @override
  State<Example5> createState() => _Example5State();
}

class _Example5State extends State<Example5> {
  // These variables belong to the state and are only initialized once,
  // in the initState method.
  late List<ExampleStep> exampleSteps;
  CustomOverlay customOverlay = CustomOverlay();

  //------------------------------------------------------------------------------
  String _strongholdFilePath = '';

  @override
  void initState() {
    super.initState();

    _getStrongholdFilePath();
    // platform = api.platform();
    // isRelease = api.rustReleaseMode();

    exampleSteps = [
      ExampleStep(
        'Step 1',
        """Please enter the ALIAS. 
Click on the button "Execute" to take over the input value and "Continue" to go to the next step.""",
        _executeStepIndex0,
      ),
      ExampleStep(
        'Step 2',
        """Click on the button "Execute" to check the balance for the Wallet Account Alias (see Input).      
        """,
        _executeStepIndex1,
      ),
    ];

    exampleSteps[0].input = 'Account_1';
    exampleSteps[0].setInputEditable(true);
  }

  void _executeStepIndex0() {
    setState(() {
      exampleSteps[0].setOutput(exampleSteps[0].input ?? '');
      exampleSteps[1].setInput(exampleSteps[0].output ?? '');
    });
  }

  void _executeStepIndex1() {
    _callFfiCheckBalance();
  }

  Future<void> _getStrongholdFilePath() async {
    final Directory appSupportDir = await getApplicationSupportDirectory();

    final Directory appSupportDirStrongholdFolder =
        Directory('${appSupportDir.path}/');
    setState(() {
      _strongholdFilePath = appSupportDirStrongholdFolder.path;
    });

    //print("_strongholdFilePath is $_strongholdFilePath");
  }

  Future<void> _callFfiCheckBalance() async {
    String coinCurrency =
        Provider.of<AppProvider>(context, listen: false).currentNetwork.coin;
    final WalletInfo walletInfo = WalletInfo(
      alias: exampleSteps[0].output ?? 'Account_1',
      mnemonic: "",
      strongholdPassword: "",
      strongholdFilepath: _strongholdFilePath,
      lastAddress: Provider.of<AppProvider>(context, listen: false).lastAddress,
    );

    try {
      customOverlay.show(context);

      final receivedBaseCoinBalance =
          await api.checkBalance(walletInfo: walletInfo);
      if (mounted) {
        String totalString =
            displayBalance(receivedBaseCoinBalance.total, coinCurrency);
        String availableString =
            displayBalance(receivedBaseCoinBalance.available, coinCurrency);
        String result =
            'Total:         $totalString\nAvailable:  $availableString';
        setState(() {
          exampleSteps[1].setOutput(result);
          Provider.of<AppProvider>(context, listen: false).balanceTotal =
              receivedBaseCoinBalance.total;
          Provider.of<AppProvider>(context, listen: false).balanceAvailable =
              receivedBaseCoinBalance.available;
        });
      }
      customOverlay.hide();
    } on FfiException catch (e) {
      customOverlay.hide();
      setState(() => exampleSteps[1].setOutput(e.message));
    }
  }

  //------------------------------------------------------------------------------
  @override
  void dispose() {
    customOverlay.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleStepperFramework(
      exampleSteps: exampleSteps,
    );
  }
}
