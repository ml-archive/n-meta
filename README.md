# Meta
[![Swift Version](https://img.shields.io/badge/Swift-3-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-F6CBCA.svg)](http://vapor.codes)
[![Circle CI](https://circleci.com/gh/nodes-vapor/meta/tree/master.svg?style=shield)](https://circleci.com/gh/nodes-vapor/meta)
[![codebeat badge](https://codebeat.co/badges/69e8f2c3-2acb-417d-93a9-c82d5920d82b)](https://codebeat.co/projects/github-com-nodes-vapor-meta-master)
[![codecov](https://codecov.io/gh/nodes-vapor/meta/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/meta)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/meta)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/meta)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/meta/master/LICENSE)


This package enforces clients to send a specific header in all requests:

```
[PLATFORM];[ENVIRONMENT];[APP_VERSION];[DEVICE_OS];[DEVICE]
```

This header can look like this `android;production;1.2.3;4.4;Samsung S7`
 - platform
 - environment
 - app version
 - device os
 - device

For web platform only platform and environment is required, since the rest can be found in `User-Agent`.

Why not just use `User-Agent`?
 - `User-Agent` is missing some of these details
 - `User-Agent` can be hard to extend/override
 - Default `User-Agent` in iOS & Android can be their client (OkHttp, Alamofire etc).


## 📦 Installation

Update your `Package.swift` file.
```swift
.Package(url: "https://github.com/nodes-vapor/meta", majorVersion: 2)
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

```swift
import class Meta.Middleware
```

Add middleware directly to your API groups (e.g. in `Droplet+Setup.swift`):

```swift
let metaMiddleware = try Meta.Middleware(config: self.config)
self.group(middleware: [metaMiddleware]) { metaRoutes in
    // ...
}
```

or add the middleware globally (e.g. in `Config+Setup.swift`) which will add it to all routes:

```swift
addConfigurable(middleware: Meta.Middleware.init, name: "meta")
```

Don't forget to add the middleware to your `droplet.json` config as well.


## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodesagency.com).
The package owner for this project is [John](https://github.com/John-Ciuchea).


## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
