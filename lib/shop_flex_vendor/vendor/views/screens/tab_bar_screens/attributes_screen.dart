import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/providers/product_provider.dart';



class AttributesScreen extends StatefulWidget {
  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _sizeController = TextEditingController();
  List<String> _sizeList = [];
  bool isSaved = false;
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
             validator: (value) {
                if(value!.isEmpty) {
                  return 'The brand name is required';
                } else {
                  return null;
                }
              },
            onChanged: (value) {
              _productProvider.getFormData(brandName: value);
            },
            decoration: InputDecoration(
                labelText: 'Brand',
                hintText: 'Enter your brand name',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 3,
                )),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Container(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        isTyping = true;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'size',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 3,
                        )),
                    controller: _sizeController,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            isTyping
                ? ElevatedButton(
                    onPressed: () {
                      _sizeList.add(_sizeController.text);
                      setState(() {
                        isTyping = false;
                      });
                      _sizeController.clear();
                      print(_sizeList);
                    },
                    child: Text('Add size'),
                  )
                : Text(''),
          ],
        ),
        if (_sizeList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _sizeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onDoubleTap: () {
                        setState(() {
                          _sizeList.removeAt(index);
                        });
                        _productProvider.getFormData(sizeList: _sizeList);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _sizeList[index].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        if (_sizeList.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              setState(() {
                isSaved = true;
              });
              _productProvider.getFormData(sizeList: _sizeList);
            },
            child: isSaved ? Text('saved') : Text('Save'),
          ),
      ],
    );
  }
}
