module CompressedSparseBlocks

export SparseMatrixCSB

using Libdl, LinearAlgebra, SparseArrays, DocStringExtensions

# FIXME: When JLL is ready, uncomment the following line
# using CSB_jll
#
# and remove the following 2 lines
const PROJECT_ROOT = pkgdir(@__MODULE__)
libcsb = joinpath(PROJECT_ROOT, "../CSB/devel", "libcsb.$(Libdl.dlext)")

import LinearAlgebra:
  mul!

import Base:
  size, array_summary, print_array

import SparseArrays:
  nnz

const SLACKNESS = 8

include( "libcsb.jl" )


end
