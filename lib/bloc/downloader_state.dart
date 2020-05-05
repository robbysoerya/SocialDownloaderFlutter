part of 'downloader_bloc.dart';

abstract class DownloaderState extends Equatable {
  const DownloaderState();

  @override
  List<Object> get props => [];
}

class DownloaderStateEmpty extends DownloaderState {}
class DownloaderStateLoading extends DownloaderState {}
class DownloaderStateCopy extends DownloaderState {}
class DownloaderStateRunning extends DownloaderState {}
class DownloaderStateError extends DownloaderState {
  final String message;
  DownloaderStateError(this.message);
}
class DownloaderStateSuccess extends DownloaderState {
  final ShortcodeMedia model;

  const DownloaderStateSuccess({this.model});

  @override
  List<Object> get props => [model];

  @override
  String toString() {
    return 'DownloaderStateSuccess {model: $model}';
  }
}