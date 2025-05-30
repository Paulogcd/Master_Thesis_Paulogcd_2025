module Master_Thesis_Paulogcd_2025

    """
    The test function ensures the package is well loaded.
    """
    function test()
        print("Package Master Thesis Paulogcd is well loaded.")
    end

    include("0_data_temperature.jl")

    export temperature

    using PlotlyKaleido
    include("1_regression_0.jl")
    export Health_Proxy_plot
    export health_transition_3D_plot
    export average_health_plot

    include("2_numerical_methods_0.jl")

    include("3_policy_comparison.jl")

    include("4_lifetime_income_comparison.jl")

    include("extra_health_survival.jl")

    """
    The `run` function generates all plots of the package, in an "output" folder.
    """
    function run(;N = 10_000, T = 100,
            s_range             = s_range,
            sprime_range        = sprime_range,
            labor_range         = labor_range,
            consumption_range   = consumption_range) 
        @time let
        
        # Data:
        @info("Plotting temperature data.")
        @time temperature()
        
        # Regressions:
        @info("Plotting health proxy.")
        @time Health_Proxy_plot()
        @info("Plotting health transition.")
        @time health_transition_3D_plot()
        @info("Plotting health average.")
        @time average_health_plot()
        @info("Plotting probabilities comparison.")
        @time plot_probabilities_comparison()
        @info("Plotting demographic comparison.")
        @time plot_demographic_comparison()
        
        # One path: 
        @info("Plotting probabilities of one path.")
        @time plot_probability_one_path()
        @info("Plotting demographics of one path.")
        @time plot_population_one_path()
        @info("Plotting extra plot of survival by health status.")
        @time extra_health_survival()

        # Numerical results:
        @info("Plotting pure numerical results.")
        @time plot_pure_numerical(;N = N, T = T, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range,
            consumption_range = consumption_range)
        # @time plot_pure_numerical_error(;N = N, T = T, s_range = s_range,
        #     sprime_range = sprime_range,
        #     labor_range = labor_range,
        #     consumption_range = consumption_range)
        
        @info("Plotting FOC-1 results.")
        @time plot_policies_FOC_1(;N = N, T = T,
            s_range = s_range,
            sprime_range = sprime_range,
            # labor_range = labor_range,
            consumption_range = consumption_range)
        # @time plot_FOC_1_error(;N = N, T = T, s_range = s_range,
        #     sprime_range = sprime_range,
        #     # labor_range = labor_range,
        #     consumption_range = consumption_range)

        @info("Plotting FOC-2 results.")
        @time plot_policies_FOC_2(;N = N, T = T, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range#,
            #consumption_range = consumption_range
            )
        # @time plot_FOC_2_error(N = N, T = T, s_range = s_range,
        #     sprime_range = sprime_range,
        #     labor_range = labor_range#,
        #     # consumption_range = consumption_range
        #     )

        # Interpolated grid algorithms:
        @info("Plotting interpolated results - numerical")
        @time plot_pure_numerical_interpolated(;N = N, T = T, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range,
            consumption_range = consumption_range)
        # @time plot_pure_numerical_error_interpolated(;N = N, T = T, s_range = s_range,
        #     sprime_range = sprime_range,
        #     labor_range = labor_range,
        #     consumption_range = consumption_range)

        @info("Plotting interpolated results - FOC-1")
        @time plot_policies_FOC_1_interpolated(;N = N, T = T,
            s_range = s_range,
            sprime_range = sprime_range,
            # labor_range = labor_range,
            consumption_range = consumption_range)
        # @time plot_FOC_1_error_interpolated(;N = N, T = T, s_range = s_range,
        #     sprime_range = sprime_range,
        #     # labor_range = labor_range,
        #     consumption_range = consumption_range)

        @info("Plotting interpolated results - FOC-2")
        @time plot_policies_FOC_2_interpolated(;N = N, T = T, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range#,
            #consumption_range = consumption_range
            )
        # @time plot_FOC_2_error_interpolated(N = N, T = T, s_range = s_range,
        #     sprime_range = sprime_range,
        #     labor_range = labor_range#,
        #     # consumption_range = consumption_range
        #     )

        # Policy comparison: 
        @info("Plotting policy comparison results.")
        @time policy_comparison_plot(N = N, T = T, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range,
            consumption_range = consumption_range)

        # Lifetime income:
        @info("Plotting hand-to-mouth lifetime income.")
        @time plot_lifetime_income_hand_to_mouth(N = N, T = T, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range,
            consumption_range = consumption_range)
        
        @info("Plotting rich lifetime income.")
        @time plot_lifetime_rich(N = N, T = T, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range,
            consumption_range = consumption_range)
        end
        @info("All plots have been generated.") # 22 minutes with scale = 0.8
        # 2565.023485 seconds (22.62 G allocations: 2.753 TiB, 3.11% gc time, 0.51% compilation time: 19% of which was recompilation)
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
