// bottomNavigation
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hazlo/Pages_Screens/AddNote2.dart';
import 'package:hazlo/Pages_Screens/Calendar.dart';
import 'package:hazlo/Pages_Screens/NoteList2.dart';
import 'package:hazlo/Pages_Screens/TaskListView.dart';


class BottomNavbar extends StatefulWidget {
  @override
  State<StatefulWidget> createState()  => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  bool _isVisible = true;
  ScrollController controller;
  bool isScrollingDown  = false;


  // bottom navigation pages
  int _currentIndex = 0;
  final List<Widget> _pagesoptions =  <Widget>[

    NoteList2(),
    TaskListview(),
    Calendar(),

  ];


  @override
  void initState() {
    super.initState();
    controller = ScrollController();


  }

  @override
  void dispose() {
    controller.removeListener(() { });
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold (

      body: _pagesoptions[_currentIndex],
      bottomNavigationBar: Offstage(

        offstage: ! _isVisible,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          showUnselectedLabels: true,
          onTap: (int index)
          {
            setState(() {
              _currentIndex = index;
            });

          },

          items: allPages.map((Pages pages) {
            return BottomNavigationBarItem(
                icon: Icon(pages.icon),
                backgroundColor: pages.color,
                label:pages.title
            );
          }).toList(),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          // FAB 1: Add button
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // debugPrint('FAB clicked');
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new AddNote2()));
            },
            heroTag: null,
            backgroundColor: Color(0xFF005792),

          ),
        ],

      ),

    );
  }

}



// bottom navebar pages and routes
class Pages {
  final String title;
  final IconData icon;
  final MaterialColor color;
  const Pages(this.title,this.icon, this.color,);

}
const List<Pages> allPages = <Pages>[
  Pages(
    'Home',
    Icons.home_outlined,
    Colors.blueGrey,
  ),

  Pages('Tasks',
    Icons.format_list_bulleted,
    Colors.blueGrey,

  ),
  Pages('Calendar',
      Icons.date_range,
      Colors.blueGrey
  ),
];


