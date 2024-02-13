import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './my_stateful_text_field.dart';

import '../models/example_step.dart';
import '../theme/custom_colors.dart';

class ExampleStepperFramework extends StatefulWidget {
  const ExampleStepperFramework({super.key, required this.exampleSteps});

  final List<ExampleStep> exampleSteps;

  @override
  State<ExampleStepperFramework> createState() =>
      _ExampleStepperFrameworkState();
}

class _ExampleStepperFrameworkState extends State<ExampleStepperFramework> {
  int currentStep = 0;
  int lastExecutedStep = -1;
  bool canContinue = false;

  List<Step> steps() {
    List<Step> resultingList = [];

    int index = 0;
    for (ExampleStep exampleStep in widget.exampleSteps) {
      bool hasInput = exampleStep.input != null && exampleStep.input != '';
      String inputValue = exampleStep.input ?? '';

      bool hasOutput = exampleStep.output != null && exampleStep.output != '';
      bool showTextField = exampleStep.inputEditable;

      resultingList.add(
        Step(
          isActive: lastExecutedStep >= index,
          title: Text(exampleStep.title),
          content: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exampleStep.information),
                const Divider(
                  thickness: 1,
                  color: CustomColors.shimmerGreen,
                ),
                if (showTextField)
                  const SizedBox(
                    height: 20,
                  ),
                if (showTextField)
                  Row(
                    children: [
                      Expanded(
                        child: MyStatefulTextField(inputValue, 1, false,
                            (String value) {
                          setState(() {
                            exampleStep.setInput(value);
                          });
                        }),
                      ),
                    ],
                  ),
                if (hasInput)
                  const SizedBox(
                    height: 15,
                  ),
                if (hasInput)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 55,
                        child: GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: exampleStep.input ?? ''));
                            // copied successfully
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Input was copied to clipboard")));
                          },
                          child: const Text(
                            'Input:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text('${exampleStep.input}'),
                      ),
                    ],
                  ),
                if (hasOutput)
                  const SizedBox(
                    height: 20,
                  ),
                if (hasOutput)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 55,
                        child: GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: exampleStep.output ?? ''));
                            // copied successfully
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Output was copied to clipboard")));
                          },
                          child: const Text(
                            'Output:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text('${exampleStep.output}'),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      );
      index++;
    }

    return resultingList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: CustomColors.shimmerGreen,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.shimmerGreen,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.normal),
                  padding: const EdgeInsets.all(18.0),
                ),
              ),
            ),
            child: Stepper(
              physics:
                  const ClampingScrollPhysics(), // to make content of stepper scrollable
              currentStep: currentStep,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, //MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Execute'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (currentStep < widget.exampleSteps.length - 1)
                      ElevatedButton(
                        onPressed: canContinue ? details.onStepContinue : null,
                        child: const Text('Continue'),
                      ),
                  ],
                );
              },
              onStepTapped: (index) {
                if (index > lastExecutedStep) return;
                setState(() {
                  currentStep = index;
                });
              },
              onStepContinue: (() {
                setState(() {
                  if (currentStep != widget.exampleSteps.length - 1) {
                    currentStep++;
                    if (currentStep > lastExecutedStep) {
                      canContinue = false;
                    }
                  }
                });
              }),
              onStepCancel: (() {
                // Excecute Button
                widget.exampleSteps[currentStep].executeCallback();
                setState(() {
                  lastExecutedStep = currentStep;
                  canContinue = true;
                });
              }),
              steps: steps(),
            ),
          ),
        ],
      ),
    );
  }
}
