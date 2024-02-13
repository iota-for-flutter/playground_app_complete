import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_provider.dart';
import '../models/network.dart';
import '../theme/custom_colors.dart';
import '../widgets/my_stateful_text_field.dart';

import '../coin_utils.dart';
import '../extensions.dart';

class MyEndDrawer extends StatefulWidget {
  const MyEndDrawer({super.key});

  @override
  State<MyEndDrawer> createState() => _MyEndDrawerState();
}

class _MyEndDrawerState extends State<MyEndDrawer> {
  late List<Network> _networks;
  late List<DropdownMenuItem<int>> _items;
  late int _networkId;
  String _nodeInfo = '';
  String _mnemonic = '';
  String _lastAddress = '';
  int _balanceTotal = 0;
  int _balanceAvailable = 0;

  @override
  void initState() {
    super.initState();
  }

  void _selectNetwork(int? selectedId) {
    if (selectedId is int) {
      setState(() {
        Provider.of<AppProvider>(context, listen: false).networkId = selectedId;
        _networkId = selectedId;
        Provider.of<AppProvider>(context, listen: false).nodeInfo = '';
        _nodeInfo = '';
      });
    }
  }

  void _updateMnemonic(String value) {
    Provider.of<AppProvider>(context, listen: false).mnemonic = value;
    setState(() {
      _mnemonic = value;
    });
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _networks = Provider.of<AppProvider>(context).networks;
      _networkId = Provider.of<AppProvider>(context).networkId;
      _nodeInfo = Provider.of<AppProvider>(context).nodeInfo;
      _mnemonic = Provider.of<AppProvider>(context).mnemonic;
      _lastAddress = Provider.of<AppProvider>(context).lastAddress;
      _balanceTotal = Provider.of<AppProvider>(context).balanceTotal;
      _balanceAvailable = Provider.of<AppProvider>(context).balanceAvailable;
      _items = [];
      for (var element in _networks) {
        _items.add(DropdownMenuItem<int>(
          value: element.id,
          child: Text(element.name),
        ));
      }
    });
    Network currentNetwork = Provider.of<AppProvider>(context).currentNetwork;
    bool hasNodeInfo = _nodeInfo != '';
    bool hasLastAddress = _lastAddress != '';
    String coinCurrency =
        Provider.of<AppProvider>(context, listen: false).currentNetwork.coin;
    String totalString = displayBalance(_balanceTotal, coinCurrency);
    String availableString = displayBalance(_balanceAvailable, coinCurrency);

    double drawerWidth = 600;
    if (context.isVeryLargeScreen) {
      drawerWidth = 900;
    } else if (context.isLargeScreen) {
      drawerWidth = 700;
    }

    return Drawer(
      elevation: 0,
      width: drawerWidth,
      //backgroundColor: Colors.grey[300],
      child: SafeArea(
        child: Theme(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stored information',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      GestureDetector(
                        onTap: _closeEndDrawer,
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  height: 31,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 0),
                        height: 24,
                        child: Text(
                          'Network',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      DropdownButton(
                        items: _items,
                        value: _networkId,
                        onChanged: _selectNetwork,
                        isExpanded: true,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'Node URL:',
                              // style: TextStyle(
                              //   fontWeight: FontWeight.w600,
                              // ),
                            ),
                          ),
                          Text(currentNetwork.url),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'Type:',
                              // style: TextStyle(fontWeight: FontWeight.w600,),
                            ),
                          ),
                          Text(currentNetwork.networkType.value),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'Currency:',
                              // style: TextStyle(fontWeight: FontWeight.w600,),
                            ),
                          ),
                          Text(currentNetwork.coin),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'Faucet API:',

                              // style: TextStyle(fontWeight: FontWeight.w600,),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              currentNetwork.faucetApiUrl ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (hasNodeInfo)
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          height: 24,
                          child: Text(
                            'Node information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      if (hasNodeInfo)
                        Text(
                          _nodeInfo,
                        ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        height: 24,
                        child: Text(
                          'Mnemonic',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      MyStatefulTextField(
                        _mnemonic,
                        6,
                        true,
                        _updateMnemonic,
                      ),
                      if (hasLastAddress)
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          height: 24,
                          child: Text(
                            'Last Address',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      if (hasLastAddress)
                        Text(
                          _lastAddress,
                        ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        height: 24,
                        child: Text(
                          'Balance',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'Total:',
                              // style: TextStyle(fontWeight: FontWeight.w600,),
                            ),
                          ),
                          Text(totalString),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'Available:',
                              // style: TextStyle(fontWeight: FontWeight.w600,),
                            ),
                          ),
                          Text(availableString),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: _closeEndDrawer,
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
