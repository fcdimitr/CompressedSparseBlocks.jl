module CompressedSparseBlocks

export SparseMatrixCSB

using Libdl, LinearAlgebra, SparseArrays, DocStringExtensions, CSB_jll

import LinearAlgebra: mul!

import Base: size, array_summary, print_array

import SparseArrays: nnz

const SLACKNESS = 8

include("libcsb.jl")


end
