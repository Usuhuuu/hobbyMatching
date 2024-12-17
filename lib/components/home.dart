import 'package:client/components/dashboard.dart';
import 'package:client/models/categories.dart';
import 'package:client/models/catergories_detail.dart';
import 'package:client/widgets/bottomnavigator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final List<CategoriesModel> categories = [];
  final List<CategoryDetail> categoryDetail = [];

  void initializeData() {
    categories.addAll(CategoriesModel.getCategories());
    categoryDetail.addAll(CategoryDetail.getCategoryDetail());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.initializeData();
  }

  final List<Widget> screens = [
    HomePage(),
    //const SearchScreen(),
    DashboardAndSignUp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context),
      body: SizedBox(
        width: double.infinity, // Makes the container take up the full width
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  catergorySection(), // This section will be pinned as part of the scroll
                  categoryDetails(), // This will scroll along with the content
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigator(context),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Hobby Match',
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blueAccent,
      leading: Builder(
        builder: (context) {
          return IconButton(
            color: Colors.white,
            iconSize: 25,
            icon: const Icon(Icons.search),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                ZoomDrawer.of(context)?.toggle();
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Column catergorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            const Text(
              "Categories",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                height: 100,
                color: Colors.white,
                child: ListView.separated(
                    itemCount: widget.categories.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () => (print("Tapped")),
                          child: Container(
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    )
                                  ],
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 0.7),
                                  borderRadius: BorderRadius.circular(25)),
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.categories[index].iconText,
                                    size: 40,
                                    color: Colors.blueAccent,
                                  ),
                                  Text(
                                    widget.categories[index].name,
                                    style: const TextStyle(
                                        color: Colors.blueAccent),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )));
                    }))
          ],
        )
      ],
    );
  }

  Widget categoryDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Category Details",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 1000,
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 20, // Horizontal spacing
                mainAxisSpacing: 30, // Vertical spacing
                childAspectRatio: 0.8, // Adjust to control item size
              ),
              itemCount: widget.categoryDetail.length,
              itemBuilder: (context, index) {
                final item = widget.categoryDetail[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.blueAccent,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => (print('Tapped on ${item.name}')),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150, // Fixed image height
                          width: 150, // Full width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            item.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
