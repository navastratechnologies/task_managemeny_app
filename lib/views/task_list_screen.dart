import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/viewmodels/task_viewmodel.dart';
import 'package:task_management_app/views/helpers/color_constants.dart';
import 'package:task_management_app/views/widgets/task_grid_widget.dart';
import 'package:task_management_app/views/widgets/task_list_widget.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool isSelecting = false;

  void onSelectionChanged(bool selectionActive) {
    setState(() {
      isSelecting = selectionActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    TaskViewModel viewModel = Provider.of<TaskViewModel>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Good Morning,\nDimitar!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    Image.asset(
                      'assets/male.png',
                      height: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.lime,
                  dividerColor: blackColor,
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(child: Text('All Notes')),
                    Tab(child: Text('Work')),
                    Tab(child: Text('Home')),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    children: [
                      TaskGridWidget(onSelectionChanged: onSelectionChanged),
                      TaskListWidget(onSelectionChanged: onSelectionChanged),
                      TaskGridWidget(onSelectionChanged: onSelectionChanged),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                shape: const CircleBorder(),
                color: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.all(10),
                onPressed: () {},
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              MaterialButton(
                shape: const CircleBorder(),
                color: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.all(10),
                onPressed: () {
                  Navigator.pushNamed(context, '/taskAdd');
                },
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              MaterialButton(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                onPressed: () {},
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white.withOpacity(0.3),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: isSelecting
            ? FloatingActionButton(
                onPressed: () {
                  viewModel.deleteSelectedTasks();
                  setState(() {
                    isSelecting = false;
                  });
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete),
              )
            : null,
      ),
    );
  }
}
