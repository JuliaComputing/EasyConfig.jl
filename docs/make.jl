using Documenter, EasyConfig

makedocs(;
    modules=[EasyConfig],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/joshday/EasyConfig.jl/blob/{commit}{path}#L{line}",
    sitename="EasyConfig.jl",
    authors="joshday <emailjoshday@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/joshday/EasyConfig.jl",
)
