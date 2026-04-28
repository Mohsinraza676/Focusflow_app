import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.getTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _addTask() async {
    if (_taskController.text.trim().isEmpty) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _taskController.text.trim(),
      createdAt: DateTime.now(),
    );

    setState(() {
      _tasks.insert(0, newTask);
    });

    _taskController.clear();
    await _taskService.saveTasks(_tasks);
  }

  Future<void> _toggleTask(int index) async {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    await _taskService.saveTasks(_tasks);
  }

  Future<void> _deleteTask(int index) async {
    setState(() {
      _tasks.removeAt(index);
    });
    await _taskService.saveTasks(_tasks);
  }

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  double get _completionRate => _tasks.isEmpty ? 0 : _completedCount / _tasks.length;

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Focus",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _taskController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "What are you focusing on today?",
                filled: true,
                fillColor: const Color(0xFFF1F3F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) {
                _addTask();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _addTask();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Create Task",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  _buildHeader(),
                  _buildSummaryCard(),
                  _tasks.isEmpty ? _buildEmptyState() : _buildTaskList(),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskSheet,
        backgroundColor: const Color(0xFF1A237E),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("New Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMM d').format(DateTime.now()),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  "FocusFlow",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A237E).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${(_completionRate * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _completionRate,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "$_completedCount of ${_tasks.length} tasks completed",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 80,
              color: const Color(0xFF1A237E).withOpacity(0.1),
            ),
            const SizedBox(height: 16),
            Text(
              "Clear space, clear mind.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A237E).withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Add a task to start your flow.",
              style: TextStyle(
                color: const Color(0xFF1A237E).withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = _tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _deleteTask(index),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: GestureDetector(
                      onTap: () => _toggleTask(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: task.isCompleted ? const Color(0xFF1A237E) : Colors.transparent,
                          border: Border.all(
                            color: task.isCompleted ? const Color(0xFF1A237E) : Colors.black12,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: task.isCompleted
                            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                            : const SizedBox(width: 18, height: 18),
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.black38 : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('h:mm a').format(task.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.black26),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: _tasks.length,
        ),
      ),
    );
  }
}
