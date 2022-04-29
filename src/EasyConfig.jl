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
struct Config <: AbstractDict{Symbol, Any}
    d::OrderedDict{Symbol, Any}
    function Config(x::Union{NamedTuple, AbstractDict})
        d = OrderedDict{Symbol,Any}()
        for (k,v) in pairs(x)
            d[Symbol(k)] = v isa Union{NamedTuple, AbstractDict} ? Config(v) : v
        end
        new(d)
    end
end
Config(; kw...) = Config(kw)
Config(x...) = Config(OrderedDict(x...))

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

Base.delete!(o::Config, k) = delete!(dict(o), Symbol(k))

Base.isequal(a::Config, b::Config) = dict(a) == dict(b)
Base.copy(o::Config) = Config(copy(dict(o)))

Base.merge(a, b) = merge!(copy(a), b)

function Base.merge!(a::Config, b::Config)
    for (k, v) in pairs(b)
        if hasproperty(a, k)
            if v isa Config
                merge!(a[k], v)
            else
                a[k] = v
            end
        else
            a[k] = v
        end
    end
    a
end

#-----------------------------------------------------------------------------# @config
"""
    @config (x=1, y=2, z=(a=1,b=2))

Use the NamedTuple syntax to construct a `Config`.
"""
macro config(ex)
    quote
        $(esc(EasyConfig._config(ex)))
    end
end

function _config(ex)
    if !hasproperty(ex, :head)
        ex
    elseif ex.head === :tuple
        Expr(:call, :Config, _config.(ex.args)...)
    elseif ex.head === :(=)
        Expr(:kw, ex.args[1], _config(ex.args[2]))
    else
        ex
    end
end


end # module
