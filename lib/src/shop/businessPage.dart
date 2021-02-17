import 'package:flutter/material.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:localstorage/localstorage.dart';
import 'package:fitemos/src/shop/productPage.dart';
import 'package:fitemos/src/utils/apiDataSource.dart';
import 'package:google_fonts/google_fonts.dart';


class Business extends StatefulWidget {
  dynamic params;
  Business({Key key, this.params}) : super(key: key);

  @override
  _businessState createState() => _businessState();
}

class _businessState extends State<Business> {
  get item => widget.params;
  RestDatasource api = new RestDatasource();
  final LocalStorage storage = new LocalStorage('fitemos_store');
  dynamic productItems;


  _getShopItem(String pageSize, String pageNumber, String itemId) async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.getShopItem(pageSize, pageNumber, accessToken, itemId).then((GetShopItem item) {
      setState(() {
        productItems = item.returnData['products']['data'];
      });
    }).catchError(( error) {
    });
  }

  @override
  void initState() {
    super.initState();
    _getShopItem('100', '0', item['id'].toString());
  }

  Widget _backButton() {
    return  Container(
      padding: EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width,
      height: 90,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 15, top: 11, bottom: 10),
                child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              )),
          Container(
              padding: EdgeInsets.only(left: 6, top: 11, bottom: 10),
              child: Text(item['name'],
                style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333))),
          ),
        ],
      ),
    );
  }

  Widget _productDescription() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric( horizontal: 20),
      child: Text(item['description'] ,
        style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xff333333))),
    );
  }

  Widget _productItem(product) {
    final width = MediaQuery.of(context).size.width - 45;
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(params: product)));
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: width/2-5,
                          height: 120,
                          child: Image.network(
                            product['media_url'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: width/2-5,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
                          color: Color(0xffFFFFFF)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 8),
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: product['name'],
                                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333)))),
                            SizedBox(height: 5),
                            product['discount'] == null?
                            RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: '',
                                    children: [
                                      TextSpan(
                                        text: '\$${product['regular_price']}',
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff333333),
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  \$${product['price']}',
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffEB5757),
                                        ),
                                      ),
                                    ]
                                )
                            )
                            : RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: '',
                                    children: [
                                      TextSpan(
                                        text: '${product['discount']}% descuento',
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffEB5757),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            SizedBox(height: 8),
                          ]
                      )
                  ),
                ]
            )
        )
    );
  }

  Widget _productHeader() {
    final width = MediaQuery.of(context).size.width - 40;
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric( horizontal: 20),
        child: Row(
          children: <Widget>[
            Container(
              width: 130,
              height: 111,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Image.network(
                  item['logo'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                width: width-130,
                padding: EdgeInsets.only(top: 0, left: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text( item['website_url'],
                        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xff2D9CDB))),
                      Text(item['address'],
                          style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff333333))),
                ]
                )
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color(0xffFFFFFF)),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 100),
                      _productHeader(),
                      SizedBox(height: 20),
                      _productDescription(),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13),
                        child: GridView.count(
                          padding: EdgeInsets.all(0.0),
                          crossAxisCount: 2 ,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(productItems != null? productItems.length : 0, (index){
                            return Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    _productItem(productItems[index]),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Positioned(top: 0, left: 0, child: _backButton()),
            ],
          ),
        )
    );
  }
}