import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/records_provider.dart';
import './record_item.dart';

class RecordsGrid extends StatelessWidget {
  final bool showFavs;

  RecordsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final recordsData = Provider.of<RecordsProvider>(context);
    final records = showFavs ? recordsData.favoriteItems : recordsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: records.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            // builder: (c) => products[i],
            value: records[i],
            child: RecordItem(
                // products[i].id,
                // products[i].title,
                // products[i].imageUrl,
                ),
          ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
