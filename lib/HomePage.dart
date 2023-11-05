import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gap/gap.dart';

enum StateChange {
  a,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //stuff
  String displaytext = "a";
  int? target_hours;
  Color outputtextcolor = Colors.white;
  double outputfontsize = 30.0;
  Color hourssection = Colors.white;
  DateTime targetDay = DateTime.now();

  void setDisplayText() {
    if (target_hours == null) {
      return;
    }
    if (DateTime.now().millisecondsSinceEpoch >=
        targetDay.millisecondsSinceEpoch) {
      displaytext = "It's probably over for you. Good luck";
      outputtextcolor = Colors.redAccent;
      return;
    }
    outputtextcolor = Colors.white;
    var t = (target_hours! / (targetDay.day - DateTime.now().day));
    var hours = t.truncate();
    var minutes = ((t - t.truncate()) * 60).truncate();
    displaytext =
        "$hours hours${minutes != 0 ? " and ${minutes} minutes" : ""} per day.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        //leading: const Icon(Icons.settings, color: Colors.orange),
        title: const Center(
          child: Text("Time Calculator", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: RichText(
                text: TextSpan(
                  text: displaytext,
                  style: TextStyle(
                    color: outputtextcolor,
                    fontSize: outputfontsize,
                  ),
                ),
              ),
            ),
            const Gap(40),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'How long you plan to work in hours.',
                fillColor: Color.fromARGB(255, 201, 107, 255),
                floatingLabelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 138, 138, 138)),
                ),
                labelStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                int? hours = 0;
                if ((hours = int.tryParse(value)) == null) {
                  setState(() {
                    displaytext = "Invalid numeric value.";
                    outputtextcolor = Colors.red;
                    target_hours = null;
                    outputfontsize = 20.0;
                  });
                  return;
                }
                if (hours! > 692040) {
                  setState(() {
                    displaytext =
                        "ⓘ The average human spends roughly 79 years or 692,040 hours alive. The value you have entered has exceeded the life expectancy of the average human. Please reconsider your choice of input.";
                    outputtextcolor = Colors.lightBlue;
                    target_hours = null;
                    outputfontsize = 10.0;
                  });
                  return;
                }
                target_hours = hours;
                setState(() => displaytext = value);
                setDisplayText();

                outputtextcolor = Colors.white;
              },
              onSubmitted: (value) {
                if (int.tryParse(value) == null) {
                  setState(() {
                    displaytext = "Invalid numeric value.";
                    target_hours = null;
                    outputtextcolor = Colors.red;
                    outputfontsize = 30.0;
                  });
                  return;
                }
                setState(() => displaytext = "BLEUH");
              },
            ),
            const Gap(30),
            RichText(
              text: TextSpan(
                text: "Due date?",
                style: TextStyle(
                  color: hourssection,
                  fontSize: 20,
                ),
              ),
            ),
            TableCalendar(
              firstDay: DateTime.utc(2022, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: targetDay,
              headerStyle: const HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.white)),
              calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(
                  color: Colors.white,
                ),
                weekendTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),

              // Add functionality
              selectedDayPredicate: (day) => isSameDay(targetDay, day),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  focusedDay = selectedDay;
                  targetDay = selectedDay;
                  setDisplayText();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
