module Master_Thesis_Paulogcd_2025

    """
    The test function ensures the package is well loaded.
    """
    function test()
        print("Package Master Thesis Paulogcd is well loaded.")
    end

    include("0_data_temperature.jl")

    export temperature

    include("1_regression_0.jl")
    export Health_Proxy_plot
    export health_transition_3D_plot
    export average_health_plot

    include("2_numerical_methods_0.jl")

    """
    The `run` function generates all plots of the package, in an "output" folder.
    """
    function run() 
        temperature()
        Health_Proxy_plot()
        health_transition_3D_plot()
        average_health_plot()
        plot_life_probabilities()
    end

    """ 
    The `delete` function deletes the generated plots and results.
    It checks if the "output" folder exists, and delete it if it is the case.
    """
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
