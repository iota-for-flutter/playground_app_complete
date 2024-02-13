import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../data/app_provider.dart';
import '../models/example_step.dart';
import '../theme/custom_overlay.dart';
import '../widgets/example_stepper_framework.dart';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import '../ffi.dart';

class Example4 extends StatefulWidget {
  const Example4({super.key, required this.title});

  final String title;

  @override
  State<Example4> createState() => _Example4State();
}

class _Example4State extends State<Example4> {
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
        """Please enter the ADDRESS. 
Click on the button "Execute" to take over the input value and "Continue" to go to the next step.""",
        _executeStepIndex0,
      ),
      ExampleStep(
        'Step 2',
        """Click on the button "Execute" to request funds for the given address (see Input).
        
On Shimmer TESTNET, you can check the balance here: https://explorer.shimmer.network/testnet        
        """,
        _executeStepIndex1,
      ),
    ];

    exampleSteps[0]
        .setInput(Provider.of<AppProvider>(context, listen: false).lastAddress);
    exampleSteps[0].setInputEditable(true);
  }

  void _executeStepIndex0() {
    setState(() {
      exampleSteps[0].setOutput(exampleSteps[0].input ?? '');
      exampleSteps[1].setInput(exampleSteps[0].output ?? '');
    });
  }

  void _executeStepIndex1() {
    _callFfiRequestFunds();
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

  Future<void> _callFfiRequestFunds() async {
    String nodeUrl =
        Provider.of<AppProvider>(context, listen: false).currentNetwork.url;
    String faucetUrl = Provider.of<AppProvider>(context, listen: false)
            .currentNetwork
            .faucetApiUrl ??
        '';
    final NetworkInfo networkInfo =
        NetworkInfo(nodeUrl: nodeUrl, faucetUrl: faucetUrl);
    final WalletInfo walletInfo = WalletInfo(
      alias: "",
      mnemonic: "",
      strongholdPassword: "",
      strongholdFilepath: _strongholdFilePath,
      lastAddress: Provider.of<AppProvider>(context, listen: false).lastAddress,
    );

    try {
      customOverlay.show(context);

      final receivedText = await api.requestFunds(
          networkInfo: networkInfo, walletInfo: walletInfo);
      if (mounted) {
        setState(() => exampleSteps[1].setOutput(receivedText));
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
