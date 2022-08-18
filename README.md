[![Build status](https://github.com/joshday/EasyConfig.jl/workflows/CI/badge.svg)](https://github.com/joshday/EasyConfig.jl/actions?query=workflow%3ACI+branch%3Amaster)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)
[![deps](https://juliahub.com/docs/EasyConfig/deps.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix?t=2)
[![version](https://juliahub.com/docs/EasyConfig/version.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix)
[![pkgeval](https://juliahub.com/docs/EasyConfig/pkgeval.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix)


<h1 align="center">EasyConfig</h1>

**EasyConfig** provides an easy-to-use nested `AbstractDict{Symbol, Any}` data structure.

<br><br>

The advantages over other `AbstractDict/NamedTuple`s are:

# 1) Intermediate levels are created on the fly:

```julia
c = Config()
c.one.two.three = 1
```

- This is *super* convenient for working with JSON specs (e.g. [PlotlyLight.jl](https://github.com/JuliaComputing/PlotlyLight.jl)).
- As you'd expect, you can `JSON3.write(c)` into a JSON string.

<br>

Compare this to `OrderedDict` and `NamedTuple`:

```julia
c = OrderedDict(:one => OrderedDict(:two => OrderedDict(:three => 1)))

c = (one = (two = (three = 1,),),)

c = (; one = (;two = (;three = 1)))
```

<br><br>

### 2) Any combination of `Symbol`/`AbstractString` with (`getproperty`/`getindex`) works.

- For working with `Config`s *interactively*, `getproperty` is the most convenient to work with.
- For working with `Config`s *programmatically*, `getindex` is the most convenient to work with.
- This gives you the best of both worlds.

```julia
# getproperty
c.one.two.three
c."one"."two"."three"

# getindex
c[:one][:two][:three]
c["one"]["two"]["three"]

# mix and match
c["one"].two."three"
```

- You can similarly use `setproperty!`/`setindex!` in the same way:

```julia
c["one"].two."three" = 5

c.one.two.three == 5  # true
```

<br><br>


## Note

- If you try to access something that doesn't exist, an empty `Config()` will sit there.
- This is a consequence of creating intermediate levels on the fly.
- Clean up stranded empty `Config`s with `delete_empty!(::Config)`.

```julia
c = Config()

c.one.two.three.four.five.six == Config()

# Internally we make the assumption that empty Config's shouldn't be there.
# Some functions will therefore call `delete_empty!` under the hood:
isempty(c) == true
```
