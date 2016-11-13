This package is created to enforce important information about the client

User-Agent header covers some of the important fields. But is missing few also.
On top of that it's not always possible to override

Here in Nodes we decided to enforce a strict pattern for this.

#Installation

#### Config
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
    "exceptedPaths": [
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

And add middleware
```
drop.middleware.append(MetaMiddleware(drop: drop))
```
