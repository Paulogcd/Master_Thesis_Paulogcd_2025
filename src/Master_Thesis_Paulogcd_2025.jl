module Master_Thesis_Paulogcd_2025

    """
    The test function ensures the package is well loaded.
    """
    function test()
        print("Package Master Thesis Paulogcd is well loaded.")
    end

    include("0_data_temperature.jl")

    export temperature

    include("1_regressions.jl")
    export Health_Proxy_plot
    export health_transition_3D_plot
    export average_health_plot


    function delete()
        if isdir("output")
            run(`rm -rf output`)
            @info("Output folder deleted.")
        else 
            @info("output folder not found.")
        end
    end

    export delete

    @info("Master_Thesis_Paulogcd_2025.jl compiled.")

end
