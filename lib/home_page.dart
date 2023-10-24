import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      body: ListView(
        padding: const EdgeInsets.all(32),
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
          Center(
            child: ElevatedButton(
              onPressed: () {
                talenta = Talenta.fromJson(jsonDecode(controller.text));
                if (talenta != null) {
                  workHour = _calculateWorkHour(talenta!.data!);
                }
                setState(() {});
              },
              child: const Text("Submit"),
            ),
          ),
          const SizedBox(height: 64),
          if (talenta != null) ...[
            Center(child: Text("Total Jam Kerja: ${_printDuration(workHour!)}")),
            Center(
              child: Text("Jam Kerja Yang Dibutuhkan: ${_printDuration(_calculateRequiredWorkHour(talenta!.data!))}"),
            ),
            Center(
              child: Text(
                  "Total Jam Kerja Yang Dibutuhkan Sekarang: ${_printDuration(_calculateRequiredWorkHourNow(talenta!.data!))}"),
            ),
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Tanggal")),
                Expanded(child: Text("Clock In")),
                Expanded(child: Text("Break In")),
                Expanded(child: Text("Break Out")),
                Expanded(child: Text("Clock Out")),
                Expanded(child: Text("Akumulasi Jam Kerja")),
              ],
            ),
            const SizedBox(height: 32),
            ListView.builder(
              shrinkWrap: true,
              itemCount: talenta!.data!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Attributes attributes = talenta!.data![index].attributes!;
                Duration clockHour = const Duration();
                Duration clock = const Duration();
                Duration breaks = const Duration();

                if (attributes.clockIn != null && attributes.clockOut != null) {
                  clock = dateParse(attributes.clockOut!).difference(dateParse(attributes.clockIn!));
                } else if (attributes.clockinTime != null && attributes.clockoutTime != null) {
                  clock = dateParse(attributes.clockoutTime!).difference(dateParse(attributes.clockinTime!));
                }
                // else if (DateFormat("d").format(dateParse(attributes.clockIn ?? "2023-01-01")) ==
                //     DateFormat("d").format(DateTime.now())) {
                //   clock = DateTime.now().difference(dateParse(attributes.clockIn ?? "2023-01-01"));
                //   print(DateFormat("HH:mm").format(DateTime.now()));
                // }

                if (attributes.clockIn != null &&
                    attributes.clockOut != null &&
                    attributes.breakCheckin != null &&
                    attributes.breakCheckout != null) {
                  breaks = dateParse(attributes.breakCheckout!).difference(dateParse(attributes.breakCheckin!));
                }

                clockHour += clock + breaks;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    color: attributes.officeHourName == "dayoff" ? Colors.red.withOpacity(0.3) : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(talenta!.data![index].attributes!.scheduleDate!)),
                      Expanded(
                        child: Text(
                          DateFormat("HH:mm").format(
                            DateTime.parse(
                              talenta!.data![index].attributes!.clockIn ??
                                  talenta!.data![index].attributes!.clockinTime ??
                                  "2023-01-01",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat("HH:mm").format(
                            DateTime.parse(
                              talenta!.data![index].attributes!.breakCheckout ?? "2023-01-01",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat("HH:mm").format(
                            DateTime.parse(
                              talenta!.data![index].attributes!.breakCheckin ?? "2023-01-01",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat("HH:mm").format(
                            DateTime.parse(
                              talenta!.data![index].attributes!.clockOut ??
                                  talenta!.data![index].attributes!.clockoutTime ??
                                  "2023-01-01",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _printDuration(clockHour),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: clockHour.inHours >= 1 ? Colors.green : Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]
        ],
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

        // if (attributes.clockinTime != null &&
        //     attributes.clockoutTime != null &&
        //     attributes.clockIn != null &&
        //     attributes.clockOut != null) {
        //   clock = dateParse(attributes.clockoutTime ?? attributes.clockOut!)
        //       .difference(dateParse(attributes.clockinTime ?? attributes.clockIn!));
        // }

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

  Duration _calculateRequiredWorkHour(List<Data> data) {
    Duration duration = Duration();
    for (var item in data) {
      if (item.attributes!.officeHourName != "dayoff") {
        duration += const Duration(hours: 8);
      }
    }
    return duration;
  }

  Duration _calculateRequiredWorkHourNow(List<Data> data) {
    Duration duration = Duration();
    for (var item in data) {
      print(DateTime.parse(item.attributes!.scheduleDate!).difference(DateTime.now()).inDays > 0);

      if (item.attributes!.officeHourName != "dayoff" &&
          DateTime.parse(item.attributes!.scheduleDate!).difference(DateTime.now()).inDays < 0) {
        duration += const Duration(hours: 8);
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
