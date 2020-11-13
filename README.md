# EasyConfig

[![Build Status](https://travis-ci.com/joshday/EasyConfig.jl.svg?branch=master)](https://travis-ci.com/joshday/EasyConfig.jl)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)


**EasyConfig** provides an easy-to-use nested `AbstractDict{Symbol, Any}` data structure. 


## Advantages over other dictionary types:

The advantages are twofold.

### 1) Intermediate levels are created on the fly:

```julia
c = Config().one.two.three = 1
```

vs.

```julia
c = OrderedDict(:one => OrderedDict(:two => OrderedDict(:three => 1)))
```

### 2) Values can be accessed via `getproperty`:

```julia
c.one.two.three == 1
```

vs.

```julia
c[:one][:two][:three] == 1
```

## Conversion to JSON

Available via `JSON3`

```julia
JSON3.write(Config(x=1,y=2,z=[3,4]))
```
