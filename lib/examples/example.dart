import 'package:flutter/material.dart';

import '../models/example_step.dart';
import '../widgets/example_stepper_framework.dart';

class CoreExample1 extends StatefulWidget {
  const CoreExample1({super.key, required this.title});

  final String title;

  @override
  State<CoreExample1> createState() => _CoreExample1State();
}

class _CoreExample1State extends State<CoreExample1> {
  // These variables belong to the state and are only initialized once,
  // in the initState method.
  late List<ExampleStep> exampleSteps;

  //------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    exampleSteps = [
      ExampleStep(
        'Step 1',
        'At first, you will call the api.generateMnemonic() to illustrate the usage of the API.',
        _executeResetValues,
      ),
      ExampleStep(
        'Step 2',
        'Info Step 2',
        _executeStepIndex1,
      ),
      ExampleStep(
        'Step 3',
        'Info Step 3',
        _executeStepIndex2,
      ),
      ExampleStep(
        'Step 4',
        'Info Step 4',
        _executeStepIndex3,
      ),
    ];

    // Initialize Example
    exampleSteps[3].setInputEditable(true);
  }

  // Future<void> _callbackFfiGreet() async {
  //   final receivedText = await api.greet();
  //   if (mounted) setState(() => _ffiGreetText = receivedText);
  // }
  void _executeResetValues() {
    setState(() {
      exampleSteps[2].setInput('');
      exampleSteps[2].setOutput('');
      exampleSteps[3].setInput('');
      exampleSteps[3].setOutput('');
    });
  }

  void _executeStepIndex1() {
    setState(() {
      exampleSteps[1].setOutput('Result of Step 2');
      exampleSteps[2].setInput('Result of Step 2');
    });
  }

  void _executeStepIndex2() {
    setState(() {
      exampleSteps[2].setOutput('Result of Step 3');
      exampleSteps[3].setInput('Result of Step 3');
    });
  }

  void _executeStepIndex3() {
    setState(() {
      exampleSteps[3].setOutput('Result of Step 4');
    });
  }

  //------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ExampleStepperFramework(
      exampleSteps: exampleSteps,
    );
  }
}
