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
      //title: 'Trending App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
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
        title: Text("  Trending & Hot Deals 🔥"),
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
              child: Column(
                children: [
                  SizedBox(height: 40,),
                  Text(
                    "Your Passport to Trendy Discounts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                ],
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
            SizedBox(height: 20,),
            AnimatedSmoothIndicator(
              activeIndex: myCurrentIndex,
              count: myitems.length,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                spacing: 12,
                dotColor: Colors.grey.shade200,
                activeDotColor: Colors.amber,
                paintStyle: PaintingStyle.fill,
              ),
            ),

            SizedBox(height: 50),

            Container(
              child: Text(
                "Year Ending Flash Sales ⚡",
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  color: Colors.white,
                  fontSize: 30,
                  //  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Second carousel slider
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    secondCarouselController.previousPage();
                  },
                  child: Text('Previous',style: TextStyle(color: Colors.black,fontFamily: 'RobotoCondensed',fontSize: 20,fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 16),

                ElevatedButton(
                  onPressed: () {
                    secondCarouselController.nextPage();
                  },
                  child: Text('   Next   ',style: TextStyle(color: Colors.black,fontFamily: 'RobotoCondensed',fontSize: 20,fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
