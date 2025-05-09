using Master_Thesis_Paulogcd_2025
using Documenter

DocMeta.setdocmeta!(Master_Thesis_Paulogcd_2025, :DocTestSetup, :(using Master_Thesis_Paulogcd_2025); recursive=true)

makedocs(;
    modules=[Master_Thesis_Paulogcd_2025],
    authors="Paulogcd <gugelmopaulo@gmail.com> and contributors",
    sitename="Master_Thesis_Paulogcd_2025.jl",
    format=Documenter.HTML(;
        canonical="https://Paulogcd.github.io/Master_Thesis_Paulogcd_2025.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Paulogcd/Master_Thesis_Paulogcd_2025.jl",
    devbranch="main",
)
