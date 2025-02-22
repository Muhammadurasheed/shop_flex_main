import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_flex/providers/favorite_provider.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final _wishList = ref.watch(favoriteProvider);
    final _favoriteProvider = ref.read(favoriteProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WishList',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _favoriteProvider.clearAllFavorites();
              },
              icon: Icon(CupertinoIcons.delete)),
        ],
      ),
      body: _wishList.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: _wishList.length,
              itemBuilder: (context, index) {
                final wishData = _wishList.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(wishData.productImages[0]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wishData.productName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  Text(
                                    '\$' +
                                        wishData.productPrice
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow.shade900,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _favoriteProvider
                                          .removeIndividualFavoriteItem(
                                              wishData.productId);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/images/empty.png'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "You don't have any favorite item!",
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
