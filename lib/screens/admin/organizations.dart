import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/organization_model.dart';
import 'package:flutter_boilerplate/models/user_model.dart';
import 'package:flutter_boilerplate/services/organizations_service.dart';
import 'package:flutter_boilerplate/services/user_service.dart';
import 'package:provider/provider.dart';

class Organizations extends StatefulWidget {
  Organizations({Key key}) : super(key: key);

  @override
  _OrganizationsState createState() => _OrganizationsState();
}

class _OrganizationsState extends State<Organizations> {
  List<Organization> _organizations;
  @override
  void initState() {
    super.initState();
    Provider.of<OrganizationService>(context, listen: false)
        .organizationList
        .then((organizations) {
      setState(() {
        _organizations = organizations;
      });
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> _setOrganization(int index, Role role) async {
    /* var editedUser = User(
        id: _organizations[index].id,
        fullName: _organizations[index].fullName,
        birthDate: _organizations[index].birthDate,
        email: _organizations[index].email,
        gender: _organizations[index].gender,
        phoneNumber: _organizations[index].phoneNumber,
        role: role);
    editedUser = await Provider.of<UserService>(context, listen: false)
        .setOrAddUser(editedUser);
    setState(() {
      _organizations[index] = editedUser;
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return _organizations == null || _organizations.length == 0
        ? Container(child: Center(child: CircularProgressIndicator()))
        : ListView.builder(
            itemCount: _organizations?.length,
            itemBuilder: (BuildContext ctxt, int index) {
              var user = _organizations?.elementAt(index);
              return OrganizationListItem(
                organization: user,
                setOrganization: (Role role) {
                  return _setOrganization(index, role);
                },
              );
            });
  }
}

class OrganizationListItem extends StatefulWidget {
  final Organization organization;
  final Function(Role role) setOrganization;

  OrganizationListItem(
      {Key key, @required this.organization, @required this.setOrganization})
      : super(key: key);

  @override
  _OrganizationListItemState createState() => _OrganizationListItemState();
}

class _OrganizationListItemState extends State<OrganizationListItem> {
  var _isLoading = false;

  Color _getIconColorByRole(Role role) {
    switch (role) {
      case Role.Admin:
        return Colors.black;
      case Role.Coordinator:
        return Colors.orangeAccent;
      case Role.Regular:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    var organization = widget.organization;

    return ExpansionTile(
      trailing: _isLoading
          ? CircularProgressIndicator()
          : Container(
              width: 1.0,
            ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.home,
            size: 40.0,
          ),
        ],
      ),
      title: Text(organization?.name ?? ''),
      initiallyExpanded: false,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.people_outline),
          dense: true,
          title: Text(
            'managers:',
            style: TextStyle(fontSize: 20.0),
          ),
          /* trailing: DropdownButton<String>(
            elevation: 8,
            icon: Container(),
            value: organization?.getRoleString(),
            onChanged: (String newValue) async {
              setState(() {
                _isLoading = true;
              });
              await widget.setUser(User.getRoleEnum(newValue));
              setState(() {
                _isLoading = false;
              });
            },
            items: ['admin', 'coordinator', 'regular'].toList().map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 20.0)),
              );
            }).toList(),
          ), */
        ),
        // Text(user?.role?.toString()?.split('.')?.elementAt(1) ?? '')
      ],
    );
  }
}
