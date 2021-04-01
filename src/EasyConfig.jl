module EasyConfig

using OrderedCollections
using StructTypes
using JSON3

export Config

#-----------------------------------------------------------------------------# Config
"""
    Config(; kw...)
    Config(::AbstractDict)

A wrapper around an `OrderedDict{Symbol, Any}` with the special properties:

1. You can get/set items via `getproperty`/`setproperty!`:

    c = Config()
    c.one = 1
    c.one == 1

2. Properties that don't exist will be created on the fly:

    c = Config()
    c.one.two.three = "neat!"
"""
mutable struct Config <: AbstractDict{Symbol, Any}
    d::OrderedDict{Symbol, Any}
end
Config(;kw...) = Config(OrderedDict{Symbol, Any}(kw))

Config(x) = x
Config(x::AbstractDict) = Config(OrderedDict{Symbol,Any}(Symbol(k) => Config(v) for (k,v) in x))

dict(o::Config) = getfield(o, :d)

StructTypes.StructType(::Type{Config}) = StructTypes.DictType()

Base.getproperty(o::Config, k::Symbol) = get!(o, Symbol(k), Config())
Base.getproperty(o::Config, k) = getproperty(o, Symbol(k))

Base.setproperty!(o::Config, k::Symbol, v) = dict(o)[Symbol(k)] = v
Base.setproperty!(o::Config, k, v) = setproperty!(o, Symbol(k), v)

Base.propertynames(o::Config) = collect(keys(dict(o)))

Base.getindex(o::Config, k) = getproperty(o, Symbol(k))
Base.setindex!(o::Config, v, k) = setproperty!(o, Symbol(k), v)

Base.iterate(o::Config, args...) = iterate(dict(o), args...)
Base.keys(o::Config) = keys(dict(o))
Base.values(o::Config) = values(dict(o))
Base.length(o::Config) = length(dict(o))
Base.isempty(o::Config) = isempty(dict(o))
Base.pairs(o::Config) = pairs(dict(o))
Base.empty!(o::Config) = (empty!(dict(o)); o)
Base.get(o::Config, k, default) = get(dict(o), k, default)
Base.get!(o::Config, k, default) = get!(dict(o), k, default)

end # module
