import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'my_stateful_text_field.dart';

import '../ffi.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _binaryString = '';
  String _binaryDisplayString = '';
  int _numberOfBits = 0;
  int _numberOfBytes = 0;
  String _hexString = '';
  String _hexDisplayString = '';
  int _prependedZeros = 0;

  Future<void> _callFfiBinToHex(String value) async {
    setState(() {
      _hexString = '';
      _hexDisplayString = '';
      _binaryString = value;
      _binaryDisplayString = '';
      _numberOfBits = value.length;
      _prependedZeros = 0;
      int modulo = _numberOfBits % 8;
      if (modulo != 0) {
        _prependedZeros = 8 - modulo;
        _numberOfBytes = _numberOfBits ~/ 8 + 1;
        _binaryString = _binaryString.padLeft((8 * _numberOfBytes), "0");
      } else {
        _numberOfBytes = _numberOfBits ~/ 8;
      }
    });

    // Make API call to RUST library
    String receivedText = '';
    String substr = '';
    bool prependBlankBin = false;
    bool prependBlankHex = false;
    for (int i = 0; i < _numberOfBytes; i++) {
      substr = _binaryString.substring(i * 8, (i + 1) * 8);

      if (prependBlankBin) {
        _binaryDisplayString = "$_binaryDisplayString\t\t$substr";
      } else {
        _binaryDisplayString = "$_binaryDisplayString$substr";
        prependBlankBin = true;
      }
      if ((i + 1) % 8 == 0) {
        _binaryDisplayString = "$_binaryDisplayString\n";
        prependBlankBin = false;
      }

      receivedText = await api.binToHex(val: substr, len: 1);
      setState(() {
        _hexString = "$_hexString$receivedText";
        if (prependBlankHex) {
          _hexDisplayString = "$_hexDisplayString\t\t$receivedText";
        } else {
          _hexDisplayString = "$_hexDisplayString$receivedText";
          prependBlankHex = true;
        }
        if ((i + 1) % 4 == 0) {
          _hexDisplayString = "$_hexDisplayString\n";
          prependBlankHex = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      width: 340,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 5),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                height: 24,
                child: Text(
                  'Included Rust Libraries',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'iota_sdk:',
                      ),
                    ),
                    Text("v1.1.3"),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'iota_stronghold:',
                      ),
                    ),
                    Text("v2.0.0"),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'identity_iota:',
                      ),
                    ),
                    Text("v1.0.0"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Open About Dialog
                  showDialog(
                    context: context,
                    builder: (context) => const AboutDialog(
                      applicationIcon: Image(
                        image: AssetImage('assets/images/smr-64.png'),
                      ),
                      applicationLegalese: 'Legalese',
                      applicationName: 'Stardust Playground',
                      applicationVersion: '0.1.0',
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Text(
                            """
              Author: Kai Müller, 
              Twitter: @dj_kaiota
              
              Used Icons: 
              1. Blockchain icon created by Triangle Squad - Flaticon: "https://www.flaticon.com/free-icons/blockchain" 
              2. Crypto icon created by Triangle Squad - Flaticon: https://www.flaticon.com/free-icons/crypto 
              3. Smart contract icon created by Freepik - Flaticon: https://www.flaticon.com/free-icons/smart-contracts 
              4. Crypto wallet icon created by juicy_fish - Flaticon: https://www.flaticon.com/free-icons/crypto-wallet 
              5. Identity icon created by Smashicons - Flaticon: https://www.flaticon.com/free-icons/identity
              """,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.info,
                    size: 32,
                  ),
                  title: Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                height: 24,
                child: Text(
                  'Binary to Hex Converter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MyStatefulTextField(
                  "",
                  6,
                  false,
                  _callFfiBinToHex,
                  buttonLabel: "Convert",
                  isButtonBelow: true,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 1),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 54,
                      child: Text(
                        'Bits:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                          "$_numberOfBits \t\t->\t\tnumber of prepended \"0\"s:\t\t$_prependedZeros"),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 54,
                      child: Text(
                        '-> Input:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(_binaryDisplayString),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 54,
                      child: Text(
                        'Bytes:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text("$_numberOfBytes"),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 54,
                      child: GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: _hexString));
                          // copied successfully
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Output was copied to clipboard")));
                        },
                        child: const Text(
                          'Hex: (0x)',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        _hexDisplayString,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
