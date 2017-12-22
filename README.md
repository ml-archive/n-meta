# Meta
[![Swift Version](https://img.shields.io/badge/Swift-3-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-F6CBCA.svg)](http://vapor.codes)
[![Circle CI](https://circleci.com/gh/nodes-vapor/meta/tree/vapor-1.svg?style=shield)](https://circleci.com/gh/nodes-vapor/meta)
[![codebeat badge](https://codebeat.co/badges/0acbc026-3f2b-47c6-b2aa-c1585e3af952)](https://codebeat.co/projects/github-com-nodes-vapor-meta-vapor-1)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/meta)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/meta)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/meta/master/LICENSE)


This package enforces clients to send a specific header in all requests. 

### [PLATFORM];[ENVIRONMENT];[APP_VERSION];[DEVICE_OS];[DEVICE]

This header can look like this android;production;1.2.3;4.4;Samsung S7
 - platform
 - environment
 - app version
 - device os
 - device

For web platform only platform and enviroment is required, since rest can be found in User-Agent

Why not just use User-Agent
 - User-Agent is missing some of these details
 - User-Agent can be hard to extend / override
 - Default User-Agent in iOS & Android can be their client (OkHttp, Alamo Fire etc)

#Installation

#### Config
Update your `Package.swift` file.
```swift
.Package(url: "https://github.com/nodes-vapor/meta", majorVersion: 0)
```

Create config meta.json

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

### main.swift
```
import Meta
```
Add middleware direcetly to your api groups
```swift
drop.group(MetaMiddleware(drop: drop)) { metaRoutes in
     //Routes
}
```
or add middleware global (will be loaded for all requests)
```swift
try drop.middleware.append(MetaMiddleware(drop: drop))
```
