import '../../constant/images.dart';
import '../../constant/text_constant.dart';
import 'package:flutter/material.dart';
import '../../widget/onBoarding/onBoardingPage.dart';
import '../../widget/router.dart';
import '../authentication/authentication.dart';
import '../settings/settings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  // Get a list of images from the directory and iterate through them 1 to 4, since they have been saved by number
  final List<Map<String, String>> onboardingData = List.generate(
    4,
    (index) => {
      "image": TImages.getImage(index),
      "title": TextConstants.getTitle(index),
      "description": TextConstants.getDescription(index),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 0),
            child: InkWell(
              onTap: () {
                // Navigate to authentication screen on Skip
                nextPageAndRemovePrevious(context, page: const Authentication());
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  image: onboardingData[index]["image"]!,
                  title: onboardingData[index]["title"]!,
                  description: onboardingData[index]["description"]!,
                  isLastPage: index == onboardingData.length - 1,
                  onSkip: () {
                    // Skip to authentication screen directly
                    nextPageAndRemovePrevious(context, page: const Authentication());
                  },
                  onNext: () {
                    if (index < onboardingData.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Navigate to authentication screen when done
                      nextPageAndRemovePrevious(context, page: const Authentication());
                    }
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
