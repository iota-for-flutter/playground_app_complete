import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class MyStatefulTextField extends StatefulWidget {
  final String initialText;
  final int maxLines;
  final bool forceButtonActive;
  final Function callback;
  final String buttonLabel;
  final bool isButtonBelow;

  const MyStatefulTextField(
    this.initialText,
    this.maxLines,
    this.forceButtonActive,
    this.callback, {
    super.key,
    this.buttonLabel = 'Update',
    this.isButtonBelow = false,
  });

  @override
  State<MyStatefulTextField> createState() => _MyStatefulTextFieldState();
}

class _MyStatefulTextFieldState extends State<MyStatefulTextField> {
  late TextEditingController textController;
  bool isButtonActive = false;

  late String _currentText;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentText = widget.initialText;
    });
    textController = TextEditingController(text: _currentText);
    textController.addListener(() {
      final isButtonActive = textController.text.isNotEmpty;
      setState(() {
        this.isButtonActive = isButtonActive || widget.forceButtonActive;
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isButtonBelow) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(fontSize: 14),
              controller: textController,
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                hintText: 'Insert a new input value',
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CustomColors.shimmerGreen,
                    width: 0.0,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              onSubmitted: (value) {
                if (textController.text != '') {
                  widget.callback(textController.text);
                }
              },
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            ElevatedButton(
              onPressed: isButtonActive
                  ? () {
                      if (textController.text != '' ||
                          widget.forceButtonActive) {
                        widget.callback(textController.text);
                      }
                    }
                  : null,
              child: Text(widget.buttonLabel),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(fontSize: 14),
                controller: textController,
                maxLines: widget.maxLines,
                decoration: InputDecoration(
                  hintText: 'Insert a new input value',
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomColors.shimmerGreen,
                      width: 0.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      textController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                onSubmitted: (value) {
                  if (textController.text != '') {
                    widget.callback(textController.text);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            ElevatedButton(
              onPressed: isButtonActive
                  ? () {
                      if (textController.text != '' ||
                          widget.forceButtonActive) {
                        widget.callback(textController.text);
                      }
                    }
                  : null,
              child: Text(widget.buttonLabel),
            ),
          ],
        ),
      );
    }
  }
}
