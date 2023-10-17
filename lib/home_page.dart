import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:talenta_work_hour/talenta_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  Talenta? talenta;
  Duration? workHour;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Talenta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 12,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Input Summary Attendance JSON",
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                talenta = Talenta.fromJson(jsonDecode(controller.text));
                if (talenta != null) {
                  workHour = _calculateWorkHour(talenta!.data!);
                }
                setState(() {});
              },
              child: const Text("Submit"),
            ),
            const SizedBox(height: 64),
            if (talenta != null) Text("Total Jam Kerja: ${_printDuration(workHour!)}"),
          ],
        ),
      ),
    );
  }

  Duration _calculateWorkHour(List<Data> data) {
    Duration duration = const Duration();

    for (var item in data) {
      if (item.attributes != null) {
        Attributes attributes = item.attributes!;

        Duration clock = const Duration();
        if (attributes.clockinTime != null && attributes.clockoutTime != null) {
          clock = dateParse(attributes.clockoutTime!).difference(dateParse(attributes.clockinTime!));
        } else if (attributes.clockIn != null && attributes.clockOut != null) {
          clock = dateParse(attributes.clockOut!).difference(dateParse(attributes.clockIn!));
        }

        Duration breaks = const Duration();
        if (attributes.breakCheckin != null && attributes.breakCheckout != null) {
          breaks = dateParse(attributes.breakCheckout!).difference(dateParse(attributes.breakCheckin!));
        }
        print("${attributes.scheduleDate} ${clock + breaks}");
        duration += (clock + breaks);
      }
    }
    return duration;
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)} : $twoDigitMinutes : $twoDigitSeconds";
  }

  DateTime dateParse(String date) => DateTime.parse(date);
}
