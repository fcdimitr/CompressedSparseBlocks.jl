module CompressedSparseBlocks

export SparseMatrixCSB

using Libdl, LinearAlgebra, SparseArrays, DocStringExtensions, csb_jll

import LinearAlgebra:
  mul!

import Base:
  size, array_summary, print_array

import SparseArrays:
  nnz

include( "libcsb.jl" )


end
