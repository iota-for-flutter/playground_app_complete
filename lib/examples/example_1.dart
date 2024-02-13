import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_provider.dart';
import '../models/example_step.dart';
import '../theme/custom_overlay.dart';
import '../widgets/example_stepper_framework.dart';

import '../ffi.dart';

class Example1 extends StatefulWidget {
  const Example1({super.key, required this.title});

  final String title;

  @override
  State<Example1> createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  // These variables belong to the state and are only initialized once,
  // in the initState method.
  late List<ExampleStep> exampleSteps;
  CustomOverlay customOverlay = CustomOverlay();

  //------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    exampleSteps = [
      ExampleStep(
        'Step 1',
        """To reset the stored mnemonic, 
click on the button "Execute".""",
        _executeResetValues,
      ),
      ExampleStep(
        'Step 2',
        """Click on the button "Execute" to:
- Create a Client in offline mode and generate a mnemonic. 
- Store the mnemonic in the preferences.""",
        _executeStepIndex1,
      ),
    ];
  }

  void _executeResetValues() {
    setState(() {
      Provider.of<AppProvider>(context, listen: false).mnemonic = '';
      exampleSteps[1].setInput('');
      exampleSteps[1].setOutput('');
    });
  }

  void _executeStepIndex1() {
    _callFfiGenerateMnemonic();
  }

  Future<void> _callFfiGenerateMnemonic() async {
    customOverlay.show(context);
    final receivedText = await api.generateMnemonic();
    if (mounted) {
      setState(() {
        Provider.of<AppProvider>(context, listen: false).mnemonic =
            receivedText;
        exampleSteps[1].setOutput(receivedText);
      });
    }
    customOverlay.hide();
  }

  //------------------------------------------------------------------------------
  @override
  void dispose() {
    customOverlay.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    exampleSteps[0].input = Provider.of<AppProvider>(context).mnemonic;
    return ExampleStepperFramework(
      exampleSteps: exampleSteps,
    );
  }
}
