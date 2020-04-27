using DataFrames
using VULParser
using Test

@testset "VULParser.jl" begin

    path = joinpath(@__DIR__,  "CM_TRIAL.VUL")
    df = VULParser.VUL(path)
    @test DataFrames._ncol(df) == 13
    @test DataFrames._nrow(df) == 42562

end
