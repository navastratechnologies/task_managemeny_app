import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/viewmodels/task_viewmodel.dart';
import 'package:task_management_app/views/helpers/color_constants.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key});

  @override
  _TaskAddScreenState createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  final String _priority = 'Low';
  String _deadline = '';
  String selectedPriority = 'Low';

  List<String> priorityList = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _deadline = DateFormat('dd MMM, yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    TaskViewModel viewModel = Provider.of<TaskViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_rounded,
            color: whiteColor,
          ),
        ),
        title: Text(
          'Add Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: whiteColor,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: whiteColor.withOpacity(0.4),
                  ),
                ),
                style: TextStyle(
                  color: whiteColor,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(
                    color: whiteColor.withOpacity(0.4),
                  ),
                ),
                style: TextStyle(
                  color: whiteColor,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task description';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Priority',
                style: TextStyle(
                  color: whiteColor.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  itemCount: priorityList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => setState(() {
                        selectedPriority = priorityList[index];
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedPriority == priorityList[index]
                              ? Colors.lime
                              : whiteColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Center(
                          child: Text(
                            priorityList[index],
                            style: TextStyle(
                              color: selectedPriority == priorityList[index]
                                  ? blackColor
                                  : whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Deadline',
                  hintStyle: TextStyle(
                    color: whiteColor.withOpacity(0.4),
                  ),
                ),
                style: TextStyle(
                  color: whiteColor,
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _deadline = DateFormat('dd MMM, yyyy').format(pickedDate);
                    });
                  }
                },
                controller: TextEditingController(
                  text: _deadline,
                ),
              ),
              const SizedBox(height: 16),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Colors.lime,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Task newTask = Task(
                      title: _title,
                      description: _description,
                      priority: selectedPriority.isNotEmpty
                          ? selectedPriority
                          : _priority,
                      deadline: _deadline,
                      status: '0',
                    );

                    viewModel.addTask(newTask);

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
