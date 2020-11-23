# Flutter for web Build Pipeline Script
This code came from the need to use Flutter for web using existing cloud build tools.

## Installation
The installation of this script is as lightweight as possible.
1. Place the `build-web.sh` script beside your pubspec.yaml file.
2. Add the following command to your pipeline.
```bash
$ sh ./build-web.sh
```

You may need to change the path depending on your repo structure.

## How it works
The script installs the beta version of Flutter to your deploy pipline container. If your build pipeline caches assets this process will not be repeated.

## Assets
Flutter for web moves your static assets under a new `/assets/` folder. The path in the sever looks like `/assets/myAssets/*`. This results in some 404 errors.

The script assumes you have an `/assets` folder in your project where your images and other static assets are stored and copies them to the expected location.
