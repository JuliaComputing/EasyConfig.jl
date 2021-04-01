# EasyConfig

[![Build Status](https://travis-ci.com/joshday/EasyConfig.jl.svg?branch=master)](https://travis-ci.com/joshday/EasyConfig.jl)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)


**EasyConfig** provides a simple nested `AbstractDict{Symbol, Any}` data structure. 


## Advantages over other dictionaries/named tuples:

### 1) Intermediate levels are created on the fly:

```julia
c = Config().one.two.three = 1
```

vs.

```julia
c = OrderedDict(:one => OrderedDict(:two => OrderedDict(:three => 1)))

c = (one = (two = (three = 1,),),)

c = (; one = (;two = (;three = 1)))
```

### 2) Values can be accessed via `getproperty`/`getindex` with either `AbstractString` or `Symbol`s:

```julia
c.one.two.three == 1
c."one"."two"."three" == 1
c[:one][:two]["three"] == 1
```

vs.

```julia
c[:one][:two][:three] == 1
```

### 3) Getting and setting can be done with `get/set` `property/index`:

(for the purpose of making `Symbol`s easier to work with)

```julia
c.why."would you"["need to do this?"] = "No reason"

c."why"[var"would you"]."need to do this?" == "No reason"
```

## Conversion to JSON

Simply `JSON3.write` it! 🎉

## Gotchas

If you try to access something that doesn't exist, an empty `Config()` will sit there (a consequence of allowing intermediate levels to be created on the fly):

```julia
c = Config()

c.one.two.three.four.five.six == Config()
```

Clean up any stranded empty `Config`s with `delete_empty!(::Config)`.

## Example (Try this in [Pluto](https://github.com/fonsp/Pluto.jl)!)

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