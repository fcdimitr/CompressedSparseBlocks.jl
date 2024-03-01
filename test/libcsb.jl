m, n, d = 10_134, 39_439, 10
A = sprand(m, n, d / m)
Auint32 = SparseMatrixCSC{Float64,UInt32}(A);
x = rand(n)
xt = rand(m)

import CompressedSparseBlocks: getWorkers, setWorkers

@testset "Cilk RTS" begin

    np = getWorkers()
    setWorkers(3)
    @test getWorkers() == 3
    setWorkers(np)
    @test getWorkers() == np

end

@testset "CSB construction/deconstruction" begin

    B = SparseMatrixCSB(A)
    @test nnz(B) == nnz(A)
    @test size(B) == size(A)

    @test repr(Base.print_array(Base.stdout, B)) == "nothing"
    @test repr(Base.print_matrix(Base.stdout, B)) == "nothing"
    @test repr(summary(B)) ==
        "\"$(m)×$(n) SparseMatrixCSB{Float64, Int64} with $(nnz(A)) stored entries\""
    @test repr(summary(B')) ==
        "\"$(n)×$(m) Adjoint{Float64, SparseMatrixCSB{Float64, Int64}} with $(nnz(A)) stored entries\""

    finalize(B)
    sleep(0.1)
    @test B.ptr == C_NULL

    B = SparseMatrixCSB(Auint32)
    @test nnz(B) == nnz(A)
    @test nnz(B') == nnz(A)
    @test nnz(transpose(B)) == nnz(A)
    @test size(B) == size(A)
    finalize(B)
    sleep(0.1)
    @test B.ptr == C_NULL

end

@testset "CSB too small matrices" begin

    min_size = Int(
        2^floor(
            log2(CompressedSparseBlocks.SLACKNESS * CompressedSparseBlocks.getWorkers())
        ),
    )

    for i in 0:min_size
        @test_throws ErrorException("Matrix too small.") SparseMatrixCSB(sprand(i, i, 0.5))
    end

    B = SparseMatrixCSB(sprand(min_size + 1, min_size + 1, 0.5))

    @test size(B) == (min_size + 1, min_size + 1)

end


@testset "matrix-vector multiplication" begin

    B = SparseMatrixCSB(A)
    @test A * x ≈ B * x

    B = SparseMatrixCSB(Auint32)
    @test Auint32 * x ≈ B * x

end

@testset "matrix-matrix multiplication" begin

    B = SparseMatrixCSB(A)
    @testset "d = $d" for d in 1:32
        xx = rand(n, d)
        @test A * xx ≈ B * xx
    end

    @testset "d = 33" begin
        xx = rand(n, 33)
        @test_throws DimensionMismatch B * xx
    end

    B = SparseMatrixCSB(Auint32)
    @testset "d = $d" for d in 1:32
        xx = rand(n, d)
        @test Auint32 * xx ≈ B * xx
    end

    @testset "d = 33" begin
        xx = rand(n, 33)
        @test_throws DimensionMismatch B * xx
    end

end


@testset "matrix-vector transpose multiplication" begin

    B = SparseMatrixCSB(A)
    @test A' * xt ≈ B' * xt
    @test transpose(A) * xt ≈ transpose(B) * xt

    B = SparseMatrixCSB(Auint32)
    @test Auint32' * xt ≈ B' * xt
    @test transpose(Auint32) * xt ≈ transpose(B) * xt

end

@testset "matrix-matrix transpose multiplication" begin

    B = SparseMatrixCSB(A)
    @testset "d = $d" for d in 1:32
        xx = rand(m, d)
        @test A' * xx ≈ B' * xx
        @test transpose(A) * xx ≈ transpose(B) * xx
    end

    @testset "d = 33" begin
        xx = rand(m, 33)
        @test_throws DimensionMismatch B' * xx
        @test_throws DimensionMismatch transpose(B) * xx
    end

    B = SparseMatrixCSB(Auint32)
    @testset "d = $d" for d in 1:32
        xx = rand(m, d)
        @test Auint32' * xx ≈ B' * xx
        @test transpose(Auint32) * xx ≈ transpose(B) * xx
    end

    @testset "d = 33" begin
        xx = rand(m, 33)
        @test_throws DimensionMismatch B' * xx
        @test_throws DimensionMismatch transpose(B) * xx
    end

end
