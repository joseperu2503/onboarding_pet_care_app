import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_pet_care_app/data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  late AnimationController _controller;

  late Animation<double> _imageFade;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;
  late Animation<double> _bottomFade;

  void nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() => currentStep++);
    } else {
      // TODO: Navegar a la siguiente pantalla
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _imageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    );
    _subtitleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.8, curve: Curves.easeOut),
    );
    _bottomFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];

    return Scaffold(
      backgroundColor: const Color(0xFF140E17),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Stack(
              children: [
                Center(
                  child: Container(
                    width: 146,
                    height: 146,
                    margin: const EdgeInsets.only(top: 65),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFECEDFF).withOpacity(0.13),
                          blurRadius: 60,
                          spreadRadius: 50,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: currentStep == 0
                        ? FadeTransition(
                            opacity: _imageFade,
                            child: ScaleTransition(
                              scale:
                                  Tween<double>(begin: 0.9, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: const Interval(0.0, 0.4,
                                      curve: Curves.easeOutBack),
                                ),
                              ),
                              child: Image.asset(
                                step.image,
                                key: ValueKey(step.image),
                                width: 287,
                              ),
                            ),
                          )
                        : Image.asset(
                            step.image,
                            key: ValueKey(step.image),
                            width: 287,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FadeTransition(
              opacity: currentStep == 0
                  ? _titleFade
                  : const AlwaysStoppedAnimation(1.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    step.title,
                    key: ValueKey(step.title),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: currentStep == 0
                  ? _subtitleFade
                  : const AlwaysStoppedAnimation(1.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    step.subtitle,
                    key: ValueKey(step.subtitle),
                    style: const TextStyle(
                      color: Color(0xFFC4C3C5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: currentStep == 0
                  ? _bottomFade
                  : const AlwaysStoppedAnimation(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedSmoothIndicator(
                    activeIndex: currentStep,
                    count: steps.length,
                    effect: ExpandingDotsEffect(
                      dotColor: const Color(0xffF3F3F3).withOpacity(0.3),
                      activeDotColor: const Color(0xffF3F3F3),
                      dotWidth: 4,
                      dotHeight: 4,
                      spacing: 4,
                    ),
                  ),
                  TextButton(
                    onPressed: nextStep,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xFFF3F3F3),
                      minimumSize: const Size(62, 62),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/arrow-right.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF140E17),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
