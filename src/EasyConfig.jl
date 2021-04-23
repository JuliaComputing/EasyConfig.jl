module EasyConfig

using OrderedCollections
using StructTypes
using JSON3

export Config, delete_empty!

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
Config(pairs::Pair...) = Config(OrderedDict(pairs...))
Config(d::AbstractDict) = _convert(d)
Config(x::NamedTuple) = Config(; x...)

_convert(x) = x 
_convert(x::AbstractDict) = Config(OrderedDict{Symbol,Any}(Symbol(k) => _convert(v) for (k,v) in x))


delete_empty!(x) = x
function delete_empty!(o::Config)
    foreach(delete_empty!, values(o))
    foreach(x -> isempty(x[2]) && delete!(o, x[1]), pairs(o))
    o
end

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
Base.get(o::Config, k, default) = get(dict(o), Symbol(k), default)
Base.get!(o::Config, k, default) = get!(dict(o), Symbol(k), default)

Base.delete!(o::Config, k) = delete!(dict(o), Symbol(k))

Base.isequal(a::Config, b::Config) = dict(a) == dict(b)
Base.copy(o::Config) = Config(copy(dict(o)))

end # module
