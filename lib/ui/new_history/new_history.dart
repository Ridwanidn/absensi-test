import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 0, 143),
        centerTitle: true,
        title: Text("Shift History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('shifts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No shift history available.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
          }
          
          var shifts = snapshot.data!.docs;
          
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: shifts.length,
            itemBuilder: (context, index) {
              var shift = shifts[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shift["shiftName"] ?? "Unknown Shift",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.history, color: Colors.blueAccent, size: 28),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text("⏰ Time: ${shift["shiftStartTime"] ?? "-"} - ${shift["shiftEndTime"] ?? "-"}", style: TextStyle(fontSize: 14)),
                      if (shift["breakTime"] != null && shift["breakTime"].isNotEmpty)
                        Text("☕ Break: ${shift["breakTime"]}", style: TextStyle(fontSize: 14)),
                      if (shift["overtime"] != null && shift["overtime"].isNotEmpty)
                        Text("🕒 Overtime: ${shift["overtime"]}", style: TextStyle(fontSize: 14, color: Colors.redAccent)),
                      if (shift["shiftDescription"] != null && shift["shiftDescription"].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "📝 Description: ${shift["shiftDescription"]}",
                            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[700]),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}