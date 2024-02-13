class ExampleStep {
  final String title;
  final String information;
  Function executeCallback;
  String? input;
  String? output;
  bool inputEditable = false;

  ExampleStep(
    this.title,
    this.information,
    this.executeCallback,
  );

  void setInput(String inputValue) {
    input = inputValue;
  }

  void setInputEditable(bool editable) {
    inputEditable = editable;
  }

  void setOutput(String outputValue) {
    output = outputValue;
  }
}
