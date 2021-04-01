using EasyConfig
using Test

@testset "Constructors" begin
    @test Config() == Config()
    c = Config()
    c.x = 1
    @test Config(x=1) == Config(:x => 1) == Config(Dict(:x => 1)) == c
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

    @test length(Config()) == 0 
    @test length(c) == 1
end




# c = Config()
# c.level1.thing = "level1.thing"
# c.level1.level2.a = 1
# c["level1"][:level2].b = [1,2]

# @test c.level1.thing == "level1.thing"
# @test c.level1.level2.a == 1
# @test c.level1.level2.b == [1, 2]
# @test get(c, :not_there, 1) == 1
# @test get(c, "not_there", :hi) == :hi
# @test 
