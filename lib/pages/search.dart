import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  bool _searchHasData = false;
  AnimationController _searchIconAnimationController;

  @override
  void initState() {
    super.initState();
    _searchIconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: buildSearchField(),
        body: buildNoContent(),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
      ),
    );
  }

  buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          setState(() {
            _searchHasData = value.isNotEmpty;
            _searchHasData
                ? _searchIconAnimationController.forward()
                : _searchIconAnimationController.reverse();
          });
        },
        decoration: InputDecoration(
          hintText: "Search for an user",
          filled: true,
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.account_circle,
            // size: 28,
          ),
          suffixIcon: AnimatedIconButton(
            animationController: _searchIconAnimationController,
            size: 24,
            onPressed: () {},
            endIcon: Icon(
              Icons.close,
              color: Colors.black38,
              // size: 20,
            ),
            startIcon: Icon(
              Icons.search,
              // color: Theme.of(context).accentColor,
              // size: 20,
            ),
            startBackgroundColor: Colors.transparent,
            endBackgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  buildNoContent() {
    final orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300 : 200,
            ),
            Text(
              'Find Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 48,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}
