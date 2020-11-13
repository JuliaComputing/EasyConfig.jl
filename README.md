# EasyConfig

[![Build Status](https://travis-ci.com/joshday/EasyConfig.jl.svg?branch=master)](https://travis-ci.com/joshday/EasyConfig.jl)
[![Codecov](https://codecov.io/gh/joshday/EasyConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/joshday/EasyConfig.jl)


**EasyConfig** provides an easy-to-use nested `AbstractDict{Symbol, Any}` data structure. 


## Advantages over other dictionaries/named tuples:

The advantages are twofold.

### 1) Intermediate levels are created on the fly:

```julia
c = Config().one.two.three = 1
```

vs.

```julia
c = OrderedDict(:one => OrderedDict(:two => OrderedDict(:three => 1)))

c = (one = (two = (three = 1,),),)
```

### 2) Values can be accessed via `getproperty`:

```julia
c.one.two.three == 1  # Same as NamedTuple
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

## Example (Try this in Pluto!)

```julia
begin
	using Random, EasyConfig, JSON3
	
	function plotly_plot(config)
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
	
	plotly_plot(myplot)
end
```

### Screenshot

![](https://user-images.githubusercontent.com/8075494/99103003-e6b29d00-25ac-11eb-9097-0b5fd5b42b6d.png)