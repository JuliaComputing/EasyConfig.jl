module EasyConfig

using OrderedCollections
using StructTypes
using JSON3

export Config, delete_empty!, @config

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
struct Config <: AbstractDict{Symbol, Any}
    d::OrderedDict{Symbol, Any}
    function Config(x::Union{NamedTuple, AbstractDict})
        d = OrderedDict{Symbol,Any}()
        for (k,v) in pairs(x)
            d[Symbol(k)] = _config_value(v)
        end
        new(d)
    end
    Config(x::Config) = x
end
Config(; kw...) = Config(kw)
Config(x...) = Config(OrderedDict(x...))

_config_value(x) = x
_config_value(x::AbstractDict) = Config(x)
_config_value(x::Pair) = Config(Symbol(x[1]) => x[2])
_config_value(x::AbstractArray) = map(_config_value, x)

OrderedCollections.isordered(::Type{Config}) = true

delete_empty!(x) = x
function delete_empty!(o::Config)
    for (k,v) in pairs(o)
        v isa Config && isempty(v) ? delete!(o, k) : delete_empty!(v)
    end
    o
end

dict(o::Config) = getfield(o, :d)

StructTypes.StructType(::Type{Config}) = StructTypes.DictType()

Base.getproperty(o::Config, k::Symbol) = get!(o, k, Config())
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
Base.isempty(o::Config) = isempty(dict(delete_empty!(o)))
Base.pairs(o::Config) = pairs(dict(o))
Base.empty!(o::Config) = (empty!(dict(o)); o)
Base.get(o::Config, k, default) = get(dict(o), Symbol(k), default)
Base.get!(o::Config, k, default) = get!(dict(o), Symbol(k), default)
Base.haskey(o::Config, k) = haskey(dict(o), Symbol(k))

Base.delete!(o::Config, k) = (delete!(dict(o), Symbol(k)); o)

Base.isequal(a::Config, b::Config) = dict(a) == dict(b)
Base.copy(o::Config) = Config(copy(dict(o)))

Base.merge(a::Config, b::Config) = merge!(copy(a), b)

function Base.merge!(a::Config, b::Config)
    for (k, v) in pairs(b)
        hasproperty(a, k) && v isa Config ? merge!(a[k], v) : setindex!(a, v, k)
    end
    a
end

#-----------------------------------------------------------------------------# @config
"""
    @config expr

Create a `Config` with a NamedTuple-like or block syntax.  The following examples create equivalent `Config`s:

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
"""
macro config(ex...)
    exprs = collect(ex)
    if length(exprs) == 1
        ex = only(exprs)
        if ex.head == :block
            ex = Expr(:tuple, filter(x -> !(x isa LineNumberNode), ex.args)...)
        end
    else
        ex = Expr(:tuple, exprs...)
    end
    ex.head == :tuple || error("@config input must be a tuple")
    all(x -> x.head == :(=), ex.args) || error("Unexpected syntax in @config")
    x = gensym()
    out = Expr(:block, :(local $x = Config()))
    for val in ex.args
        lhs, rhs = val.args
        push!(out.args, :($(_prepend(x, lhs)) = $rhs))
    end
    push!(out.args, x)
    esc(out)
end

_prepend(val, e::Symbol) = :($val.$e)
_prepend(val, e) = e.head == :. && (e.args[1] = _prepend(val, e.args[1]); e)
end # module
