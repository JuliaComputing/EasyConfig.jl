# EasyConfig

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://joshday.github.io/EasyConfig.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://joshday.github.io/EasyConfig.jl/dev)
[![Build Status](https://travis-ci.com/joshday/EasyConfig.jl.svg?branch=master)](https://travis-ci.com/joshday/EasyConfig.jl)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)


**EasyConfig** provides essentially a nested `Dict{Symbol, Any}` data structure.  You can assign values 
multiple levels deep before the levels above it exist.

```julia
using EasyConfig

conf = config()

conf.data.x = 1:10
conf.data.y = rand(10)
conf.data.type = "scatter"
conf.layout.title = "My Title"
conf.layout.xaxis.title = "X Axis"
conf.layout.yaxis.title = "Y Axis"

conf
```

You can then get a JSON string via

```
EasyConfig.json(conf)
```