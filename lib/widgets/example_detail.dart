import 'package:flutter/material.dart';

import '../models/example_model.dart';
import '../theme/custom_colors.dart';

import '../extensions.dart';

class ExampleDetailWidget extends StatelessWidget {
  const ExampleDetailWidget({Key? key, required this.model}) : super(key: key);

  final ExampleModel model;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: context.isLargeScreen
          ? null
          : AppBar(
              title: Text(
                model.title,
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //_InfoWidget(model: model),
            if (context.isLargeScreen)
              Padding(
                padding: const EdgeInsets.all(24).copyWith(top: 20),
                child: Text(
                  model.title,
                  style: textTheme.headlineSmall,
                ),
              ),
            if (!context.isLargeScreen)
              const SizedBox(
                height: 8,
              ),
            Container(
              margin: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 24,
              ),
              padding: const EdgeInsets.all(0),
              decoration: boxDecoration,
              child: model.getExample(),
            ),
            Padding(
              padding: const EdgeInsets.all(24).copyWith(top: 5),
              child: Text(
                "Description",
                style: textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Text(
                model.description,
                style: textTheme.bodyMedium,
              ),
            ),
            _AdditionalInfoWidget(model: model),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

// class _InfoWidget extends StatelessWidget {
//   const _InfoWidget({
//     Key? key,
//     required this.model,
//   }) : super(key: key);

//   final ExampleModel model;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Stack(
//         children: [
//           Container(
//             decoration: boxDecoration,
//             padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.only(top: 36),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 14),
//                 // Text(
//                 //   "${model.title}\n",
//                 //   style: const TextStyle(
//                 //     fontWeight: FontWeight.bold,
//                 //     fontSize: 16,
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           model.shortDescription,
//                           style: const TextStyle(
//                             fontSize: 13,
//                           ),
//                         ),
//                         //Text(model.category.name),
//                         // ...[dot, Text(model.category.iconPath), dot],
//                         // Text(model.postedDate),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _AdditionalInfoWidget extends StatelessWidget {
  const _AdditionalInfoWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ExampleModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // _buildBenefit(
          //   context,
          //   benefitCaption: "Salary",
          //   benefit: "\$${model.salaryRange[0]} - ${model.salaryRange[1]}K",
          //   color: CustomColors.shimmerGreen,
          //   iconData: Icons.monetization_on_outlined,
          // ),
          _buildBenefit(
            context,
            benefitCaption: "Used Library",
            benefit: model.library,
            color: CustomColors.shimmerGreen,
            iconData: Icons.source,
          ),
          _buildBenefit(
            context,
            benefitCaption: "Level",
            benefit: model.level,
            color: CustomColors.paleBlue,
            iconData: Icons.accessibility_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(
    BuildContext context, {
    required String benefitCaption,
    required String benefit,
    required Color color,
    required IconData iconData,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Icon(iconData, size: 20, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Text(benefitCaption, style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(benefit, style: textTheme.bodyLarge!.copyWith(fontSize: 12)),
      ],
    );
  }
}

var boxDecoration = BoxDecoration(
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
  // gradient: LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Colors.white,
  //     Colors.grey.shade100,
  //   ],
  // ),
);
