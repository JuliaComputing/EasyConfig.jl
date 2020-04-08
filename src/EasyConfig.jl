module EasyConfig

using OrderedCollections
using AbstractTrees

export config
config(args...) = Object(args...)

struct Object 
    name::Symbol
    dict::OrderedDict{Symbol, Any}
end
Object(kv::Pair...) = Object(:origin, kv...)
Object(name::Symbol, kv::Pair...) = Object(name, OrderedDict{Symbol, Any}(kv...))
_d(o::Object) = getfield(o, :dict)

Base.getproperty(o::Object, k::Symbol) = get!(_d(o), k, Object(k))
Base.setproperty!(o::Object, k::Symbol, v) = _d(o)[k] = v
Base.propertynames(o::Object) = collect(values(_d(o)))

#-----------------------------------------------------------------------------# json 
function json(o::Object)
    d = _d(o)
    if isempty(d)
        return "null"
    else
        s = "{"
        for (i, (k,v)) in enumerate(d)
            s *= "\"$k\":$(json(v))"
            i != length(d) && (s *= ',')
        end
        s *= "}"
    end
end

json(x) = x
json(x::Union{AbstractString, Char}) = "\"$x\""
json(::Nothing) = "null"



#-----------------------------------------------------------------------------# show
Base.show(io::IO, o::Object) = AbstractTrees.print_tree(io, o, 100)
function AbstractTrees.children(o::Object)
    d = _d(o)
    if isempty(d)
        () 
    else 
        out = []
        for (k, v) in d
            v isa Object ? push!(out, v) : push!(out, NameAndValue(k, v))
        end
        out
    end
end
function AbstractTrees.printnode(io::IO, o::Object) 
    nm = getfield(o, :name)
    if isempty(_d(o))
        printstyled(io, "$nm (Nothing)", color=:light_black)
    else
        print(io, nm)
    end
end

struct NameAndValue 
    name 
    value 
end
function AbstractTrees.printnode(io::IO, o::NameAndValue) 
    print(io, "$(o.name): ")
    print(IOContext(io, :compact => true), o.value)
end
AbstractTrees.children(o::NameAndValue) = ()



end # module
