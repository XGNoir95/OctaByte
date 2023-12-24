import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trending App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TrendingScreen(),
    );
  }
}

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  State<TrendingScreen> createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<TrendingScreen> {
  final controller = CarouselController();
  final secondCarouselController = CarouselController();
  final myitems = [
    "assets/banner/1.jpg",
    "assets/banner/2.jpg",
    "assets/banner/3.jpg",
    "assets/banner/4.jpg",
    "assets/banner/5.jpg",
    "assets/banner/6.jpg",
  ];
  final myitems2 = [
    "assets/banner/1.jpg",
    "assets/banner/2.jpg",
    "assets/banner/3.jpg",
    "assets/banner/4.jpg",
    "assets/banner/6.jpg",
  ];

  int myCurrentIndex = 0;
  int secondCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    // Preload images before using them in the carousel
    _preloadImages([...myitems, ...myitems2]);
  }

  Future<void> _preloadImages(List<String> imageUrls) async {
    for (var imageUrl in imageUrls) {
      await precacheImage(NetworkImage(imageUrl), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Trending"),
        titleTextStyle: const TextStyle(
          color: Colors.amber,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                "Your Passport to Trendy Discounts",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Adjusted font size
                ),
              ),
            ),

            CarouselSlider(
              carouselController: controller,
              options: CarouselOptions(
                autoPlay: true,
                height: 200,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    myCurrentIndex = index;
                  });
                },
              ),
              items: myitems.map((item) => Image.asset(item)).toList(),
            ),

            AnimatedSmoothIndicator(
              activeIndex: myCurrentIndex,
              count: myitems.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 10,
                dotColor: Colors.grey.shade200,
                activeDotColor: Colors.amber,
                paintStyle: PaintingStyle.fill,
              ),
            ),

            SizedBox(height: 100),

            Container(
              child: Text(
                "Get the Scoop on Today's Trending Deals",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                //  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Second carousel slider with added space between items
            CarouselSlider(
              carouselController: secondCarouselController,
              options: CarouselOptions(
                autoPlay: false,
                height: 230,
                viewportFraction: 0.8,
                autoPlayCurve: Curves.linear,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    secondCarouselIndex = index;
                  });
                },
              ),
              items: myitems2.map((item) => Image.asset(item)).toList(),
            ),

            // Row for the "Next" and "Previous" buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    secondCarouselController.previousPage();
                  },
                  child: Text('Previous'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    secondCarouselController.nextPage();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
