import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data/app_provider.dart';
import './data/example_provider.dart';
import './theme/custom_colors.dart';
import './widgets/example_list.dart';
import './widgets/my_drawer.dart';
import './widgets/my_end_drawer.dart';

import './beamer_locations.dart';
import './extensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppProvider appProvider;

  // Initialise the BeamerDelegate
  final routerDelegate = BeamerDelegate(
    locationBuilder: (routeInformation, _) {
      return HomeLocation();
    },
  );

  @override
  void initState() {
    super.initState();
    //print("Init AppProvider");
    appProvider = AppProvider();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => appProvider,
      child: ExampleProvider(
        child: LayoutBuilder(builder: (context, constraint) {
          return MaterialApp.router(
            title: 'Playground',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.blue,
                chipTheme: const ChipThemeData(
                    labelStyle: TextStyle(
                  fontSize: 11,
                )),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  elevation: 1.0,
                  iconTheme: IconThemeData(color: Colors.black),
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textTheme: const TextTheme(
                  titleLarge: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  bodyLarge: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  bodyMedium: TextStyle(
                    fontWeight: FontWeight.w400,
                    //color: Color(0xff5656565),
                    fontSize: 12,
                  ),
                )),
            routeInformationParser: BeamerParser(),
            routerDelegate: routerDelegate,
            backButtonDispatcher:
                BeamerBackButtonDispatcher(delegate: routerDelegate),
          );
        }),
      ),
    );
  }
}

/// Design inspired by this deisgn https://dribbble.com/shots/17092342-Job-Finder-App
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final innerRouterDelegate = BeamerDelegate(
    transitionDelegate: const NoAnimationTransitionDelegate(),
    locationBuilder: (routeInformation, _) {
      return InnerJobLocation();
    },
  );

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Stardust Playground",
          style: TextStyle(
              color: CustomColors.iotaGreen,
              fontSize: 20,
              letterSpacing: 1,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  _key.currentState!.openEndDrawer();
                },
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: CustomColors.shimmerGreen,
                  backgroundImage: AssetImage('assets/images/smr-64.png'),
                ),
              ),
            ),
          )
        ],
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      drawer: const MyDrawer(),
      endDrawer: const MyEndDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (!context.isLargeScreen) {
            // ON SMALL SCREENS: Return only the JobList widget
            return const ExampleList();
          } else {
            // for extremely large screens introduce extra margin
            final horizontalMargin =
                context.isVeryLargeScreen ? constraints.maxWidth * .1 : 0.0;

            final listviewMaxWidth =
                constraints.maxWidth * (context.isVeryLargeScreen ? 0.3 : 0.4);
            final detailMaxWidth =
                constraints.maxWidth * (context.isVeryLargeScreen ? 0.5 : 0.6);

            // Return a master-detail widget view
            return Container(
              color: Colors.white70,
              // Add a horizontal margin for the largest screen size
              margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Display the [ExampleList] on the left pane and constrain its width
                  SizedBox(width: listviewMaxWidth, child: const ExampleList()),

                  /// Use a nested Router
                  SizedBox(
                    width: detailMaxWidth,

                    /// By using the [Beamer] widget, we add a nested Router
                    child: Beamer(
                      /// Pass in the [childBeamerKey] instantiated in the [AppProvider] class
                      key: context.provider.childBeamerKey,

                      /// Pass a routerDelegate that uses the [InnerJobLocations]
                      routerDelegate: innerRouterDelegate,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
