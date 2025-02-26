  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

  class AddShiftPage extends StatefulWidget {
    @override
    _AddShiftPageState createState() => _AddShiftPageState();
  }

  class _AddShiftPageState extends State<AddShiftPage> {
    TextEditingController shiftNameController = TextEditingController();
    TimeOfDay? shiftStartTime;
    TimeOfDay? shiftEndTime;
    TextEditingController breakTimeController = TextEditingController();
    TextEditingController overtimeController = TextEditingController();
    TextEditingController shiftDescriptionController = TextEditingController();
    String? shiftType;

    Future<void> _selectTime(BuildContext context, bool isStart) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() {
          if (isStart) {
            shiftStartTime = picked;
          } else {
            shiftEndTime = picked;
          }
        });
      }
    }

    void _submitForm() {
      if (shiftNameController.text.isEmpty || shiftStartTime == null || shiftEndTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 10),
                Text("Ups, please fill the form!", style: TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.blue,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      FirebaseFirestore.instance.collection('shifts').add({
        "shiftName": shiftNameController.text,
        "shiftStartTime": shiftStartTime!.format(context),
        "shiftEndTime": shiftEndTime!.format(context),
        "breakTime": breakTimeController.text,
        "overtime": overtimeController.text,
        "shiftDescription": shiftDescriptionController.text,
        "shiftType": shiftType,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Shift Added Successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add shift: $error"),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 26, 0, 143),
          centerTitle: true,
          title: Text("Add Shift", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[200],
          child: Container(
            width: size.width * 0.9,
            margin: EdgeInsets.only(top: 40),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.blueAccent,
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Icon(Icons.maps_home_work_outlined, color: Colors.white),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Please Fill out the Form!",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: shiftNameController,
                    decoration: InputDecoration(
                      labelText: "Shift Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(context, true),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              shiftStartTime == null ? "Select Start Time" : shiftStartTime!.format(context),
                              style: TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(context, false),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              shiftEndTime == null ? "Select End Time" : shiftEndTime!.format(context),
                              style: TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: breakTimeController,
                    decoration: InputDecoration(
                      labelText: "Break Time",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: overtimeController,
                    decoration: InputDecoration(
                      labelText: "Overtime Allowed",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: shiftType,
                    items: ["Day Shift", "Night Shift", "Flexible"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        shiftType = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Shift Type",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: shiftDescriptionController,
                    decoration: InputDecoration(
                      labelText: "Shift Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text("Add Shift", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(double.infinity, 50),
                      shadowColor: Colors.black45,
                      elevation: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      );
    }
  }