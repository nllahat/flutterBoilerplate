import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/record_provider.dart';
import '../providers/auth.dart';

class RecordItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RecordProvider recordProvider = Provider.of<RecordProvider>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Image.network(
          recordProvider.record.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<RecordProvider>(
            builder: (ctx, record, _) => IconButton(
              icon: Icon(
                record.record.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                /* product.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                ); */
              },
            ),
          ),
          title: Text(
            recordProvider.record.title,
            textAlign: TextAlign.center,
          ),
          /* trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ), */
        ),
      ),
    );
  }
}
