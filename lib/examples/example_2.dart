import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../data/app_provider.dart';
import '../models/example_step.dart';
import '../models/network.dart';
import '../theme/custom_overlay.dart';
import '../widgets/example_stepper_framework.dart';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import '../ffi.dart';

class Example2 extends StatefulWidget {
  const Example2({super.key, required this.title});

  final String title;

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  // These variables belong to the state and are only initialized once,
  // in the initState method.
  late List<ExampleStep> exampleSteps;
  CustomOverlay customOverlay = CustomOverlay();

  //------------------------------------------------------------------------------
  String _strongholdFilePath = '';

  @override
  void initState() {
    super.initState();

    _getStrongholdFilePath("stronghold", "walletdb");

    exampleSteps = [
      ExampleStep(
        'Step 1',
        """Please verify the stored NODE URL and the MNEMONIC. If ok, click on the button "Execute".

Then, click "Continue" to go to the next step.""",
        _executeResetValues,
      ),
      ExampleStep(
        'Step 2',
        """Please enter the ACCOUNT ALIAS. 
Click on the button "Execute" to take over the input value and "Continue" to go to the next step.""",
        _executeStepIndex1,
      ),
      ExampleStep(
        'Step 3',
        """Please enter the STRONGHOLD PASSWORD. 
Click on the button "Execute" to take over the input value and "Continue" to go to the next step.""",
        _executeStepIndex2,
      ),
      ExampleStep(
        'Step 4',
        """Click on the button "Execute" to: 
- Create an Account Manager. 
- Create a Stronghold Secret Manager.
- Store the Mnemonic in the Stronghold vault.
- Create an Account for the Alias.""",
        _executeStepIndex3,
      ),
    ];

    exampleSteps[0].setOutput('');
    exampleSteps[1].setInputEditable(true);
    exampleSteps[2].setInputEditable(true);
  }

  // Future<void> _callbackFfiGreet() async {
  //   final receivedText = await api.greet();
  //   if (mounted) setState(() => _ffiGreetText = receivedText);
  // }
  void _executeResetValues() {
    setState(() {
      exampleSteps[0].setOutput(exampleSteps[0].input ?? '');
      exampleSteps[1].input = 'Account_1';
      exampleSteps[1].setOutput('');
      exampleSteps[2].input = 'my_super_secret_stronghold_password';
      exampleSteps[2].setOutput('');
    });
  }

  void _executeStepIndex1() {
    exampleSteps[1].setOutput(exampleSteps[1].input ?? 'Account_1');
  }

  void _executeStepIndex2() {
    exampleSteps[2].setOutput(
        exampleSteps[2].input ?? 'my_super_secret_stronghold_password');
  }

  void _executeStepIndex3() {
    _callFfiCreateWalletAccount();
  }

  Future<void> _getStrongholdFilePath(
      String strongholdFolder, String rocksdbFolder) async {
    final Directory appSupportDir = await getApplicationSupportDirectory();

    // Create the Stronghold folder and take over the path
    final Directory appSupportDirStrongholdFolder =
        Directory('${appSupportDir.path}/');
    setState(() {
      _strongholdFilePath = appSupportDirStrongholdFolder.path;
    });
    //print("_strongholdFilePath is $_strongholdFilePath");
  }

  Future<void> _callFfiCreateWalletAccount() async {
    String nodeUrl =
        Provider.of<AppProvider>(context, listen: false).currentNetwork.url;
    String faucetUrl = Provider.of<AppProvider>(context, listen: false)
            .currentNetwork
            .faucetApiUrl ??
        '';
    final NetworkInfo networkInfo =
        NetworkInfo(nodeUrl: nodeUrl, faucetUrl: faucetUrl);
    final WalletInfo walletInfo = WalletInfo(
      alias: exampleSteps[1].output ?? 'Account_1',
      mnemonic: Provider.of<AppProvider>(context, listen: false).mnemonic,
      strongholdPassword:
          exampleSteps[2].output ?? 'my_super_secret_stronghold_password',
      strongholdFilepath: _strongholdFilePath,
      lastAddress: "",
    );
    try {
      customOverlay.show(context);

      final receivedText = await api.createWalletAccount(
          networkInfo: networkInfo, walletInfo: walletInfo);
      if (mounted) {
        setState(() => exampleSteps[3].setOutput(receivedText));
      }
      customOverlay.hide();
    } on FfiException catch (e) {
      setState(() => exampleSteps[3].setOutput(e.message));
      customOverlay.hide();
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
    Network currentNetwork = Provider.of<AppProvider>(context).currentNetwork;
    String mnemonic = Provider.of<AppProvider>(context).mnemonic;
    exampleSteps[0].input =
        'Node: ${currentNetwork.name} \nURL:   ${currentNetwork.url} \n\nMnemonic:\n$mnemonic ';
    return ExampleStepperFramework(
      exampleSteps: exampleSteps,
    );
  }
}
