# Julia Interface to Matrix-Vector Multiplications in CSB Format

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-latest-img]][docs-latest-url] | [![CI][github-action-img]][github-action-url] [![][codecov-img]][codecov-url] |


We provide a `Julia` interface (a wrapper) to the `Compressed Sparse
Blocks (CSB)` library. The library is written in `C/C++`, available at
<https://people.eecs.berkeley.edu/~aydin/csb/html/index.html>. The
library supports fast computation of large sparse matrix-vector
products, $Ax$ and $A^{\rm T}x$ operations specifically, with sparse
matrix $A$ in the format of compressed sparse blocks (CSB), on
shared-memory computer systems. The CSB format was introduced by A.
Buluç, J. Fineman, M. Frigo, J. Gilbert, and C. Leiserson [1].

The CSB format and library have the following advantages: (1) The
matrix-vector operations in CSB format often outpace the conventional
general-purposes sparse formats, namely, CSC and CSR \[2\]. (2) The
multiplication with the transposed matrix $A^{\rm T}$ does not suffer from
longer latency than that with $A$. The symmetric performance eliminates
the need for an additional copy in a different layout for $A^{\rm T}$
(as with CSR or CSC) for reducing the speed gap at the cost of double
memory consumption. (3) The library is integrated with `Cilk` \[3\]. The
latter offers optimal run-time scheduling (in theory and in practice) on
parallel computers with shared memory.

This Julia interface is intended to extend and ease the use of `CSB` to
broader applications. This interface supports up to $32$ multiple
vectors to be applied with the same matrix $A$.

<figure>
<img src="https://github.com/fcdimitr/CompressedSparseBlocks.jl/blob/main/benchmarks/benchmark-results.png" alt="Benchmarks" style="width:100%">
<figcaption align = "center"><i>Fig.1 - Comparison in wall-clock execution time between CSB and MKLSparse. The parallel execution times are with 40 threads on 2 processors Intel Xeon E5-2640 v4 2.4GHz. The average degree is the average number of nonzeros per row/column.</i></figcaption>
</figure>

## Installation

The package can be added using the Julia package manager. From the
Julia REPL, type ] to enter the Pkg REPL mode and execute the
following command

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

[2] S. C. Eisenstat, M. C. Gursky, M. H. Schultz, A. H. Sherman,
“[Yale Sparse Matrix
Package](https://apps.dtic.mil/dtic/tr/fulltext/u2/a047724.pdf),”
Technical Report, 1977.

[3] M. Frigo, C. E. Leiserson, and K. H. Randall, “[The implementation
of the Cilk-5 multithreaded
language](https://doi.org/10.1145/277652.277725),” ACM SIGPLAN
Notices, vol. 33, no. 5, pp. 212–223, 1998, doi:
10.1145/277652.277725.



## Contributors of the Julia interface

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
