module EasyConfig

using OrderedCollections, StructTypes

export Config, indent!

function __init__()
    spaces[] = 4
end

spaces = Ref{Int}()
indent!(i::Int) = (spaces[] = i)

#-----------------------------------------------------------------------------# Config
mutable struct Config 
    d::OrderedDict{Symbol, Any}
end
Config(;kw...) = Config(OrderedDict{Symbol, Any}(kw))

dict(o::Config) = getfield(o, :d)

StructTypes.StructType(::Type{Config}) = StructTypes.DictType()

Base.getproperty(o::Config, k::Symbol) = get!(dict(o), k, Config())
Base.setproperty!(o::Config, k::Symbol, v) = dict(o)[k] = v
Base.propertynames(o::Config) = collect(values(dict(o)))

Base.iterate(o::Config, args...) = iterate(dict(o), args...)
Base.keys(o::Config) = keys(dict(o))
Base.values(o::Config) = values(dict(o))
Base.length(o::Config) = length(dict(o))
Base.isempty(o::Config) = isempty(dict(o))
Base.pairs(o::Config) = pairs(dict(o))
Base.empty!(o::Config) = empty!(dict(o))

OrderedDict(x::Config) = OrderedDict(k => v isa Config ? OrderedDict(v) : v for (k,v) in pairs(x))

#-----------------------------------------------------------------------------# show
function Base.show(io::IO, o::Config; indent=0) 
    colors = [:light_cyan, :light_green, :light_yellow, :light_red, :light_blue, :light_magenta]
    labelcolor = colors[(indent % length(colors)) + 1]
    for (i, (k,v)) in enumerate(pairs(o))
        print(io, (' ' ^ spaces[]) ^ indent)
        if v isa Config
            if length(v) > 0 
                printstyled(io, "$k: ", color=labelcolor)
                println(io)
                show(io, v, indent=indent + 1)
            else 
                printstyled(io, string(k), color=:light_black)
                println(io)
            end
        else
            label = "$k: "
            context = IOContext(io, 
                :compact => true, 
                :displaysize => (1, displaysize(io)[2] - length(label)), 
                :limit => true
            )
            printstyled(io, label, color=labelcolor)
            print(context, v)
            println(io)
        end
    end
end

function Base.show(io::IO, ::MIME"text/html", o::Config)
    print(io, "<code><ul>")
    for (k,v) in pairs(dict(o))
        print(io, "<li><strong>$k</strong>: ")
        if showable(MIME"text/html"(), v)
            show(IOContext(io, :compact=>true, :limit=>true), MIME"text/html"(), v)
        else
            print(io, v)
        end
        print(io, "</li>")
    end
    print(io, "</ul></code>")
end

#-----------------------------------------------------------------------------# json 
function json(o::Config, indent=0; pretty=true)
    io = IOBuffer()
    println(io, '{')
    for (i, (k,v)) in enumerate(dict(o))
        print(io, "  " ^ indent)
        println(io, "\"$k\": $(json(o, indent + 1; pretty))")
    end
    println(io, '}')
    String(take!(io))
end

json(x, indent; pretty=true) = _json(x)

_json(x) = x
_json(x::AbstractArray) = collect(x)
_json(x::Union{AbstractString, Char, Symbol}) = "\"$x\""
_json(::Nothing) = "null"
_json(::Missing) = "null"

end # module
