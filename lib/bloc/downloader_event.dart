part of 'downloader_bloc.dart';

abstract class DownloaderEvent extends Equatable {
  const DownloaderEvent();

  @override
  List<Object> get props => [];
}

class TextChanged extends DownloaderEvent {
  final String text;

  const TextChanged({this.text});

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'TextChanged {text: $text}';
  }
}

class DownloadStart extends DownloaderEvent {
  final String url;
  final String filename;
  final String displayUrl;
  final bool isVideo;

  const DownloadStart({this.url,this.filename,this.displayUrl,this.isVideo});

  @override
  List<Object> get props => [url,filename,displayUrl,isVideo];

  @override
  String toString() {
    return 'DownloadStart {url: $url,filename: $filename, displayUrl: $displayUrl, isVideo: $isVideo}';
  }
   
}