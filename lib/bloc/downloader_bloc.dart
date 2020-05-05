import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:social_downloader/resources/instagram_model.dart';
import 'package:equatable/equatable.dart';

part 'downloader_event.dart';
part 'downloader_state.dart';

class DownloaderBloc extends Bloc<DownloaderEvent, DownloaderState> {
  Dio _dio = Dio();

  BehaviorSubject<double> _progressDownload = BehaviorSubject.seeded(0.0);
  BehaviorSubject<bool> _isShowFloating = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _isVideo = BehaviorSubject.seeded(false);
  BehaviorSubject<String> _displayUrl = BehaviorSubject();

  Stream<String> get displayUrl => _displayUrl.stream;
  Stream<double> get progressDownload => _progressDownload.stream;
  Stream<bool> get isShowFloating => _isShowFloating.stream;
  Stream<bool> get isVideo => _isVideo.stream;

  @override
  get initialState => DownloaderStateEmpty();

  void dispose() {
    _progressDownload.close();
    _isShowFloating.close();
    _displayUrl.close();
    _isVideo.close();
  }

  @override
  Stream<DownloaderState> mapEventToState(DownloaderEvent event) async* {
    if (event is DownloadStart) {
      _progressDownload.sink.add(0.0);

      final String url = event.url;
      final String filename = event.filename;
      final String displayUrl = event.displayUrl;
      final bool isVideo = event.isVideo;

      _displayUrl.sink.add(displayUrl);
      _isVideo.sink.add(isVideo);
      await _downloadFile(url, filename);
    }
    if (event is TextChanged) {
      final String url = event.text;
      if (url.isEmpty) {
        yield DownloaderStateEmpty();
      } else {
        yield DownloaderStateLoading();
        _isShowFloating.sink.add(false);
        _progressDownload.sink.add(0.0);
        try {
          var response = await _dio.get(url);
          var sc = getInstagramData(response);
          _isShowFloating.sink.add(true);
          yield DownloaderStateSuccess(model: sc);
        } catch (error) {
          yield error is DownloaderStateError
              ? DownloaderStateError(error.message)
              : DownloaderStateError('something went wrong');
        }
      }
    }
  }

  ShortcodeMedia getInstagramData(Response response) {
    var document = parse(response.data);
    var element = document.querySelectorAll('script');
    List<Element> data =
        element.where((i) => i.text.contains("_sharedData")).toList();
    Map<String, dynamic> raw =
        jsonDecode(data.first.text.substring(21, data.first.text.length - 1));
    InstagramModel result =
        InstagramModel.fromJson(raw['entry_data']['PostPage'][0]);
    ShortcodeMedia sc = result.graphql.shortcodeMedia;
    return sc;
  }

  static var httpClient = new HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    String dir;
    if (Platform.isAndroid) {
      dir = '/storage/emulated/0/Download';
    } else if (Platform.isIOS) {
      dir = (await getDownloadsDirectory()).path;
    }
    bool exists = await Directory(dir + '/SocialDownloader').exists();

    if (!exists) {
      new Directory(dir + '/SocialDownloader').create(recursive: true);
    }
    var response = await _dio.getUri(Uri.parse(url),
        options: Options(
            responseType: ResponseType.bytes,
            validateStatus: (status) {
              return status < 500;
            }), onReceiveProgress: (receive, total) {
      _progressDownload.sink.add((receive / total).toDouble());
    });
    File file = new File('$dir/SocialDownloader/$filename');
    await file.writeAsBytes(response.data);
    return file;
  }
}
