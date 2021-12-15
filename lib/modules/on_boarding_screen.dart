import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:to_do_app/modules/home_page.dart';
import 'package:to_do_app/shared/components/functions.dart';

class onBoardingScreen extends StatefulWidget {
  onBoardingScreen({Key? key}) : super(key: key);

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  int currentIndex = 0;
  List<Map<String, dynamic>> data = [
    {
      'photo': 'images/icon.png',
      'color': Colors.blue,
      'title': 'TODO App Intorduction :',
      'text': 'Welcome to TODO application, this app is useful for creating notes for your important events.\n'
          'this notes will send you a notification befor the actually time. and you can choose the period of time'
          ' and you can schedule the notifications by time like daily or weakly or montly. \n',
    },
    {
      'photo': 'images/dark_light_mode.jpg',
      'title': 'TODO App Modes :',
      'color': Colors.orange,
      'text': 'Try light Mode and dark Mode \n'
          'we provide you probability to change TODO application mode to suitable your favorite Mode',
    },
    {
      'photo': 'images/contact_us.jpg',
      'color': Colors.red,
      'title': 'TODO App Contacts  :',
      'text': 'Contact us \n'
          'You can contact with us by vary Ways we provide it to you. \n'
          'like contact via Email or phone number or whatsapp or via LinkedIn or Facebook',
    }
  ];

  List<Color> dotColor = [
    Colors.blue,
    Colors.orange,
    Colors.red,
  ];
  final con = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: PageView.builder(
                      itemBuilder: (ctx, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image(
                              width: double.infinity,
                              fit: BoxFit.fill,
                              image: AssetImage(data[index]['photo']),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              data[index]['title'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: dotColor[currentIndex],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                data[index]['text'].toString(),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      itemCount: data.length,
                      controller: con,
                      onPageChanged: (int index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: SmoothPageIndicator(
                            controller: con,
                            count: data.length,
                            axisDirection: Axis.horizontal,
                            effect: ExpandingDotsEffect(
                              spacing: 6.0,
                              radius: 12.0,
                              dotWidth: 14.0,
                              dotHeight: 10.0,
                              paintStyle: PaintingStyle.fill,
                              strokeWidth: 2.5,
                              dotColor: Colors.grey.shade400,
                              activeDotColor: dotColor[currentIndex],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (currentIndex == data.length - 1) {
                              goto(
                                goalScreen: homePage(),
                                context: context,
                                moveType: PageTransitionType.topToBottom,
                              );
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('watchOnBoarding', true);
                            } else {
                              setState(() {
                                currentIndex++;
                                con.animateToPage(
                                  currentIndex,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                );
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: dotColor[currentIndex],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
