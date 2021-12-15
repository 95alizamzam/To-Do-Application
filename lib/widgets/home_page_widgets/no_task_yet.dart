import 'package:flutter/material.dart';

class noTasksYet extends StatelessWidget {
  const noTasksYet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/notask.jpg',
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'You dont have tasks yet \n add new tasks from add task button',
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/notask.jpg',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'You dont have tasks yet \n add new tasks from add task button',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
