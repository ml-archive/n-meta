# Meta
[![Swift Version](https://img.shields.io/badge/Swift-3.1-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-F6CBCA.svg)](http://vapor.codes)
[![Build Status](https://img.shields.io/circleci/project/github/nodes-vapor/meta.svg)](https://circleci.com/gh/nodes-vapor/meta)
[![codebeat badge](https://codebeat.co/badges/52c2f960-625c-4a63-ae63-52a24d747da1)](https://codebeat.co/projects/github-com-nodes-vapor-meta)
[![codecov](https://codecov.io/gh/nodes-vapor/meta/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/meta)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/meta)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/meta)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/meta/master/LICENSE)


This package enforces clients to send a specific header in all requests:

```
[PLATFORM];[ENVIROMENT];[APP_VERSION];[DEVICE_OS];[DEVICE]
```

This header can look like this `android;production;1.2.3;4.4;Samsung S7`
 - platform
 - environment
 - app version
 - device os
 - device

For web platform only platform and enviroment is required, since rest can be found in `User-Agent`.

Why not just use `User-Agent`?
 - `User-Agent` is missing some of these details
 - `User-Agent` can be hard to extend/override
 - Default `User-Agent` in iOS & Android can be their client (OkHttp, Alamofire etc).


## 📦 Installation

Update your `Package.swift` file.
```swift
.Package(url: "https://github.com/nodes-vapor/meta", majorVersion: 0)
```

Create config `meta.json`:

```
{
    "header": "N-Meta",
    "platforms": [
        "web",
        "android",
        "ios",
        "windows"
    ],
    "environments": [
        "local",
        "development",
        "staging",
        "production"
    ],
    "exceptPaths": [
        "/js/*",
        "/css/*",
        "/images/*",
        "/favicons/*"
    ],
    "requiredEnvironments": [
        "local",
        "development",
        "staging",
        "production"
    ]
}
```


## Getting started 🚀

```
import Meta
```

Add middleware direcetly to your api groups:

```swift
drop.group(MetaMiddleware(drop: drop)) { metaRoutes in
     //Routes
}
```

or add middleware global (will be loaded for all requests):

```swift
try drop.middleware.append(MetaMiddleware(drop: drop))
```


## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodesagency.com).
The package owner for this project is [John](https://github.com/Mircea-Ciuchea).


## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
