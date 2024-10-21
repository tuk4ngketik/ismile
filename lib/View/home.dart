// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, annotate_overrides, prefer_final_fields, unused_element, avoid_print



import 'package:flutter/material.dart';

import '../Helper/wg.dart';
import 'index.dart';
import 'kehadiran.dart';
import 'profil.dart';  

class Home extends StatefulWidget{  
  const Home({super.key});
  _Home  createState() => _Home();
}

class _Home extends State<Home>{

  late List<Widget> contentWidget ;
  late List<BottomNavigationBarItem> _bottomNavigationBarItem;
  int _selectedIndex = 0;
  // String? latlong;

  @override
  void initState() { 
    super.initState();
    // _determinePosition();
    _setContentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(    
      appBar:  appbar0(),
      // appBar:  appbar1(),
      // appBar:  appbar2(),
      body: ( contentWidget.isEmpty  ) ? const Center(child: CircularProgressIndicator(),):  contentWidget[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(   
        backgroundColor: Colors.white,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.blueGrey, 
        // backgroundColor: Colors.black87,  
        items: _bottomNavigationBarItem,
        currentIndex:  _selectedIndex,
        showUnselectedLabels: true ,
        onTap: changeTab,
        // showSelectedLabels: false,
        // selectedItemColor: Color.fromARGB(228, 0, 20, 72),
        // selectedItemColor: Colors.indigo[800],  
      ),
    );
  } 
 

  void changeTab(int index) { 
    setState(() => _selectedIndex = index );
    print ('_selectedIndex $_selectedIndex'); 
  }
 
 _setContentWidget(){

        contentWidget = [    
          const Index(), 
          Kehadiran(),
          Profil(),
          // Learning()
        ];

        _bottomNavigationBarItem = [  
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, ),
            label: 'Beranda',  
          ),    
          const BottomNavigationBarItem(
            icon: Icon(Icons.history, ),
            label: 'Kehadiran', 
          ), 
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_box_sharp, ),
            label: 'Profil', 
          ),
          // const Bottomeexsxa
        ];
  }
   

}//end