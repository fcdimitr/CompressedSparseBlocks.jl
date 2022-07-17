m, n, d  = 10_134, 39_439, 10
A        = sprand( m, n, d/m )
Auint32  = SparseMatrixCSC{Float64,UInt32}( A );
x        = rand( n )

@testset "CSB construction/deconstruction" begin

  B = SparseMatrixCSB( A )
  @test nnz(B) == nnz(A)
  @test size(B) == size(A)
  finalize( B )
  sleep(0.1)
  @test B.ptr == C_NULL

  B = SparseMatrixCSB( Auint32 )
  @test nnz(B) == nnz(A)
  @test size(B) == size(A)
  finalize( B )
  sleep(0.1)
  @test B.ptr == C_NULL

end

@testset "matrix-vector multiplication" begin

  B = SparseMatrixCSB( A )
  @test A * x ≈ B * x

  B = SparseMatrixCSB( Auint32 )
  @test Auint32 * x ≈ B * x

end
