[![Build status](https://github.com/joshday/EasyConfig.jl/workflows/CI/badge.svg)](https://github.com/joshday/EasyConfig.jl/actions?query=workflow%3ACI+branch%3Amaster)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)
[![deps](https://juliahub.com/docs/EasyConfig/deps.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix?t=2)
[![version](https://juliahub.com/docs/EasyConfig/version.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix)
[![pkgeval](https://juliahub.com/docs/EasyConfig/pkgeval.svg)](https://juliahub.com/ui/Packages/EasyConfig/tMFix)


<h1 align="center">EasyConfig</h1>

**EasyConfig** provides an easy-to-use nested `AbstractDict{Symbol, Any}` data structure.  The main advantages over other `AbstractDict/NamedTuple`s are:

<br><br>

### 1) Intermediate levels are created on the fly.

```julia
c = Config()
c.one.two.three = 1
```

Compare this to `OrderedDict` and `NamedTuple`:

```julia
c = OrderedDict(:one => OrderedDict(:two => OrderedDict(:three => 1)))

c = (one = (two = (three = 1,),),)

c = (; one = (;two = (;three = 1)))
```

<br><br>

### 2) Getting/setting is achieved via `getindex`/`getproperty` and `setindex`/`setproperty`

```julia
c.why."would you"["need to do this?"] = "Personal preferences"

c."why"[var"would you"]."need to do this?" == "Personal preferences"
```

Compare this to `OrderedDict` and `NamedTuple`:

```julia
OrderedDict(:why => OrderedDict(Symbol("would you") => OrderedDict(Symbol("need to do this?") => "Personal preferences")))

(why = (var"would you" = (var"need to do this?" = "Personal preferences"),),)

(; why = (; var"would you" = (; var"need to do this?" = "Personal preferences")))
```


<br><br>

## Gotchas

If you try to access something that doesn't exist, an empty `Config()` will sit there (a consequence of creating intermediate levels on the fly):

```julia
c = Config()

c.one.two.three.four.five.six == Config()
```

🧹 Clean up any stranded empty `Config`s with `delete_empty!(::Config)`.
