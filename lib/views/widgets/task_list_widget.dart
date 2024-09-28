import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/viewmodels/task_viewmodel.dart';
import 'package:task_management_app/views/helpers/color_constants.dart';
import 'package:task_management_app/views/task_detail_screen.dart';

class TaskListWidget extends StatefulWidget {
  final Function(bool) onSelectionChanged;

  const TaskListWidget({super.key, required this.onSelectionChanged});

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  bool isSelecting = false;
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    TaskViewModel viewModel = Provider.of<TaskViewModel>(context);

    List<Task> sortedTasks = viewModel.tasks;

    if (selectedFilter != null) {
      if (selectedFilter == 'High' ||
          selectedFilter == 'Medium' ||
          selectedFilter == 'Low') {
        sortedTasks.sort((a, b) => a.priority == selectedFilter ? -1 : 1);
      } else if (selectedFilter == 'Completed' || selectedFilter == 'Pending') {
        sortedTasks.sort((a, b) => a.status == selectedFilter ? -1 : 1);
      }
    }

    return Scaffold(
      body: viewModel.isLoading
          ? const Center(
              child: SpinKitFadingCircle(
                color: Colors.lightGreen,
                size: 50.0,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await viewModel.fetchTasks();
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: whiteColor,
                        ),
                        onPressed: () {
                          _showFilterMenu(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sortedTasks.length,
                      itemBuilder: (context, index) {
                        Task task = sortedTasks[index];
                        Color priorityColor;
                        if (task.priority == 'High') {
                          priorityColor = Colors.lime;
                        } else if (task.priority == 'Medium') {
                          priorityColor = whiteColor;
                        } else {
                          priorityColor = whiteColor.withOpacity(0.4);
                        }

                        return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              isSelecting = true;
                              task.isSelected = !task.isSelected;
                              widget.onSelectionChanged(isSelecting);
                            });
                          },
                          onTap: () {
                            if (isSelecting) {
                              setState(() {
                                task.isSelected = !task.isSelected;
                                isSelecting =
                                    sortedTasks.any((task) => task.isSelected);
                                widget.onSelectionChanged(isSelecting);
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailScreen(task: task),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              color: task.isSelected
                                  ? Colors.blue.withOpacity(0.5)
                                  : priorityColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/male.png',
                                  height: 50,
                                  width: 50,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        task.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Deadline: ${task.deadline}',
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
    );
  }

  void _showFilterMenu(BuildContext context) async {
    String? filter = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 0, 0, 0),
      items: [
        const PopupMenuItem<String>(
            value: 'High', child: Text('Priority > High')),
        const PopupMenuItem<String>(
            value: 'Medium', child: Text('Priority > Medium')),
        const PopupMenuItem<String>(
            value: 'Low', child: Text('Priority > Low')),
        const PopupMenuItem<String>(
            value: 'Completed', child: Text('Status > Completed')),
        const PopupMenuItem<String>(
            value: 'Pending', child: Text('Status > Pending')),
      ],
    );

    if (filter != null) {
      setState(() {
        selectedFilter = filter;
      });
    }
  }
}
