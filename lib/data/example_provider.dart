import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../examples/example_0.dart';
import '../examples/example_1.dart';
import '../examples/example_2.dart';
import '../examples/example_3.dart';
import '../examples/example_4.dart';
import '../examples/example_5.dart';
import '../examples/example_6.dart';
import '../models/example_model.dart';
import '../theme/custom_colors.dart';

class ExampleProvider extends InheritedWidget {
  ExampleProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  final childBeamerKey = GlobalKey<BeamerState>();

  final examples = [
    ExampleModel(
      id: 0,
      title: "Get Node Information",
      shortDescription: "Returns general information about the node.",
      description: """
You can access all the features of the iota.rs library using an instance of the Client class. The Client class provides high-level abstraction to all interactions over IOTA network (Tangle). You have to instantiate this class before you start any interactions with the library, or more precisely with the IOTA nodes that power IOTA network.

The example will:

- Create a Client which connects to a node (by default to the Shimmer Testnet).
- Use the created client to get some information about the node.
""",
      library: "iota.rs",
      level: "Entry",
      category: Category(
        icon: Icons.apple,
        iconPath: 'assets/icons/blockchain-64.png',
        name: 'Core',
        backgroundColor: CustomColors.paleGold,
      ),
      getExample: () {
        return const Example0(
          title: 'Generate Mnemonic',
        );
      },
      arrayOfDoubles: [],
      additionalTextField: "",
    ),
    ExampleModel(
      id: 1,
      title: "Generate Mnemonic",
      shortDescription: "Use iota.rs to call generateMnemonic.",
      description: """
The example will generate a mnemonic using a Client instance. Since this functionality doesn't need to communicate with any nodes, you can start your Client in offline mode.

The example will:

1. Create a Client in offline mode.
2. Use the created client to generate a mnemonic.
""",
      library: "iota.rs",
      level: "Entry",
      category: Category(
        icon: FontAwesomeIcons.google,
        iconPath: 'assets/icons/blockchain-64.png',
        name: 'Core',
        backgroundColor: CustomColors.paleGold,
      ),
      getExample: () {
        return const Example1(
          title: 'Generate Mnemonic',
        );
      },
      arrayOfDoubles: [120, 250],
      additionalTextField: "24hr",
    ),
    ExampleModel(
      id: 2,
      title: "Create Wallet Account",
      shortDescription: "Use wallet.rs to create an account.",
      description: """
In wallet.rs, you can use an account model to create an account for each user or use one account and generate multiple addresses, which you can then link to the users in your database. The wallet library is as flexible as possible and can back up any of your use cases.

The example will:

1. Summarize the node url and mnemonic from the app preferences.
2. Enter the account alias.
3. Enter a stronghold password and a file location to create a StrongholdSecretManager.
4. Create an AccountManager.
5. Use the mnemonic and store it in stronghold (the first time).
6. Create a Wallet Account for a given alias. The alias is a human readable account name.
""",
      library: "wallet.rs",
      level: "Mid",
      category: Category(
        icon: Icons.apple,
        iconPath: 'assets/icons/wallet-64.png',
        name: 'Wallet',
        backgroundColor: CustomColors.paleBlue,
      ),
      getExample: () {
        return const Example2(
          title: 'Create Wallet Account',
        );
      },
      arrayOfDoubles: [],
      additionalTextField: "",
    ),

    ExampleModel(
      id: 3,
      title: "Generate Address",
      shortDescription: "Use wallet.rs to generate an address.",
      description: """
You can generate an address using the account created in the example above.

The example will:

1. Create the Account Manager.
2. Get the Account from the Alias we created in the last example.
3. Set the Stronghold Password.
4. Generate and return an address in Bech32 format.
""",
      library: "wallet.rs",
      level: "Entry",
      category: Category(
        icon: Icons.apple,
        iconPath: 'assets/icons/wallet-64.png',
        name: 'Wallet',
        backgroundColor: CustomColors.paleBlue,
      ),
      getExample: () {
        return const Example3(
          title: 'Generate Address',
        );
      },
      arrayOfDoubles: [],
      additionalTextField: "",
    ),

    ExampleModel(
      id: 4,
      title: "Request Funds",
      shortDescription:
          "Use iota.rs to request funds\nfrom Shimmer Testnet Faucet.",
      description: """
You can request some funds for the generated address, using the faucet. YOU WILL NOT RECEIVE REAL COINS!

The example will:

1. Let you check the address (Bech32 format).
2. Request the funds from the Faucet API URL.
""",
      library: "iota.rs",
      level: "Entry",
      category: Category(
        icon: Icons.apple,
        iconPath: 'assets/icons/wallet-64.png',
        name: 'Wallet',
        backgroundColor: CustomColors.paleBlue,
      ),
      getExample: () {
        return const Example4(
          title: 'Request Funds',
        );
      },
      arrayOfDoubles: [],
      additionalTextField: "",
    ),

    ExampleModel(
      id: 5,
      title: "Check Balance",
      shortDescription:
          "Use wallet.rs to check the balance\nof the Wallet Account.",
      description: """
You can check the balance for the given Alias. In Shimmer TESTNET these are NO REAL COINS!

The example will:

1. Let you check the Alias.
2. Check the balance.
""",
      library: "wallet.rs",
      level: "Entry",
      category: Category(
        icon: Icons.apple,
        iconPath: 'assets/icons/wallet-64.png',
        name: 'Wallet',
        backgroundColor: CustomColors.paleBlue,
      ),
      getExample: () {
        return const Example5(
          title: 'Check Balance',
        );
      },
      arrayOfDoubles: [],
      additionalTextField: "",
    ),

//     ExampleModel(
//       id: 4,
//       title: "Get Outputs",
//       shortDescription: "Find an output, as JSON, by its identifier.",
//       description: """
// You can get outputs by their output ID using the Client.get_output(output_id) function.

// The example will:

// 1. Create a Client which will connect to the Shimmer Testnet.
// 2. Get an output by its output ID.
// """,
//       library: "iota.rs",
//       level: "Entry",
//       category: Category(
//         icon: FontAwesomeIcons.facebook,
//         iconPath: 'assets/icons/blockchain-64.png',
//         name: 'Core',
//         backgroundColor: CustomColors.paleGold,
//       ),
//       getExample: () {
//         return const CoreExample1(
//           title: 'Generate Mnemonic',
//         );
//       },
//       arrayOfDoubles: [250, 300],
//       additionalTextField: "30days",
//     ),
    ExampleModel(
      id: 6,
      title: "Create a Decentralized Identity",
      shortDescription: "Core about identity creation and publishing.",
      description: """
Identity Generation Process

1. The generation of an identity requires a address with funds to cover the Storage Deposit. Here, the requested funds are used.
2. Create the content of the DID Document, a minimal document contains one verification method.
3. Construct a new Alias Output that includes the DID Document in the State Metadata.
4. Publish the generated Alias Output.

The DID is only known once the Alias Output is successfully published, since the DID's Tag contains the Alias ID.

""",
      library: "identity.rs",
      level: "Mid",
      category: Category(
        icon: FontAwesomeIcons.google,
        iconPath: 'assets/icons/id-card-64.png',
        name: 'Identity',
        backgroundColor: CustomColors.paleViolet,
      ),
      getExample: () {
        return const Example6(
          title: 'Create and publish DID',
        );
      },
      arrayOfDoubles: [],
      additionalTextField: "",
    ),
  ];

  static ExampleProvider of(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<ExampleProvider>()!
        .widget as ExampleProvider;
  }

  @override
  bool updateShouldNotify(ExampleProvider oldWidget) {
    return false;
  }
}
