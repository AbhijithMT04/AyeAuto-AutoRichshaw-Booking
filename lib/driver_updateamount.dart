import 'package:ayeautoo/driver_Home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(updateamount());
}

class updateamount extends StatefulWidget {
  const updateamount({Key? key}) : super(key: key);

  @override
  State<updateamount> createState() => _updateamountState();
}

class _updateamountState extends State<updateamount> {
  final amount = new TextEditingController();
  String? errormsg;
  bool? error, showprogress;
  bool passwordVisible=true;
  Future _saveDetails(String Amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    var rid = prefs.getString("rid");
    var lid = prefs.getString("lid");
    var data = await http.post(Uri.parse(url.toString()+"/upddateamount"),
        body: {"amount":Amount,"rid":rid,"lid":lid});

    var jsondata = json.decode(data.body);
//    if(jsonData["res"])

    if(jsondata["status"]=="no"){
      setState(() {
        print("kkkkkkkkkkkkk");
      });
    }
    else{
      if(jsondata["status"]=="ok"){
        setState(() {
          print("lllllllllllllll");
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>driverhome()));
        //user shared preference to save data
      }else{
        print("lllllllllllllllllllllllllllll");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { Navigator.push(
            context, MaterialPageRoute(builder: (context) => driverhome()));
        }, icon: new Icon(Icons.arrow_back, color: Color(0xFFFF4A17)),),
        title: Text('Update Amount', style: TextStyle(color: Color(0xFFFF4A17))),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                    errorText: error == true ? "": "*",

                    border: OutlineInputBorder(),
                    labelText: 'Amount',
                    hintText: 'Enter Your amount',
                    prefixIcon: Icon(Icons.money)
                ),
                controller: amount,
              ),
            ),


            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.deepOrange.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),

                ),
                  // textColor: Colors.white,
                  // color: Colors.blue,
                  child: Text('Approve',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Button text color black
                  ),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => driverhome()));

                    print("k");
                    int flg = 0;
                    if(amount.text.isEmpty){
                      setState(() {
                        error = false;
                      });
                      flg++;
                    }
                    if(flg == 0) {
                      _saveDetails(amount.text);
                    }
                  },
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}

class Joke1 {
  final String id;
  Joke1(this.id);
}
