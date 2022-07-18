# CompressedSparseBlocks

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://fcdimitr.github.io/CompressedSparseBlocks.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://fcdimitr.github.io/CompressedSparseBlocks.jl/dev)
[![Build Status](https://github.com/fcdimitr/CompressedSparseBlocks.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/fcdimitr/CompressedSparseBlocks.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/fcdimitr/CompressedSparseBlocks.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/fcdimitr/CompressedSparseBlocks.jl)

We provide a `Julia` interface, i.e., a wrapper to
`CompressedSparseBlocks (CSB)`, which is a high-performance software
for fast matrix-vector (`gAxpy`) and transpose matrix-vector
(`gAtxpy`) products with large, sparse matrices, on shared-memory
computers. It also accommodates up to 32 right-hand side vectors. The
CSB data storage format was introduced by A. Buluç, J. Fineman,
M. Frigo, J. Gilbert, and C. Leiserson [1]. The software written in
`C/C++` is available at
https://people.eecs.berkeley.edu/~aydin/csb/html/index.html .  This
wrapper extends the use of `CSB` to the `Julia` user communities and
applications.

The CSB storage format offers similar performance in shared-memory
parallel systems for $A\, x$ and $A\, x^{\rm T}$. The block data
format enables increased performance by increasing locality on the
memory accesses of the left-hand side and the right-hand side vectors.
Threads are dynamically scheduled to improve load balancing via the
work-stealing paradigm of the `Cilk` runtime environment. On large,
sparse matrices, the `CSB` format outperforms both the `Julia`
built-in sparse matrix-vector routines and the `MKLSparse` package.

![benchmark-results.png](...)

## References

[1] A. Buluç, J. T. Fineman, M. Frigo, J. R. Gilbert, and
C. E. Leiserson, “Parallel sparse matrix-vector and
matrix-transpose-vector multiplication using compressed sparse
blocks,” in Proceedings of the 21st Annual Symposium on Parallelism in
Algorithms and Architectures, 2009, pp. 233–244. 
doi: 10.1145/1583991.1584053.


For information see the article [Parallel sparse matrix-vector and
matrix-transpose-vector multiplication using compressed sparse
blocks](http://dx.doi.org/10.1145/1583991.1584053).
