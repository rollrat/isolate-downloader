# isolate downloader

[![pub package](https://img.shields.io/pub/v/isolate_downloader.svg)](https://pub.dev/packages/isolate_downloader)

Download multiple files at the same time.

## Getting started

## Usage

```dart
//
//  set the maximum number of tasks you want to download at the same time.
//  default jobCount is 4
//
final downloader = await IsolateDownloader.getInstance(jobCount: 2);

//
//  wait for downloader is ready
//
while (!downloader.isReady()) {
  await Future.delayed(const Duration(milliseconds: 100));
}

//
//  create task
//
final task = DownloadTask.create(
  taskId: 0,
  url: 'http://212.183.159.230/512MB.zip',
  downloadPath: 'large.file',
);

//
//  download callbacks
//  if you don't want it, you don't have to set it.
//
bool isComplete = false;
late double totalSize = 0;
double downloadSize = 0;

task.sizeCallback = (sz) => totalSize = sz;
task.downloadCallback = (sz) {
  downloadSize += sz;
  print(
      '[${(downloadSize / totalSize * 100).toStringAsFixed(1)}%] $downloadSize/$totalSize');
};
task.completeCallback = () => isComplete = true;

//
//  append task
//
downloader.appendTask(task);

//
//  wait for complete
//
while (!isComplete) {
  await Future.delayed(const Duration(milliseconds: 100));
}
```

You can also implement like `polling` rather than `callback`.
The implementation of `polling` eliminates the dependency of `the downloader` by `the UI`.

```dart
while (!isComplete) {
  //
  //  get task status by taskid
  //
  print(downloader.getStatus(0).state);
  print(downloader.getStatus(0).totalSize);
  print(downloader.getStatus(0).countSize);
  await Future.delayed(const Duration(milliseconds: 100));
}
```