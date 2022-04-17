import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_downloader/isolate_downloader.dart';

void main() {
  test('Download Task Test', () async {
    final downloader = await IsolateDownloader.getInstance(jobCount: 2);

    while (!downloader.isReady()) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final task = DownloadTask.create(
      taskId: 0,
      url: 'http://212.183.159.230/512MB.zip',
      downloadPath: 'large.file',
    );

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

    downloader.appendTask(task);

    while (!isComplete) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  });
}
