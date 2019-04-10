import 'dart:async';
import 'package:flutter/cupertino.dart';

void main() => runApp(App());

final image = AssetImage('assets/city.jpg');

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(
      //   middle: Text('Cards'),
      //   backgroundColor: Color(0xffffffff),
      // ),
      child: SafeArea(
        child: AnimatedTitlePageView(
          pageCount: 3,
          titleBuilder: (_, idx) {
            return Padding(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 0.0),
              child: Text(
                'This is title of page $idx',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          bodyBuilder: (_, idx) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 30.0,
                right: 16.0,
                left: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: const Offset(0, 10.0),
                      blurRadius: 20.0,
                      color: Color.fromRGBO(0, 0, 0, .19),
                    ),
                    BoxShadow(
                      offset: const Offset(0, 6.0),
                      blurRadius: 6.0,
                      color: Color.fromRGBO(0, 0, 0, .23),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xffffffff),
                  // image: DecorationImage(
                  //   image: image,
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnimatedTitlePageView extends StatefulWidget {
  AnimatedTitlePageView({
    Key key,
    @required this.titleBuilder,
    @required this.bodyBuilder,
    @required this.pageCount,
  })  : assert(titleBuilder != null),
        assert(bodyBuilder != null),
        assert(pageCount != null),
        super(key: key);

  final IndexedWidgetBuilder bodyBuilder;
  final IndexedWidgetBuilder titleBuilder;
  final int pageCount;

  @override
  _AnimatedTitlePageViewState createState() => _AnimatedTitlePageViewState();
}

double mapValue(double value, double low1, double high1, double low2, double high2) {
  return low2 + (high2 - low2) * (value - low1) / (high1 - low1);
}

class _AnimatedTitlePageViewState extends State<AnimatedTitlePageView> {
  final _controller = PageController(
    // viewportFraction: 0.9,
    initialPage: 0,
  );
  double _prevPage = 0.0;
  double _offset = 0.0;

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    final off = (_prevPage - _controller.page).abs() * 100;
    setState(() {
      _offset = off > 50.0 ? 50.0 : off;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      onPageChanged: (idx) => _prevPage = idx.toDouble(),
      itemCount: widget.pageCount,
      itemBuilder: (ctx, idx) {
        final yOff = idx == _prevPage.toInt() ? _offset : 100.0 - _offset;
        final opacity = idx == _prevPage.toInt() ? mapValue(_offset, 0.0, 50.0, 1.0, 0.0) : 1.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0.0, yOff),
              child: Opacity(
                opacity: opacity,
                child: widget.titleBuilder(ctx, idx),
              ),
            ),
            Expanded(
              key: ValueKey('page_body_$idx'),
              child: widget.bodyBuilder(ctx, idx),
            )
          ],
        );
      },
    );
  }
}
