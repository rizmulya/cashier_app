import 'package:cashier_app/View/product_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/*
 * SplashScreen
 * 
 */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}

/*
 * OnboardingScreen
 * 
 */
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Effortlessly Manage Your Products',
      'subtitle':
          'Track product details, stock, prices, and photos effortlessly.',
      'image': 'assets/onboarding1.png'
    },
    {
      'title': 'Fast Search and Barcode Scanning',
      'subtitle':
          'Quickly search and use barcode scanning for easy input and purchases.',
      'image': 'assets/onboarding2.png'
    },
    {
      'title': 'Auto Calculate and Update Stock',
      'subtitle':
          'Automatically calculate totals and update stock with each purchase.',
      'image': 'assets/onboarding3.png'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.yellow,
                  child: Center(
                    child: Image.asset(onboardingData[index]['image']!),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          onboardingData[index]['title']!,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          onboardingData[index]['subtitle']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                            (dotIndex) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: dotIndex == _currentPage
                                    ? Colors.blue
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        if (index == onboardingData.length - 1)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => const ProductView()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _controller.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
