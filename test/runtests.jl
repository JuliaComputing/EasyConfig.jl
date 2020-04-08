using EasyConfig
using Test

@testset "EasyConfig.jl" begin
c = config()
c.level1.thing = "level1.thing"
c.level1.level2.a = 1
c.level1.level2.b = [1,2]
end
