using CompressedSparseBlocks, SparseArrays, LinearAlgebra
using Test, Random
using JuliaFormatter
using Aqua
using JET
using Documenter
using Pkg

function get_pkg_version(name::AbstractString)
    for dep in values(Pkg.dependencies())
        if dep.name == name
            return dep.version
        end
    end
    return error("Dependency not available")
end

enabled_tests = lowercase.(ARGS)
function addtests(fname)
    key = lowercase(splitext(fname)[1])
    if isempty(enabled_tests) || key in enabled_tests
        Random.seed!(0)
        @testset "$(titlecase(fname)) tests" begin
            include("$fname.jl")
        end
    end
end

@testset "CSB.jl" begin
    @testset "Code quality" begin
        if VERSION >= v"1.6"
            Aqua.test_all(
                CompressedSparseBlocks; ambiguities=false, deps_compat=(check_extras=false,)
            )
        end
    end
    @testset "Code formatting" begin
        @test JuliaFormatter.format(CompressedSparseBlocks; verbose=false, overwrite=false)
    end
    @testset "Code quality (JET.jl)" begin
        if VERSION >= v"1.9"
            @assert get_pkg_version("JET") >= v"0.8.4"
            JET.test_package(
                CompressedSparseBlocks;
                target_defined_modules=true,
                ignore_missing_comparison=true,
            )
        end
    end
    doctest(CompressedSparseBlocks)

    addtests("libcsb")
end
