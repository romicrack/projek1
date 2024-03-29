import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: Shimmer.fromColors(
            baseColor: Color(0xFFb8b4b4),
            highlightColor: Color(0xFFe8e6e6),
            enabled: true,
            child: ListView.builder(
              itemBuilder: (_, __) => Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
