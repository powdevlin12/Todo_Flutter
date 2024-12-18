import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ParentWidget(),
    );
  }

  const Screen2({super.key});
}

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return ParentWidgetState();
  }
}

class ParentWidgetState extends State<ParentWidget> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    print('parent widget rebuild!');
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  count++;
                });
              },
              child: Text('Increment Counter $count')),
          const ChildWidget()
        ],
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print('child parent rebuild!');
    return Text("I'm a child widget!!", key: UniqueKey());
  }
}
