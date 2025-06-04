import 'package:flutter/material.dart';

import 'my_button.dart';


class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
        backgroundColor: Colors.yellowAccent[100],
        content: SizedBox(
            height: 150,
            child: Column(
                children: [
                  const SizedBox(height: 20),


                ]
            )
        )
    );
  }
}
