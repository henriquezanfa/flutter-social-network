import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/user.dart';
import '../widgets/progress.dart';
import 'home.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  bool _searchHasData;
  AnimationController _searchIconAnimationController;

  Future<QuerySnapshot> searchResultsFuture;
  final _searchEditingContrroller = TextEditingController();

  handleSeach(String query) {
    Future<QuerySnapshot> users = userRef
        .where('displayName', isGreaterThanOrEqualTo: query)
        .getDocuments();

    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSeach() {
    if (_searchHasData) {
      _searchEditingContrroller.clear();
      _searchIconAnimationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _searchIconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    );

    _searchHasData = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: buildSearchField(),
        body: searchResultsFuture == null
            ? buildNoContent()
            : buildSearchResults(),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return circularProgress();

        List<UserResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(user: user);
          searchResults.add(searchResult);
        });

        return ListView(
          children: searchResults,
        );
      },
    );
  }

  buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: _searchEditingContrroller,
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
          prefixIcon: Icon(Icons.account_circle),
          suffixIcon: AnimatedIconButton(
            animationController: _searchIconAnimationController,
            size: 24,
            onPressed: clearSeach,
            endIcon: Icon(Icons.close, color: Colors.black38),
            startIcon: Icon(Icons.search),
            startBackgroundColor: Colors.transparent,
            endBackgroundColor: Colors.transparent,
          ),
        ),
        onFieldSubmitted: handleSeach,
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
  final User user;

  const UserResult({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => print('tapped'),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
