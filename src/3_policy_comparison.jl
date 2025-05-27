"""
The `policy_comparison_plot` function generates plots displaying the policy functions with different temperature scenarios.
It does so by averaging the policies accross all life, from 20 to 100 years old. 
"""
function policy_comparison_plot(;N = 100::Number,
            T = T, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range,
            consumption_range = consumption_range,
            paths = [pessimistic_path,intermediate_path,optimistic_path,historical_path])
    
    # numerical_solution = Array{Any}(undef,length(paths))
    
    consumption_plot    = Plots.plot(xaxis = "Initial savings", yaxis = "Consumption")
    labour_plot         = Plots.plot(xaxis = "Initial savings", yaxis = "Labour Supply")
    savings_plot        = Plots.plot(xaxis = "Initial savings", yaxis = "Savings")
    
    plots = [consumption_plot,labour_plot,savings_plot]
    policies = ["c","l","sprime"]

    names = ["Pessimistic path", "Intermediate path", "Optimistic path", "Historical path"]
    
    colors = Array{Any}(undef,5)
    colors[1:4] .= palette(:RdYlGn_10,4)
    colors[5]   = colorant"blue"
    colors = vcat(colors, colorant"blue")

    for (path,name,color) in zip(paths,names,colors)

        probabilities_survival = deathless_population_simulation(N=N::Int64,
                                        T=T::Int64,
                                        weather_history=path)

        average_survival_probabilities = mean(probabilities_survival.collective_probability_history[:,t] for t in 1:T)

        average_health_status = mean(probabilities_survival.collective_health_history[:,t] for t in 1:T)
        
        numerical_solution = backwards_numerical(s_range = s_range,
                                sprime_range            = sprime_range,
                                consumption_range       = consumption_range,
                                labor_range             = labor_range,
                                nperiods                = T,
                                z 						= ones(T),
                                β 						= 0.98,
                                r 						= 0.017 .* ones(T),
                                ρ 						= 1.50, 
                                φ 						= 2.00,
                                proba_survival 			= average_survival_probabilities::Array{Float64},
                                w 						= probabilities_survival.weather_history::Array{Float64},
                                h 						= average_health_status::Array{Float64}, 
                                return_full_grid 		= false::Bool, 
                                return_budget_balance 	= true::Bool)
    
        for (plot,policy) in zip(plots,policies)
                tmax = T
                tmp = zeros(length(s_range))
                
                for i in 20:tmax 
                    tmp += numerical_solution[:optimal_choices][i,:,policy]
                end
                
                average = tmp / (tmax-20)
                
                Plots.plot!(plot, 
                            s_range,
                            average,
                            label = name, 
                            linewidth=5, 
                            color = color)

                Plots.plot!(
                    size = (2400, 1600),
                    legendfontsize = 40,
                    guidefontsize = 40,
                    tickfontsize = 40,

                    bottom_margin = 100Plots.px,
                    top_margin = 100Plots.px,
                    left_margin = 100Plots.px)

            if policy == "c"
                policy_name = "Consumption"
            elseif policy == "l"
                policy_name = "Labor"
            elseif policy == "sprime"
                policy_name = "Savings"
            end

            if isdir("output")
                Plots.savefig(plot,"output/comparison_$policy_name.png")
            else
                mkdir("output")
                Plots.savefig(plot,"output/comparison_$policy_name.png")
            end
        end
    end
end

# policy_comparison_plot()
