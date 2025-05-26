```@meta
CurrentModule = Master_Thesis_Paulogcd_2025
```

# Master\_Thesis\_Paulogcd\_2025

Documentation for [Master\_Thesis\_Paulogcd\_2025](https://github.com/Paulogcd/Master_Thesis_Paulogcd_2025.jl).

Welcome to this website, dedicated to the replication package of my Master Thesis. 

This page go through an overview of the whole package. 
Other pages are dedicated to the precise documentation of functions used to obtain results. 

# Installation 

```
using Pkg
Pkg.activate(".")
Pkg.add(url = "https://github.com/Paulogcd/Master_Thesis_Paulogcd_2025.jl")
using Master_Thesis_Paulogcd_2025
Master_Thesis_Paulogcd_2025.test() # verifying that the package is loaded
```

# Obtaining the results 

The main function of this package is the `run()` function. 
It calls each function that generates a plot and store the results in an "output" folder. 

```{.julia}
Master_Thesis_Paulogcd_2025.run()
```

The default values are used for each function, so that the graphical results can be obtained without too much computation. If you wish to obtain more detailed graphical results, you can specify specific values of $N$ and $T$ when calling each function individually. 

```{.warning}
Be careful, the functions requiring numerical methods can rapidly involve important computation resources.
```

# Deleting results

To delete the "output" folder programmtically, you can call the `delete()` function. 
It deletes recursively all the content of the "output" folder contained in the present working directory. 

```{.julia}
Master_Thesis_Paulogcd_2025.delete()
```