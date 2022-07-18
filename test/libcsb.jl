m, n, d  = 10_134, 39_439, 10
A        = sprand( m, n, d/m )
Auint32  = SparseMatrixCSC{Float64,UInt32}( A );
x        = rand( n )
xt       = rand( m )

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

@testset "CSB too small matrices" begin

  min_size = CompressedSparseBlocks.SLACKNESS * CompressedSparseBlocks.getWorkers()

  for i = 0 : min_size
    @test_throws ErrorException("Matrix too small.") SparseMatrixCSB( sprand(i, i, 0.5) );
  end

  B = SparseMatrixCSB( sprand(min_size+1, min_size+1, 0.5) );

  @test size( B ) == (min_size+1, min_size+1)

end


@testset "matrix-vector multiplication" begin

  B = SparseMatrixCSB( A )
  @test A * x ≈ B * x

  B = SparseMatrixCSB( Auint32 )
  @test Auint32 * x ≈ B * x

end

@testset "matrix-matrix multiplication" begin

  B = SparseMatrixCSB( A )
  @testset "d = $d" for d = 1:32
    xx = rand( n, d )
    @test A * xx ≈ B * xx
  end

  B = SparseMatrixCSB( Auint32 )
  @testset "d = $d" for d = 1:32
    xx = rand( n, d )
    @test Auint32 * xx ≈ B * xx
  end

end


@testset "matrix-vector transpose multiplication" begin

  B = SparseMatrixCSB( A )
  @test A' * xt ≈ B' * xt

  B = SparseMatrixCSB( Auint32 )
  @test Auint32' * xt ≈ B' * xt

end

@testset "matrix-matrix transpose multiplication" begin

  B = SparseMatrixCSB( A )
  @testset "d = $d" for d = 1:32
    xx = rand( m, d )
    @test A' * xx ≈ B' * xx
  end

  B = SparseMatrixCSB( Auint32 )
  @testset "d = $d" for d = 1:32
    xx = rand( m, d )
    @test Auint32' * xx ≈ B' * xx
  end

end
