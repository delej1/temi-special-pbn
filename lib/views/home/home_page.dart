import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/views/account/account_page.dart';
import 'package:temis_special_snacks/views/cart/cart_history.dart';
import 'package:temis_special_snacks/views/home/temi_main_page.dart';
import 'package:temis_special_snacks/views/order/order_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late int _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = 0;
    _pages = [
      const TemiMainPage(),
      const OrderPage(),
      const CartHistory(),
      const AccountPage(),
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  void onTapNav(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the App?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,),
            //return false when click on "NO"
            child:const Text('No'),
          ),

          ElevatedButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                Navigator.of(context).pop();
              }
            },
            //return true when click on "Yes"
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,),
            child:const Text('Yes'),
          ),
        ],
      ),
    )??false; //if showDialog had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Platform.isAndroid?showExitPopup:null,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (selectedPageIndex) {
            setState(() {
              _selectedPageIndex = selectedPageIndex;
            });
          },
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: Theme.of(context).disabledColor,
          currentIndex: _selectedPageIndex,
          showUnselectedLabels: false,
          unselectedFontSize: 0.0,
          onTap: (selectedPageIndex) {
            setState(() {
              _selectedPageIndex = selectedPageIndex;
              _pageController.animateTo(selectedPageIndex.toDouble(), duration: const Duration(milliseconds: 200), curve: Curves.bounceOut);
            });
            _pageController.jumpToPage(selectedPageIndex);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.archive,
              ),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Me",
            ),
          ],
        ),
      ),
    );
  }
}
