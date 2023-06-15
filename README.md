[![Build status](https://github.com/joshday/EasyConfig.jl/workflows/CI/badge.svg)](https://github.com/joshday/EasyConfig.jl/actions?query=workflow%3ACI+branch%3Amaster)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)
[![deps](https://juliahub.com/docs/EasyConfig/deps.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix?t=2)
[![version](https://juliahub.com/docs/EasyConfig/version.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix)
[![pkgeval](https://juliahub.com/docs/EasyConfig/pkgeval.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix)


<h1 align="center">EasyConfig</h1>

- **EasyConfig** provides a friendly-syntax, nested `AbstractDict{Symbol, Any}` data structure.
- The advantages over other `AbstractDict/NamedTuple`s are:

## 1) Intermediate levels are created on the fly:

- This is quite convenient for working with JSON specs (e.g. [PlotlyLight.jl](https://github.com/JuliaComputing/PlotlyLight.jl)).


```julia
c = Config()
c.one.two.three = 1
```

<br>

- Compare this to `OrderedDict` and `NamedTuple`:

```julia
c = OrderedDict(:one => OrderedDict(:two => OrderedDict(:three => 1)))

c = (one = (two = (three = 1,),),)

c = (; one = (;two = (;three = 1)))
```

<br><br>

## 2) Easy to Use Both Interactively and Programmatically

- You can use any combination of `String`/`Symbol` with `getproperty`/`getindex`.
- For working *interactively*, `getproperty` is the most convenient to work with.
- For working *programmatically*, `getindex` is the most convenient to work with.

```julia
# getproperty
c.one.two.three

# getindex
c[:one][:two][:three]

# mix and match
c["one"].two."three"
```

<br><br>

# `@config`

Create a `Config` with a NamedTuple-like or block syntax. The following examples create equivalent `Config`s:

```julia
@config (x.one=1, x.two=2, z=3)

@config x.one=1 x.two=2 z=3

@config begin
    x.one = 1
    x.two = 2
    z = 3
end

let
    c = Config()
    c.x.one = 1
    c.x.two = 2
    c.z = 3
end
```


# Note

- Accessing a property that doesn't exist will create an empty `Config()`.
- Clean up stranded empty `Config`s with `delete_empty!(::Config)`.

```julia
c = Config()

c.one.two.three.four.five.six == Config()

# Internally we make the assumption that empty Config's shouldn't be there.
# Some functions will therefore call `delete_empty!` under the hood:
isempty(c) == true
```
