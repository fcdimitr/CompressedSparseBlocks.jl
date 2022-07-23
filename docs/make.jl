using CompressedSparseBlocks
using Documenter

DocMeta.setdocmeta!(CompressedSparseBlocks, :DocTestSetup, :(using CompressedSparseBlocks); recursive=true)

makedocs(;
    modules=[CompressedSparseBlocks],
    authors="Dimitris Floros <fcdimitr@ece.auth.gr>, Nikos Pitsianis <pitsiani@ece.auth.gr>",
    repo="https://github.com/fcdimitr/CompressedSparseBlocks.jl/blob/{commit}{path}#{line}",
    sitename="CompressedSparseBlocks.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://fcdimitr.github.io/CompressedSparseBlocks.jl",
        assets=String[],
    ),
    pages=[
        "Introduction" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/fcdimitr/CompressedSparseBlocks.jl",
    devbranch="main",
)
