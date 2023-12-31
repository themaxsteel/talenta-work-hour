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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Jam Kerja: ${_printDuration(workHour!)}",
                ),
                const SizedBox(width: 12),
                Builder(builder: (context) {
                  Duration duration = _workHourPlusMinus(talenta!.data!);

                  return Text(
                    "(${duration.isNegative ? "-" : "+"}${_printDuration(duration)})",
                    style:
                        TextStyle(color: duration.isNegative ? Colors.red : Colors.green, fontWeight: FontWeight.w500),
                  );
                })
              ],
            ),
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
                      Builder(builder: (context) {
                        Duration duration = clockHour - const Duration(hours: 8);
                        return Expanded(
                          child: Row(
                            children: [
                              Text(
                                "${_printDuration(clockHour)}  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: clockHour.inHours >= 1 ? Colors.green : Colors.red),
                              ),
                              if (attributes.officeHourName != "dayoff")
                                Text(
                                  "(${duration.isNegative ? "" : "+"}${_printDuration(duration)})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: duration.isNegative ? Colors.red : Colors.green),
                                )
                            ],
                          ),
                        );
                      }),
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
    duration += const Duration(hours: 8);
    return duration;
  }

  Duration _calculateRequiredWorkHour(List<Data> data) {
    Duration duration = const Duration();
    for (var item in data) {
      if (item.attributes!.officeHourName != "dayoff") {
        duration += const Duration(hours: 8);
      }
    }
    return duration;
  }

  Duration _calculateRequiredWorkHourNow(List<Data> data) {
    Duration duration = const Duration();
    for (var item in data) {
      print(DateTime.parse(item.attributes!.scheduleDate!).difference(DateTime.now()).inDays);
      print(item.attributes!.scheduleDate!);

      if (item.attributes!.officeHourName != "dayoff" &&
          DateTime.parse(item.attributes!.scheduleDate!).difference(DateTime.now()).inHours < 0) {
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

  Duration _workHourPlusMinus(List<Data> data) {
    Duration workHour = _calculateWorkHour(data);
    Duration requiredWorkHourNow = _calculateRequiredWorkHourNow(data);

    return workHour - requiredWorkHourNow;
  }

  DateTime dateParse(String date) => DateTime.parse(date);
}
