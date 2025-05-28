# Master_Thesis_Paulogcd_2025

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Paulogcd.github.io/Master_Thesis_Paulogcd_2025.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Paulogcd.github.io/Master_Thesis_Paulogcd_2025.jl/dev/)
[![Build Status](https://github.com/Paulogcd/Master_Thesis_Paulogcd_2025.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Paulogcd/Master_Thesis_Paulogcd_2025.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/Paulogcd/Master_Thesis_Paulogcd_2025.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/Paulogcd/Master_Thesis_Paulogcd_2025.jl)

This is the repository of the replication package of my Master Thesis, [available here](https://www.paulogcd.com/Master_Thesis/).

This package documentation is available on its dedicated website, [available here](https://www.paulogcd.com/Master_Thesis_Paulogcd_2025).


# Installation: 

```
using Pkg
Pkg.add(url = "https://github.com/Paulogcd/Master_Thesis_Paulogcd_2025")
using Master_Thesis_Paulogcd_2025

# Test that it is well loaded: 
Master_Thesis_Paulogcd_2025.test()

```

# Setting granularity 

The algorithms in the package strongly rely on grids for the resolution of my model.
It is therefore important to set the granularity of the grids in order for the program not to crash. 
