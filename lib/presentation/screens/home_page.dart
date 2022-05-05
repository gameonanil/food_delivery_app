import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/model/food.dart';
import 'package:food_delivery_app/data/model/restaurant.dart';

import 'package:food_delivery_app/presentation/screens/cart_list_page.dart';
import 'package:food_delivery_app/presentation/screens/login_page_2.dart';
import 'package:food_delivery_app/presentation/widgets/foodcard.dart';
import 'package:food_delivery_app/presentation/widgets/restaurant_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/provider/foodprovider.dart';
import 'package:food_delivery_app/utils/my_shared_pref.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Center(
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.black.withOpacity(0.4),
              child: const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage("assets/images/profile.PNG"),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartListPage(),
                  ));
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () async {
              await MySharedPreference().resetPref();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: ((context) => LoginPage2())),
                ModalRoute.withName('/'),
              );
              // ref.read(authServiceProvider).signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Good Food ",
                    style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Fast Delivery",
                    style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Restaurants",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
                //_buildRestaurantList(context,restaurants,),
                Consumer(
                  builder: (context, ref, child) {
                    return ref.watch(restaurantFutureProvider).when(
                          error: (e, s) => Center(
                            child: Text("ERROR: ${e.toString()}"),
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          data: (restaurants) {
                            if (restaurants != null) {
                              return RefreshIndicator(
                                  onRefresh: () {
                                    return ref.refresh(
                                        restaurantFutureProvider.future);
                                  },
                                  child: _buildRestaurantList(
                                      context, restaurants, 280, 200));
                            }

                            return const Text("No Data");
                          },
                        );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "🔥Special Orders🔥",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ref.watch(foodFutureProvider).when(
                          error: (e, s) => Center(
                            child: Text("ERROR: ${e.toString()}"),
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          data: (foods) {
                            if (foods != null) {
                              return RefreshIndicator(
                                  onRefresh: () {
                                    return ref
                                        .refresh(foodFutureProvider.future);
                                  },
                                  child: _buildFoodListView(
                                      context, foods, 280, 200));
                            }

                            return const Text("No Data");
                          },
                        );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "KFC Special",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
                // _buildFoodListView(context, kfcList, 280, 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildRestaurantList(BuildContext context,
      List<Restaurant> restaurants, double height, double width) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return RestaurantCard(
            restaurant: restaurants[index],
          );
        },
        itemCount: restaurants.length,
      ),
    );
  }

  SizedBox _buildFoodListView(
      BuildContext context, List<Food> foodList, double height, double width) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return FoodCard(
            food: foodList[index],
            height: height,
            width: width,
          );
        },
        itemCount: foodList.length,
      ),
    );
  }
}
