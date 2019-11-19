import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/screens/activities/edit_activity.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  /* @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<RecordsProvider>(context).fetchAndSetRecords()
      .then((_) {
        return Provider.of<ArtistsProvider>(context).fetchAndSetArtists();
      })
      .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
 */
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
              Navigator.of(context).pushNamed(EditActivity.routeName);
            },
        ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(child: Container())
                  ],
                )),
    );
  }
}
