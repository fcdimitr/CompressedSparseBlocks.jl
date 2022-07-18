using CompressedSparseBlocks
using Test, Random, SparseArrays

# include various testing utilities
# include("testutil.jl")
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
  addtests("libcsb")
end