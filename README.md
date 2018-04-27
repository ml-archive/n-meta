# Meta
[![Swift Version](https://img.shields.io/badge/Swift-4-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-3-F6CBCA.svg)](http://vapor.codes)
[![Circle CI](https://circleci.com/gh/nodes-vapor/meta/tree/master.svg?style=shield)](https://circleci.com/gh/nodes-vapor/meta)
[![codebeat badge](https://codebeat.co/badges/69e8f2c3-2acb-417d-93a9-c82d5920d82b)](https://codebeat.co/projects/github-com-nodes-vapor-meta-master)
[![codecov](https://codecov.io/gh/nodes-vapor/meta/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/meta)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/meta)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/meta)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/meta/master/LICENSE)


This package enforces clients to send a specific header in all requests:

```
NMeta: [PLATFORM];[ENVIRONMENT];[APP_VERSION];[DEVICE_OS];[DEVICE]
```

For earlier support
[Vapor 1.x](https://github.com/nodes-vapor/n-meta/tree/vapor-1)
[Vapor 2.x](https://github.com/nodes-vapor/n-meta/tree/vapor-2)


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
.Package(url: "https://github.com/nodes-vapor/meta", majorVersion: 3)
```

Register in configure.swift:

```
services.register(NMetaConfig.self)
```


## Getting started 🚀

```swift
import class NMeta.Middleware
```

Add middleware directly to your routes:

```swift
    router.grouped(NMetaMiddleware()).get("hello") { req in
        return "Hello, world!"
    }
    // ...
}
```

or add the middleware globally (e.g. in `configure.swift`) which will add it to all routes:

```swift
middlewares.use(NMetaMiddleware.self)
```

## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodesagency.com).
The package owner for this project is [Steffen](https://github.com/steffendsommer).


## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
