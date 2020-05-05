import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_it/share_it.dart';
import 'package:social_downloader/bloc/downloader_bloc.dart';
import 'package:social_downloader/resources/instagram_model.dart';
import 'package:social_downloader/ui/widgets/video_widget.dart';

class DownloaderScreen extends StatefulWidget {
  static const id = 'DownloaderScreen';
  @override
  _DownloaderScreenState createState() => _DownloaderScreenState();
}

class _DownloaderScreenState extends State<DownloaderScreen> {
  TextEditingController _controller = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DownloaderBloc _bloc;
  int _current = 0;
  String _caption = "";
  List<Edges2> _mediaUrl = [];
  ShortcodeMedia _sc;

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DownloaderBloc>(
      create: (context) => DownloaderBloc(),
      child: Builder(builder: (context) {
        _bloc = BlocProvider.of<DownloaderBloc>(context);
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Instagram Downloader'),
            centerTitle: true,
          ),
          body: BlocBuilder<DownloaderBloc, DownloaderState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is DownloaderStateSuccess) {
                _sc = state.model;
                _caption = state.model.edgeMediaToCaption.edges.first.node.text;
              }

              return ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _controller.clear();
                                    setState(() {});
                                  }),
                              hintText: 'Enter URL here...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.zero,
                                      bottomRight: Radius.zero))),
                        ),
                      ),
                      Flexible(
                          child: ButtonTheme(
                        height: 60.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (_controller.text.isEmpty) {
                              Clipboard.getData('text/plain').then((value) {
                                _controller.text = value.text;
                              });
                            } else {
                              if (FocusScope.of(context).hasFocus) {
                                FocusScope.of(context).unfocus();
                              }
                              _mediaUrl.clear();
                              _current = 0;
                              _bloc.add(TextChanged(text: _controller.text));
                            }
                            setState(() {});
                          },
                          child: Text(
                            _controller.text.isEmpty ? 'Paste' : 'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                      child: state is DownloaderStateSuccess
                          ? Column(
                              children: <Widget>[
                                state.model.edgeSidecarToChildren != null
                                    ? CarouselSlider(
                                        options: CarouselOptions(
                                            aspectRatio: 1.0,
                                            viewportFraction: 1.0,
                                            enableInfiniteScroll: false,
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                _current = index;
                                              });
                                            }),
                                        items: state
                                            .model.edgeSidecarToChildren.edges
                                            .map((i) {
                                          return SliderImageWidget(
                                            displayUrl: i.node.displayUrl,
                                            isVideo: i.node.isVideo,
                                            videoUrl: i.node.videoUrl,
                                          );
                                        }).toList())
                                    : SliderImageWidget(
                                        displayUrl: state.model.displayUrl,
                                        isVideo: state.model.isVideo,
                                        videoUrl: state.model.videoUrl,
                                      ),
                                state.model.edgeSidecarToChildren != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: state
                                            .model.edgeSidecarToChildren.edges
                                            .map((url) {
                                          int index = state
                                              .model.edgeSidecarToChildren.edges
                                              .indexOf(url);
                                          _mediaUrl = state.model
                                              .edgeSidecarToChildren.edges;

                                          return Container(
                                            width: 8.0,
                                            height: 8.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 2.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _current == index
                                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                                  : Color.fromRGBO(
                                                      0, 0, 0, 0.4),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : Container(),
                                Text(_caption),
                              ],
                            )
                          : state is DownloaderStateLoading
                              ? LinearProgressIndicator()
                              : Container()),
                ],
              );
            },
          ),
          floatingActionButton: StreamBuilder<bool>(
              stream: _bloc.isShowFloating,
              initialData: false,
              builder: (context, snapshot) {
                if (!snapshot.data) {
                  return Container();
                }
                return FabCircularMenu(
                  animationDuration: Duration(milliseconds: 500),
                  fabOpenIcon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  fabCloseIcon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  ringDiameter: 200.0,
                  ringWidth: 40.0,
                  ringColor: Colors.transparent,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () async {
                        File file;
                        String filename = getFileName(
                            _mediaUrl[_current].node.isVideo
                                ? _mediaUrl[_current].node.videoUrl
                                : _mediaUrl[_current].node.displayUrl);
                        if (Platform.isAndroid) {
                          file = File(
                              '/storage/emulated/0/SocialDownloader/$filename');
                        } else if (Platform.isIOS) {
                          file = File((await getDownloadsDirectory()).path +
                              '/$filename}');
                        }
                        _copyCaption();
                        ShareIt.file(
                            path: file.path,
                            type: _mediaUrl[_current].node.isVideo
                                ? ShareItFileType.video
                                : ShareItFileType.image);
                      },
                      tooltip: 'Repost',
                      child: Icon(Icons.share),
                    ),
                    FloatingActionButton(
                      onPressed: () => showDownloadOption(context),
                      tooltip: 'Download',
                      child: Icon(Icons.file_download),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        _copyCaption();
                      },
                      tooltip: 'Copy Caption',
                      child: Icon(Icons.content_copy),
                    ),
                  ],
                );
              }),
        );
      }),
    );
  }

  void _copyCaption() {
    Clipboard.setData(ClipboardData(text: _caption));
    final SnackBar snackBar = SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(
          'Caption has been copy',
          textAlign: TextAlign.center,
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String getFileName(String url) {
    return url.substring(url.lastIndexOf('/') + 1, url.indexOf('?'));
  }

  String getUrl(int position) {
    return _mediaUrl.isNotEmpty
        ? _mediaUrl[position].node.isVideo
            ? _mediaUrl[position].node.videoUrl
            : _mediaUrl[position].node.displayUrl
        : _sc.isVideo ? _sc.videoUrl : _sc.displayUrl;
  }

  Future<void> showDownloadOption(BuildContext context) async {
    return await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  String url = getUrl(_current);
                  String filename = getFileName(url);

                  String displayUrl = _mediaUrl.isNotEmpty
                      ? _mediaUrl[_current].node.displayUrl
                      : _sc.displayUrl;

                  Navigator.pop(context);

                  ProgressDownloadWidget.show(
                      _scaffoldKey.currentContext, _bloc);

                  _bloc.add(DownloadStart(
                      filename: filename,
                      url: url,
                      displayUrl: displayUrl,
                      isVideo: _mediaUrl.isNotEmpty
                          ? _mediaUrl[_current].node.isVideo
                          : _sc.isVideo));
                },
                child: Text(
                    '${_mediaUrl.isNotEmpty ? 'Download Current' : 'Download'}'),
              ),
              _mediaUrl.isNotEmpty
                  ? SimpleDialogOption(
                      onPressed: () async {
                        Navigator.pop(context);
                        ProgressDownloadWidget.show(
                            _scaffoldKey.currentContext, _bloc);

                        for (Edges2 e in _mediaUrl) {
                          String url = getUrl(_mediaUrl.indexOf(e));
                          String filename = getFileName(url);
                          String displayUrl = e.node.displayUrl;

                          _bloc.add(DownloadStart(
                              filename: filename,
                              url: url,
                              isVideo: e.node.isVideo,
                              displayUrl: displayUrl));
                        }
                      },
                      child: const Text('Download All'),
                    )
                  : Container()
            ],
          );
        });
  }
}

class SliderImageWidget extends StatelessWidget {
  const SliderImageWidget({
    Key key,
    this.displayUrl,
    this.isVideo,
    this.videoUrl,
  }) : super(key: key);

  final String displayUrl;
  final bool isVideo;
  final String videoUrl;
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: displayUrl,
          width: double.infinity,
          placeholder: (context, placeholder) {
            return Center(
                child: Icon(
              Icons.image,
              size: 120,
            ));
          },
        ),
        isVideo == true
            ? Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: FlatButton(
                  onPressed: () {
                    VideoWidget.show(context, videoUrl);
                  },
                  child: Icon(
                    Icons.play_arrow,
                    size: 96.0,
                    color: Colors.white,
                  ),
                ))
            : Container()
      ],
    );
  }
}

class ProgressDownloadWidget extends StatelessWidget {
  final DownloaderBloc bloc;
  static void show(BuildContext context, DownloaderBloc bloc) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: ProgressDownloadWidget(
              bloc: bloc,
            ),
          );
        });
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }

  ProgressDownloadWidget({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<String>(
              stream: bloc.displayUrl,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: snapshot.data,
                      height: 100.0,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: StreamBuilder<bool>(
                          initialData: false,
                          stream: bloc.isVideo,
                          builder: (context, snapshot) {
                            if (!snapshot.data) {
                              return Container();
                            }
                            return Icon(
                              Icons.videocam,
                              color: Colors.white,
                            );
                          }),
                    )
                  ],
                );
              }),
          StreamBuilder<double>(
              stream: bloc.progressDownload,
              initialData: 0.0,
              builder: (context, snapshot) {
                return CircularPercentIndicator(
                  radius: 40.0,
                  progressColor: Colors.blue,
                  percent: snapshot.data,
                  backgroundColor: Colors.white,
                  center: Text((snapshot.data * 100).toStringAsFixed(0)),
                );
              }),
        ],
      ),
    );
  }
}
