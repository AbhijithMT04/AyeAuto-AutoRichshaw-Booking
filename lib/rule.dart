import 'package:ayeautoo/driver_Home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RulesApp());
}

class RulesApp extends StatelessWidget {
  const RulesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RulesPage(),
    );
  }
}

class RulesPage extends StatefulWidget {
  const RulesPage({Key? key}) : super(key: key);

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => driverhome()));
          },
          icon: Icon(Icons.arrow_back,color: Color(0xFFFF4A17),),
        ),
        title: Text('Vehicle Rules', style: TextStyle(color: Color(0xFFFF4A17))),
        backgroundColor: Colors.black,
        elevation: 6,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.deepOrange.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vehicle Rules:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 10),
                _buildRuleRow('1. Always wear your seatbelt.'),
                _buildRuleRow('2. Obey traffic signs and signals.'),
                _buildRuleRow('3. Don\'t use mobile phones while driving.'),
                _buildRuleRow('4. Keep a safe distance from the vehicle in front.'),
                _buildRuleRow('5. Always use your indicators when changing lanes.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleRow(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.black),
          SizedBox(width: 8),
          Expanded(child: Text(rule)),
        ],
      ),
    );
  }
}
