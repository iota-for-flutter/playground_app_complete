import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../models/example_model.dart';
import '../theme/custom_colors.dart';
import '../extensions.dart';

import 'example_avatar.dart';

class ExampleList extends StatelessWidget {
  const ExampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final examples = context.provider.examples;

    return ListView.builder(
      itemCount: examples.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (c, index) => ExampleCard(
        model: examples[index],
      ),
    );
  }
}

class ExampleCard extends StatelessWidget {
  const ExampleCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ExampleModel model;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        //Perform navigation to the detail screen regardless of screen size
        context.isLargeScreen
            // Use the nested Beamer to navigate
            // to the correct detail page for large screen
            ? context.provider.childBeamerKey.currentState?.routerDelegate
                .beamToNamed('/${model.id}')
            : context.beamToNamed('/${model.id}');
      },
      child: AnimatedBuilder(
          animation: context.isLargeScreen
              ? context.provider.childBeamerKey.currentState!.routerDelegate
              // Prevent unneccessary build when in small screen mode
              : Listenable.merge([]),
          builder: (context, _) {
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(-3, 2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    color: Colors.grey[200]!,
                  )
                ],
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: _isSelected(context)
                      ? CustomColors.lightGreen
                      : Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ExampleAvatar(category: model.category),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                model.title,
                                style: textTheme.titleLarge,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              //"\$${model.salaryRange[0]} - ${model.salaryRange[1]}K/${model.shortDescription}",
                              model.shortDescription,
                              style: textTheme.bodyMedium!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                          runSpacing: 4.0,
                          spacing: 4.0,
                          children: [
                            _buildChip(context, model.category.name,
                                color: Colors.grey[200]),
                            _buildChip(context, model.library,
                                color: Colors.grey[200])
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }

  bool _isSelected(BuildContext context) {
    if (!context.isLargeScreen) return false;

    final params = (context.provider.childBeamerKey.currentState
            ?.currentBeamLocation.state as BeamState)
        .pathParameters;

    return params['id'] == model.id.toString();
  }

  Widget _buildChip(
    BuildContext context,
    String text, {
    Color? color,
    double? horizontalPad,
    FontWeight? fontWeight,
  }) =>
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          padding:
              EdgeInsets.symmetric(vertical: 4, horizontal: horizontalPad ?? 8),
          alignment: Alignment.center,
          child: Text(
            text,
            style: Theme.of(context).chipTheme.labelStyle!.copyWith(
                  fontWeight: fontWeight,
                ),
          ),
        ),
      );
}
