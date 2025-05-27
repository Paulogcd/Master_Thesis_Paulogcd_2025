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

    include("3_policy_comparison.jl")

    include("extra_health_survival.jl")

    """
    The `run` function generates all plots of the package, in an "output" folder.
    """
    function run() 
        
        # Data:
        temperature()
        
        # Regressions:
        Health_Proxy_plot()
        health_transition_3D_plot()
        average_health_plot()
        plot_probabilities_comparison()
        plot_demographic_comparison()
        
        # One path: 
        plot_probability_one_path()
        plot_population_one_path()
        extra_health_survival()

        # Numerical results: 
        plot_pure_numerical()
        plot_pure_numerical_error()
        
        plot_policies_FOC_1()
        plot_FOC_1_error()

        plot_policies_FOC_2()
        plot_FOC_2_error()

        # Interpolated grid algorithms:
        # ...

        # Policy comparison: 
        policy_comparison_plot()
    end
    @info("run function compiled")

    """ 
    The `delete` function deletes the generated plots and results.
    It checks if the "output" folder exists, and delete it if it is the case.
    """
    function delete()
        if isdir("output")
            Base.run(`rm -rf output`)
            @info("Output folder deleted.")
        else 
            @info("output folder not found.")
        end
    end
    @info("delete function compiled")

    @info("Master_Thesis_Paulogcd_2025.jl compiled.")

end
