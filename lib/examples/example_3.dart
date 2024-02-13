import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../data/app_provider.dart';
import '../models/example_step.dart';
import '../models/network.dart';
import '../theme/custom_overlay.dart';
import '../widgets/example_stepper_framework.dart';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import '../ffi.dart';

class Example3 extends StatefulWidget {
  const Example3({super.key, required this.title});

  final String title;

  @override
  State<Example3> createState() => _Example3State();
}

class _Example3State extends State<Example3> {
  // These variables belong to the state and are only initialized once,
  // in the initState method.
  late List<ExampleStep> exampleSteps;

  //------------------------------------------------------------------------------
  String _strongholdFilePath = '';
  CustomOverlay customOverlay = CustomOverlay();

  @override
  void initState() {
    super.initState();

    _getStrongholdFilePath();

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

- Create the Account Manager.
- Get the Account from the Alias we created in the last example.
- Set the Stronghold Password.
- Generate and return an address in Bech32 format.
    """,
        _executeStepIndex3,
      ),
    ];

    exampleSteps[0].setOutput('');
    exampleSteps[1].setInputEditable(true);
    exampleSteps[2].setInputEditable(true);
  }

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
    _callFfiGenerateAddress();
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

  Future<void> _callFfiGenerateAddress() async {
    final WalletInfo walletInfo = WalletInfo(
      alias: exampleSteps[1].output ?? 'Account_1',
      mnemonic: Provider.of<AppProvider>(context, listen: false).mnemonic,
      strongholdPassword:
          exampleSteps[2].output ?? 'my_super_secret_stronghold_password',
      strongholdFilepath: _strongholdFilePath,
      lastAddress: Provider.of<AppProvider>(context, listen: false).lastAddress,
    );
    try {
      customOverlay.show(context);

      final receivedText = await api.generateAddress(walletInfo: walletInfo);
      if (mounted) {
        setState(() {
          Provider.of<AppProvider>(context, listen: false).lastAddress =
              receivedText;
          exampleSteps[3].setOutput(receivedText);
        });
      }
      customOverlay.hide();
    } on FfiException catch (e) {
      customOverlay.hide();
      setState(() => exampleSteps[3].setOutput(e.message));
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
