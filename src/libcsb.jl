@doc """
    $(TYPEDEF)

Matrix type for storing sparse matrices in the Compressed Sparse
Blocks format. The standard way of constructing `SparseMatrixCSB` is
to pass a `SparseMatrixCSC` object, see the constructors.

"""
mutable struct SparseMatrixCSB{Tv,Ti} <: SparseArrays.AbstractSparseMatrix{Tv,Ti}
  m::Ti
  n::Ti
  nz::Ti
  ptr::Ptr{Cvoid}
  function SparseMatrixCSB{Tv,Ti}(m::Ti,n::Ti,nz::Ti,ptr::Ptr{Cvoid}) where {Tv, Ti}
    A = new(m,n,nz,ptr)
    function f(X)
      @async deallocateCSB!( X )
    end
    finalizer(f, A)
  end
end

@doc """

$(TYPEDSIGNATURES)

Convert a `SparseMatrixCSC` matrix `A` into a `SparseMatrixCSB` matrix.

# Optional arguments

- `beta`: The size of each block in base-2 logarithm; if 0 the package
  decides the block size internally.

"""
SparseMatrixCSB(A::SparseMatrixCSC{Tv,Ti}, beta::Integer = 0) where {Tv,Ti<:Integer} = prepareCSB( A, beta )


@doc """
$(TYPEDSIGNATURES)

Query the number of `Cilk` workers.
"""
getWorkers() = @ccall libcsb.getWorkers()::Cint

@doc """
$(TYPEDSIGNATURES)

Set the number of `Cilk` workers to `np`.
"""
setWorkers(np::Int64) = @ccall libcsb.setWorkers(np::Int64)::Cvoid

function prepareCSB(A::SparseMatrixCSC{Tv,Ti}, beta = 0) where {Tv, Ti <: Integer}
  mktemp() do path, io
    redirect_stdout(io) do
      SparseMatrixCSB{Tv,Ti}(
        Ti(size(A,1)), Ti(size(A,2)), Ti(nnz(A)),
        _prepareCSB( A.nzval,
                     A.rowval .- one(Ti),
                     A.colptr .- one(Ti),
                     Ti(nnz(A)), Ti(size(A,1)),
                     Ti(size(A,2)), getWorkers(), beta )
      )
    end
  end
end

for (Tv, Tvname) in ((Cdouble, "double"), )
  for (Ti, Tiname) in ((Cuint, "uint32"), (Cintmax_t, "int64"))
    @eval @inline function _prepareCSB(
      val::Vector{$Tv}, row::Vector{$Ti}, colptr::Vector{$Ti},
      nzmax::$Ti, m::$Ti, n::$Ti, workers::Integer,
      forcelogbeta::Integer)
        ccall( ($("prepareCSB_" * Tvname * "_" * Tiname), libcsb), Ptr{Cvoid},
               (Ptr{$Tv}, Ptr{$Ti}, Ptr{$Ti}, $Ti, $Ti, $Ti, Cint, Cint),
               val, row, colptr, nzmax, m, n, workers, forcelogbeta)

    end

    @eval @inline function _gespmvCSB!(
      y::Vector{$Tv}, A::SparseMatrixCSB{$Tv,$Ti}, x::Vector{$Tv})
      ccall( ($("gespmv_" * Tvname * "_" * Tiname), libcsb), Ptr{Cvoid},
             (Ptr{Cvoid}, Ptr{$Tv}, Ptr{$Tv}),
             A.ptr, x, y)

    end

    @eval @inline function _deallocate!(
      A::SparseMatrixCSB{$Tv,$Ti})
      ccall( ($("deallocate_" * Tvname * "_" * Tiname), libcsb), Ptr{Cvoid},
             (Ptr{Cvoid}, ), A.ptr)

    end

  end
end

function deallocateCSB!(A::SparseMatrixCSB)
  A.ptr == C_NULL && error( "Invalid CSB object" )
  _deallocate!(A)
  A.ptr = C_NULL
  A.m = A.n = A.nz = 0
  nothing
end



# overrides

function mul!(y::AbstractVecOrMat, A::SparseMatrixCSB, x::AbstractVector)

  fill!( y, 0 )
  _gespmvCSB!( y, A, x )
  y

end

size( A::SparseMatrixCSB ) = (A.m, A.n)
nnz( A::SparseMatrixCSB )  = A.nz

function array_summary(io::IO, S::SparseMatrixCSB, dims::Tuple{Vararg{Base.OneTo}})
    xnnz = nnz(S)
    m, n = size(S)
    print(io, m, "×", n, " ", typeof(S), " with ", xnnz, " stored ",
              xnnz == 1 ? "entry" : "entries")
    nothing
end

function print_array(io::IO, A::SparseMatrixCSB{Tv,Ti}) where {Tv, Ti}

end
