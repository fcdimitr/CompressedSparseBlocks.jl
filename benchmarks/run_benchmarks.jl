using LinearAlgebra, SparseArrays, CompressedSparseBlocks
using BenchmarkTools
using MKLSparse  # to enable multithreaded Sparse CSC MV
using CairoMakie # to enable plotting



function benchmark_csr_mv(sizes, densities, dims)

    times_csc = zeros(length(sizes), length(densities), length(dims))
    times_csct = zeros(length(sizes), length(densities), length(dims))
    times_csb = zeros(length(sizes), length(densities), length(dims))
    times_csbt = zeros(length(sizes), length(densities), length(dims))

    for (i, n) in enumerate(sizes)
        for (j, d) in enumerate(densities)
            for (k, r) in enumerate(dims)

                @info "Running ($n, $n) with average degree $d and $r RHS vectors"

                A = sprand(n, n, d / n)
                B = SparseMatrixCSB(A)

                if r == 1
                    x = rand(n)
                    y1 = zeros(n)
                    y2 = zeros(n)
                    y3 = zeros(n)
                    y4 = zeros(n)
                else
                    x = rand(n, r)
                    y1 = zeros(n, r)
                    y2 = zeros(n, r)
                    y3 = zeros(n, r)
                    y4 = zeros(n, r)
                end
                times_csc[i, j, k] = @belapsed mul!($y1, $A, $x)
                times_csct[i, j, k] = @belapsed mul!($y2, $(A'), $x)
                times_csb[i, j, k] = @belapsed mul!($y3, $B, $x)
                times_csbt[i, j, k] = @belapsed mul!($y4, $(B'), $x)

                @assert y1 ≈ y3
                @assert y2 ≈ y4

            end
        end
    end

    return times_csc, times_csct, times_csb, times_csbt

end


function make_figure(sizes, densities, dims, times_csc, times_csct, times_csb, times_csbt)

    f = Figure(; resolution=(1600, 1200))

    m = length(sizes)
    n = length(densities)
    l = length(dims)

    axs = [
        Axis(
            f[i, j];
            xscale=log2, # yscale = log10,
            xlabel=i == l ? "matrix size" : "",
            ylabel=j == 1 ? "relative speedup over CSC" : "",
            title="avg. degree = $(densities[j]) | $(dims[i]) vectors",
        ) for i in 1:l, j in 1:n
    ]

    for i in 1:l
        for j in 1:n
            # scatterlines!( axs[i,j], sizes, vec( times_csc[: ,j,i]  ) .* 1e6; label = "CSC" )
            scatterlines!(
                axs[i, j],
                sizes,
                vec(times_csct[:, j, i]) .\ vec(times_csc[:, j, i]);
                label="CSC transp.",
            )
            scatterlines!(
                axs[i, j],
                sizes,
                vec(times_csb[:, j, i]) .\ vec(times_csc[:, j, i]);
                label="CSB",
            )
            scatterlines!(
                axs[i, j],
                sizes,
                vec(times_csbt[:, j, i]) .\ vec(times_csc[:, j, i]);
                label="CSB transp.",
            )
        end
    end

    [linkyaxes!(axs[i, :]...) for i in 1:size(axs, 1)]
    axislegend(axs[end, end]; position=:lt)

    return f

end

sizes = 2 .^ (16:2:22)
densities = [10, 15, 20]
dims = [1, 3, 10, 32]

times = benchmark_csr_mv(sizes, densities, dims)
f = make_figure(sizes, densities, dims, times...)
save(joinpath(@__DIR__, "benchmark-rel-results.png"), f)
