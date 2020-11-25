module EasyConfig

using OrderedCollections, StructTypes, JSON3

export Config

#-----------------------------------------------------------------------------# Config
mutable struct Config <: AbstractDict{Symbol, Any}
    d::OrderedDict{Symbol, Any}
end
Config(;kw...) = Config(OrderedDict{Symbol, Any}(kw))

dict(o::Config) = getfield(o, :d)

StructTypes.StructType(::Type{Config}) = StructTypes.DictType()

Base.getproperty(o::Config, k::Symbol) = get!(dict(o), k, Config())
Base.setproperty!(o::Config, k::Symbol, v) = dict(o)[k] = v
Base.propertynames(o::Config) = collect(keys(dict(o)))

Base.iterate(o::Config, args...) = iterate(dict(o), args...)
Base.keys(o::Config) = keys(dict(o))
Base.values(o::Config) = values(dict(o))
Base.length(o::Config) = length(dict(o))
Base.isempty(o::Config) = isempty(dict(o))
Base.pairs(o::Config) = pairs(dict(o))
Base.empty!(o::Config) = (empty!(dict(o)); o)

Base.show(io::IO, o::Config) = show(io, MIME"text/plain"(), o)
Base.show(io::IO, ::MIME"text/plain", o::Config) = JSON3.pretty(io, JSON3.write(o))

end # module
