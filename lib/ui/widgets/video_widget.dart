import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  VideoWidget({this.videoUrl});
  static void show(BuildContext context, String videoUrl) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => VideoWidget(videoUrl: videoUrl),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();

    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: size.height * 0.5,
        child: WillPopScope(
          child: Stack(
            fit: StackFit.passthrough,
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _controller.value.initialized
                      ? VideoPlayer(_controller)
                      : Center(child: CircularProgressIndicator())),
              Positioned(
                top: -24,
                left: -40,
                child: FlatButton(
                  onPressed: () {
                    VideoWidget.hide(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 48.0,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
          onWillPop: () async => false,
        ),
      ),
    );
  }
}
