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

class Example6 extends StatefulWidget {
  const Example6({super.key, required this.title});

  final String title;

  @override
  State<Example6> createState() => _Example6State();
}

class _Example6State extends State<Example6> {
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

    exampleSteps = [
      ExampleStep(
        'Step 1',
        """This example uses the last stored ADDRESS which you can see as Input. 

Click on the button "Execute" to process all steps to create a DID.

MAKE SURE THAT THERE WERE FUNDS REQUESTED FOR THIS SPECIFIC ADDRESS !!!""",
        _executeStepIndex0,
      ),
    ];

    exampleSteps[0].input =
        Provider.of<AppProvider>(context, listen: false).lastAddress;
  }

  void _executeStepIndex0() {
    _callFfiCreateDecentralizedIdentifier();
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

  Future<void> _callFfiCreateDecentralizedIdentifier() async {
    String nodeUrl =
        Provider.of<AppProvider>(context, listen: false).currentNetwork.url;
    final NetworkInfo networkInfo =
        NetworkInfo(nodeUrl: nodeUrl, faucetUrl: '');
    final WalletInfo walletInfo = WalletInfo(
      alias: "",
      mnemonic: "",
      strongholdPassword: 'my_super_secret_stronghold_password',
      strongholdFilepath: _strongholdFilePath,
      lastAddress: Provider.of<AppProvider>(context, listen: false).lastAddress,
    );

    try {
      customOverlay.show(context);

      final receivedText = await api.createDecentralizedIdentifier(
          networkInfo: networkInfo, walletInfo: walletInfo);
      if (mounted) {
        setState(() {
          exampleSteps[0].setOutput(receivedText);
        });
      }
      customOverlay.hide();
    } on FfiException catch (e) {
      customOverlay.hide();
      setState(() => exampleSteps[0].setOutput(e.message));
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
