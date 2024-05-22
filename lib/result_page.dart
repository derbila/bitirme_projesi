import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double eto;
  const ResultPage({super.key, required this.eto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("ETo:"),
            const SizedBox(
              height: 25,
            ),
            Text(
              eto.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
