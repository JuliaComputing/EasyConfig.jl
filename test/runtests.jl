using EasyConfig
using Test

@testset "Constructors" begin
    @test Config() == Config()
    c = Config()
    c.x = 1
    @test Config(x=1) == Config(:x => 1) == Config(Dict(:x => 1)) == Config((; x=1)) == c
end

@testset "Set/get property/field" begin 
    c = Config()
    c.one."two"["three"][:four] = 5
    @test c.one.two.three.four == 5
    c."test" == Config()
end

@testset "Other base methods" begin 
    c = Config()

    @test get(c, "test", 1) == 1
    @test c."test" == Config()

    @test get!(c, "test2", 1) == 1
    @test c."test2" == 1
end

@testset "from NamedTuple" begin 
    nt = (x=1, y=(x=1, y=(x=1, y=(x=1,y=2))))
    c = Config(nt)
    c.y.y.y.y == 2
end

@testset "from Dict" begin 
    d = Dict(:x => Dict(:x => Dict(:x => Dict(:x => 2))))
    c = Config(d)
    c.x.x.x.x == 2
end