# CSB: Compressed Sparse Blocks

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-latest-img]][docs-latest-url] | [![CI][github-action-img]][github-action-url] [![][codecov-img]][codecov-url] |


We provide a `Julia` interface, i.e., a wrapper to
`CompressedSparseBlocks (CSB)`, which is a high-performance library
for fast matrix-vector (`gAxpy`) and transpose matrix-vector
(`gAtxpy`) products with large, sparse matrices, on shared-memory
computers. This wrappers supports up to 32 right-hand side vectors. The
CSB data storage format was introduced by A. Buluç, J. Fineman,
M. Frigo, J. Gilbert, and C. Leiserson [1]. The library is written in
`C/C++` and is available 
[here](https://people.eecs.berkeley.edu/~aydin/csb/csb.html).  This
wrapper extends the use of `CSB` to the `Julia` user communities and
applications.

The CSB storage format offers similar performance in shared-memory
parallel systems for $\mathbf{A} \mathbf{x}$ and 
$\mathbf{A}^{\rm T} \mathbf{x}$. The block data format enables increased
performance by increasing locality on the memory accesses of the
left-hand side and the right-hand side vectors.  Threads are
dynamically scheduled to improve load balancing via the work-stealing
paradigm of the `Cilk` runtime environment. On large, sparse matrices,
the `CSB` format outperforms both the `Julia` built-in sparse
matrix-vector routines and the `MKLSparse` package.

<figure>
<img src="https://github.com/fcdimitr/CompressedSparseBlocks.jl/blob/main/benchmarks/benchmark-results.png" alt="Benchmarks" style="width:100%">
<figcaption align = "center"><i>Fig.1 - Comparison between CSB and MKLSparse. We report parallel (p = 40) execution times on 2x Intel Xeon E5-2640 v4 2.4GHz CPUs.</i></figcaption>
</figure>

## Installation

The package can be added using the Julia package manager. From the
Julia REPL, type ] to enter the Pkg REPL mode and run

``` julia
pkg> add CompressedSparseBlocks
```

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.*

## Contributing and Questions

Contributions are very welcome, as are feature requests and
suggestions. Please open an [issue][issues-url] if you encounter any
problems.

## References

[1] A. Buluç, J. T. Fineman, M. Frigo, J. R. Gilbert, and
C. E. Leiserson, “[Parallel sparse matrix-vector and
matrix-transpose-vector multiplication using compressed sparse
blocks](http://dx.doi.org/10.1145/1583991.1584053),” in Proceedings of
the 21st Annual Symposium on Parallelism in Algorithms and
Architectures, 2009, pp. 233–244.  doi: 10.1145/1583991.1584053.


## Contributors on the Julia wrapper

*Design and development*:  
Dimitris Floros<sup>1</sup>, Nikos Pitsianis<sup>1,2</sup>, Xiaobai Sun<sup>2</sup>

<sup>1</sup> Department of Electrical and Computer Engineering,
Aristotle University of Thessaloniki, Thessaloniki 54124, Greece  
<sup>2</sup> Department of Computer Science, Duke University, Durham, NC
27708, USA



[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://fcdimitr.github.io/CompressedSparseBlocks.jl/dev

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://fcdimitr.github.io/CompressedSparseBlocks.jl/stable

[github-action-img]: https://github.com/fcdimitr/CompressedSparseBlocks.jl/actions/workflows/CI.yml/badge.svg?branch=main
[github-action-url]: https://github.com/fcdimitr/CompressedSparseBlocks.jl/actions/workflows/CI.yml?query=branch%3Amain

[codecov-img]: https://codecov.io/gh/fcdimitr/CompressedSparseBlocks.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/fcdimitr/CompressedSparseBlocks.jl

[issues-url]: https://github.com/fcdimitr/CompressedSparseBlocks.jl/issues
