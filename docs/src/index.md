```@meta
CurrentModule = CompressedSparseBlocks
```

# CompressedSparseBlocks

Documentation for [CompressedSparseBlocks](https://github.com/fcdimitr/CompressedSparseBlocks.jl).

## Why and when should I use `CompressedSparseBlocks`?

If you have a computation with an iteration where the time is dominated by a large sparse matrix multiplication, 

```julia
julia> using LinearAlgebra, SparseArrays, BenchmarkTools

julia> n = 2^22; d = 10; A = sprand(n,n,d/n); x = rand(n);

julia> y = @btime $A*$x;
  909.738 ms (2 allocations: 32.00 MiB)

julia> yt = @btime $(transpose(A))*$x;
  640.637 ms (2 allocations: 32.00 MiB)

```

you may want to consider the `CompressedSparseBlocks.jl` package.

```julia
julia> using CompressedSparseBlocks

```

Transforming a `SparseMatrixCSC` into a `SparseMatrixCSB` is straightforward, though it might take a few seconds for very large matrices.

```julia
julia> Ac = SparseMatrixCSB(A);

```
but the transformation cost can be eliminated with the speedup from CSB.

```julia
julia> yc = @btime $Ac*$x;
  352.766 ms (2 allocations: 32.00 MiB)

julia> yc ≈ y
true

julia> yct = @btime $(transpose(Ac))*$x;
  379.569 ms (3 allocations: 32.00 MiB)

julia> yct ≈ yt
true
```


## API

```@index
```

```@autodocs
Modules = [CompressedSparseBlocks]
```
