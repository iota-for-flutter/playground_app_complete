import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import './models/example_model.dart';
import './widgets/example_detail.dart';

import '/extensions.dart';
import '/main.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    ExampleModel? example;

    // Try to get the job with the [id] passed from the route path
    try {
      example = context.provider.examples.firstWhere(
          (element) => element.id.toString() == state.pathParameters['id']);
    } catch (e) {
      log(e.toString());
    }

    return [
      /// Always have the [MyHomePage] in the stack of pages
      const BeamPage(
        key: ValueKey('home'),
        title: "Home",
        name: '/',
        child: MyHomePage(
          currentIndex: 0,
        ),
      ),

      /// Only show the detail page over the [MyHomePage] when on a small screen and
      //a job id is passed alongside the URI. Note that [MyHomePage] is configured to be responsive.
      if (!context.isLargeScreen && state.pathParameters.containsKey('id'))
        BeamPage(
          key: ValueKey('example-${example!.id}'),
          title: "${example.category.name} - ${example.title}",

          /// The URL path to navigate to this page, the [id] is a placeholder for the actual job id to be passed
          name: '/:id',
          child: ExampleDetailWidget(
            model: example,
          ),
        ),
    ];
  }

  /// This is where you indicate the URI patterns that can be handled by this [BeamLocation]
  @override
  List<Pattern> get pathPatterns => ['/:id'];
}

/// InnerJobLocation defines a nested navigator. It determines the current detail screen
/// that is navigated to when the app is displayed on a large screen.
/// => ON LARGE SCREENS: LOOKUP DETAIL PAGE
class InnerJobLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    ExampleModel? example;

    try {
      example = context.provider.examples.firstWhere(
          (element) => element.id.toString() == state.pathParameters['id']);
    } catch (e) {
      example = context.provider.examples.first;
    }

    return [
      if (state.pathParameters.containsKey('id'))
        BeamPage(
          key: ValueKey('example-${example.id}'),
          title: "${example.category.name} - ${example.title}",
          name: '/:id',
          child: ExampleDetailWidget(
            model: example,
          ),
        )
      else
        BeamPage(
          key: ValueKey('example-${example.id}'),
          title: "${example.category.name} - ${example.title}",
          name: '/0',
          child: ExampleDetailWidget(
            model: example,
          ),
        ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/:id'];
}
