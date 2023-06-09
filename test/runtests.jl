using EasyConfig
using StructTypes
using OrderedCollections: OrderedDict
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
    @test propertynames(c) == [:one, :test]
end

@testset "Other base methods" begin
    c = Config()

    @test get(c, "test", 1) == 1
    @test c."test" == Config()

    @test get!(c, "test2", 1) == 1
    @test c."test2" == 1
    delete!(c, "test")
    @test propertynames(c) == [:test2]

    @test keys(Config(x = 1)) == keys(OrderedDict(:x => 1))
    @test all(values(Config(x = 1)) .== values(OrderedDict(:x => 1)))
    @test pairs(Config(x = 1)) == pairs(OrderedDict(:x => 1))
    @test empty!(Config(x=1)) == Config()
end

@testset "from NamedTuple" begin
    nt = (x=1, y=(x=1, y=(x=1, y=(x=1,y=2))))
    c = Config(nt)
    @test c.y.y.y.y == 2
end

@testset "from Dict" begin
    d = Dict(:x => Dict(:x => Dict(:x => Dict(:x => 2))))
    c = Config(d)
    @test c.x.x.x.x == 2
end

@testset "merge!" begin
    a = Config(x = 1, y = Config(x = 1))
    b = Config(x = 5, y = Config(x=5, z="hi"))
    c = merge(a, b)
    merge!(a, b)
    @test a == c
    @test a.x == 5
    @test a.y.x == 5
    @test a.y.z == "hi"
end

@testset "isempty/delete_empty!" begin
    c = Config()
    c.x.x.x
    @test isempty(c) == true
end

@testset "StructTypes" begin
    @test isempty(StructTypes.keyvaluepairs(Config()))
    c = Config(x=1,y=2)
    @test StructTypes.keyvaluepairs(c)[:x] == 1
    @test StructTypes.keyvaluepairs(c)[:y] == 2
end

@testset "@config" begin
    val = 5
    c = @config (x.a=1, x.b=2, x.c.d.e.f.g = 3, z = val)
    @test c.x.a == 1
    @test c.x.b == 2
    @test c.x.c.d.e.f.g == 3
    @test c.z == val
end
