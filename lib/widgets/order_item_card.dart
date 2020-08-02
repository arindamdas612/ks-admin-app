import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/orders.dart';

import './order_status_chip.dart';

import '../models/http_exception.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({
    Key key,
    @required this.orderItem,
  }) : super(key: key);

  final Map<String, dynamic> orderItem;

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error Occured'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productThumbnail = Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        alignment: FractionalOffset.centerLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            color: Colors.white,
            height: 80,
            width: 80,
            child: Image(
              image: orderItem['imageUrl'] == null
                  ? AssetImage("assets/images/image_place_holder.png")
                  : NetworkImage(orderItem['imageUrl']),
              fit: BoxFit.cover,
            ),
          ),
        ));

    final productCard = GestureDetector(
        onDoubleTap: () async {
          bool noStock = orderItem['status'] == 'No Stock' ? true : false;
          try {
            await Provider.of<Orders>(context, listen: false)
                .changeItemStatus(orderItem['id'], noStock);
            Toast.show("Order Item Status flipped", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          } on HttpException catch (error) {
            _showErrorDialog('Could not update Order Item Status', context);
          } catch (error) {
            _showErrorDialog('Error occured. Try Again', context);
          }
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 46.0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(5, 117, 102, 0.2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: ListTile(
            title: Container(
              margin: const EdgeInsets.only(left: 25, top: 20),
              child: Text(
                orderItem['productTitle'],
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
            ),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: <Widget>[
                      Text(
                        orderItem['qty'].toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.greenAccent,
                      ),
                      Text(
                        '${orderItem['unitPrice']} ₹',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25, bottom: 20, top: 10),
                  child: OrderStatusChip(itemStatus: orderItem['status']),
                ),
              ],
            ),
            trailing: Text(
              '₹ ${orderItem['totalPrice'].toString()}',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ));
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: <Widget>[productCard, productThumbnail],
      ),
    );
  }
}
