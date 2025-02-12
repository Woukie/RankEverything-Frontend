import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_everything/src/dashboard/thing.dart';
import 'package:rank_everything/src/dashboard/thing_provider.dart';

class ThingResults extends StatelessWidget {
  const ThingResults({
    super.key,
    required this.thing,
    required this.selected,
    required this.top,
  });

  final Thing? thing;
  final bool selected, top;

  @override
  Widget build(BuildContext context) {
    ThingProvider thingProvider = Provider.of<ThingProvider>(context);

    return Align(
      alignment: top ? Alignment.topCenter : Alignment.bottomCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ));
        },
        child: !selected
            ? const SizedBox(height: 1, width: 1)
            : Padding(
                padding: const EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withAlpha(150),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Builder(builder: (context) {
                          Thing? otherthing = !top
                              ? thingProvider.thing1
                              : thingProvider.thing2;

                          num totalLikability = otherthing!.getPercentage() +
                              thing!.getPercentage();
                          var bigText = Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold);

                          double likeability = totalLikability == 0
                              ? 0
                              : thing!.getPercentage() / totalLikability;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(12),
                                minHeight: 24,
                                value: likeability,
                              ),
                              const Padding(padding: EdgeInsets.only(top: 6)),
                              RichText(
                                text: TextSpan(
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "${(likeability * 100).toInt()}%",
                                      style: bigText,
                                    ),
                                    const TextSpan(
                                      text: ' of people would choose ',
                                    ),
                                    TextSpan(
                                      text: thing!.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " over ",
                                    ),
                                    TextSpan(
                                      text: otherthing.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
