# EasyConfig

[![Build status](https://github.com/joshday/EasyConfig.jl/workflows/CI/badge.svg)](https://github.com/joshday/EasyConfig.jl/actions?query=workflow%3ACI+branch%3Amaster)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)


**EasyConfig** provides a simple nested `AbstractDict{Symbol, Any}` data structure.

The main advantages over other `AbstractDict/NamedTuple`s are:

### Intermediate levels are created on the fly.

```julia
c = Config().one.two.three = 1
```

Compare this to `OrderedDict` and `NamedTuple`:

```julia
c = OrderedDict(:one => OrderedDict(:two => OrderedDict(:three => 1)))

c = (one = (two = (three = 1,),),)

c = (; one = (;two = (;three = 1)))
```

### Getting/setting is achieved via `getindex`/`getproperty` and `setindex`/`setproperty`

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

## Example (Try this in [Pluto](https://github.com/fonsp/Pluto.jl) 🎈!)

```julia
begin
	using Random, EasyConfig, JSON3

	function plot(config)
	    id = randstring(20)
	    HTML("""
	        <div id="$id""></div>
	        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
	        <script>
	            var data = $(JSON3.write(config.data))
	            var layout = $(JSON3.write(config.layout))
	            Plotly.newPlot("$id", data, layout, {responsive:true, displaylogo: false, displayModeBar: false})
	        </script>
	    """)
	end

	myplot = Config()

	myplot.data = [Config(
		x=randn(100), y = randn(100), mode="markers"
	)]
	myplot.layout.title = "My Plot"
	myplot.layout.xaxis.title = "X Axis"
	myplot.layout.yaxis.title = "Y Axis"

	plot(myplot)
end
```

![](https://user-images.githubusercontent.com/8075494/99103003-e6b29d00-25ac-11eb-9097-0b5fd5b42b6d.png)


## Gotchas

If you try to access something that doesn't exist, an empty `Config()` will sit there (a consequence of creating intermediate levels on the fly):

```julia
c = Config()

c.one.two.three.four.five.six == Config()
```

🧹 Clean up any stranded empty `Config`s with `delete_empty!(::Config)`.
