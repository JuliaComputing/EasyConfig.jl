# EasyConfig

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://joshday.github.io/EasyConfig.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://joshday.github.io/EasyConfig.jl/dev)
[![Build Status](https://travis-ci.com/joshday/EasyConfig.jl.svg?branch=master)](https://travis-ci.com/joshday/EasyConfig.jl)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)


**EasyConfig** provides a nested `OrderedDict{Symbol, Any}` data structure with easy-to-use 
`getproperty`/`setproperty!` syntax and pretty printing.

You can assign values 
multiple levels deep before the levels above it exist.

```julia
using EasyConfig

conf = Config()

conf.data.x = 1:100
conf.data.y = rand(100)
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

Objects are easily joinable:

```
trace1 = config()
trace1.x = 1:10
trace1.y = rand(10)
trace2.type = "scatter"

trace2 = config()
trace2.x = 1:10
trace2.y = randn(10)
trace2.type = "bar"

layout = config()
layout.title = "My Title"
layout.xaxis.title = "X"
layout.yaxis.title = "Y"

output = config()
output.data = [trace1, trace2]
output.layout = layout
output
```