function plot_lifetime_income_hand_to_mouth(;N=10_000, 
            T = 100, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range,
            consumption_range = consumption_range,
            paths = [pessimistic_path,intermediate_path,optimistic_path,historical_path])
    
    names = ["Pessimistic path", "Intermediate path", "Optimistic path", "Historical path"]
    
    p = Plots.plot(xaxis = "Year", yaxis = "Expected Cumulated Income")

    lifetime_income = zeros(4)

    # other = Array{Any}(undef,4)

    i = 1

    colors = Array{Any}(undef,5)
    colors[1:4] .= palette(:RdYlGn_10,4)
    colors[5]   = colorant"blue"
    colors = vcat(colors, colorant"blue")

    for (color,name,path) in zip(colors,names,paths)
        
        probabilities_survival = deathless_population_simulation(N=N::Int64,
                                            T=T::Int64,
                                            weather_history=path)

        average_survival_probabilities = mean(probabilities_survival.collective_probability_history[:,t] for t in 1:T)

        average_health_status = mean(probabilities_survival.collective_health_history[:,t] for t in 1:T)

        solution = backwards_numerical(
                                s_range                 = s_range,
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

        
        # If s = 0, agents are hand-to-mouth their whole life. 
        # s = 0 is done with the index at 1 for savings.
        tmp = zeros(81)
        cumulated = zeros(81)
        j = 1
        for t in 20:T
            tmp[j] = solution.parameters.β ^(t-20) * 
                solution.optimal_choices[t,1,"l"] *
                solution.parameters.z[t] .*
                average_survival_probabilities[t]
            cumulated[j] = sum(tmp) 
            j += 1
        end
        lifetime_income[i] = cumulated[end]
        # other[i] = solution.optimal_choices[:,1,"l"]
        
        Plots.plot!(p,20:T,cumulated, label = name, color = color, linewidth=5)
        i += 1
    end
    
    # return(lifetime_income,p,other)

    Plots.plot!(
                    size = (2400, 1600),
                    legendfontsize = 40,
                    guidefontsize = 40,
                    tickfontsize = 40,

                    bottom_margin = 100Plots.px,
                    top_margin = 100Plots.px,
                    left_margin = 100Plots.px, 
                    titlefont = 40,
                    title = "Hand-to-mouth individual lifetime expected income.")

    if isdir("output")
        Plots.savefig(p,"output/comparison_lifetime_income_hand_to_mouth.png")
    else
        mkdir("output")
        Plots.savefig(p,"output/comparison_lifetime_income_hand_to_mouth.png")
    end
end

# plot_lifetime_income_hand_to_mouth()

### 

function plot_lifetime_rich(;N = 10_000, T = 100, s_range = s_range,
            sprime_range = sprime_range,
            labor_range = labor_range,
            consumption_range = consumption_range, 
            paths = [pessimistic_path,intermediate_path,optimistic_path,historical_path])
    
    names = ["Pessimistic path", "Intermediate path", "Optimistic path", "Historical path"]
    
    p = Plots.plot(xaxis = "Year", yaxis = "Expected Cumulated Income")
    labor_plot = Plots.plot(xaxis = "Year", yaxis = "Labor decision")

    lifetime_income = zeros(4)

    # other = Array{Any}(undef,4)

    i = 1

    colors          = Array{Any}(undef,5)
    colors[1:4]    .= palette(:RdYlGn_10,4)
    colors[5]       = colorant"blue"
    colors          = vcat(colors, colorant"blue")

    labor_decisions = Array{Any}(undef,length(paths),81)
    
    for (color,name,path) in zip(colors,names,paths)
        

        probabilities_survival = deathless_population_simulation(N=N::Int64,
                                            T=T::Int64,
                                            weather_history=path)

        average_survival_probabilities = mean(probabilities_survival.collective_probability_history[:,t] for t in 1:T)

        average_health_status = mean(probabilities_survival.collective_health_history[:,t] for t in 1:T)

        solution = backwards_numerical(
                                s_range                 = s_range,
                                sprime_range            = s_range,
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

        tmp         = zeros(81)
        cumulated   = zeros(81)

        findnearest(A::AbstractArray,t) = findmin(abs.(A.-t))

        for (j,t) in enumerate(20:T)
            
            if t == 20
                
                # 'end' for the maximal value of intial endowment

                tmp[j] = solution.parameters.β ^(j) .* 
                solution.optimal_choices[t,end,"l"] *
                solution.parameters.z[t] .*
                average_survival_probabilities[t]
                cumulated[j] = sum(tmp) 

                global sprime = solution.optimal_choices[t,end,"sprime"]
                global index_sprime = findnearest(s_range,sprime)[2]
                
                labor_decisions[i,j] = solution.optimal_choices[t,end,"l"]
            
            elseif t != 20

                tmp[j] = solution.parameters.β ^(j) * 
                    solution.optimal_choices[t,index_sprime,"l"] *
                    solution.parameters.z[t] *
                    average_survival_probabilities[t]
                cumulated[j] = sum(tmp) 

                global sprime = solution.optimal_choices[t,index_sprime,"sprime"]
                global index_sprime = findnearest(s_range,sprime)[2]

                labor_decisions[i,j] = solution.optimal_choices[t,index_sprime,"l"]
            end
        end
        lifetime_income[i] = cumulated[end]
        
        Plots.plot!(p, 20:T,cumulated, label = name, color = color, linewidth = 5)
        Plots.plot!(labor_plot, 20:T,labor_decisions[i,:], label = name, color = color, linewidth = 5)
        #20:100,, label = name, color = color, linewidth = 5)
        
        i += 1
    end
    
    Plots.plot!(p,
                size = (2400, 1600),
                legendfontsize = 40,
                guidefontsize = 40,
                tickfontsize = 40,

                bottom_margin = 100Plots.px,
                top_margin = 100Plots.px,
                left_margin = 100Plots.px, 
                titlefont = 40,
                title = "Rich individual lifetime expected income")

    Plots.plot!(labor_plot,
                size = (2400, 1600),
                legendfontsize = 40,
                guidefontsize = 40,
                tickfontsize = 40,
                legend = :bottomright,

                bottom_margin = 100Plots.px,
                top_margin = 100Plots.px,
                left_margin = 100Plots.px, 
                titlefont = 40,
                title = "Rich individual lifetime labor decisions")

    if isdir("output")
        Plots.savefig(p,"output/comparison_lifetime_income_rich.png")
        Plots.savefig(labor_plot,"output/comparison_labor_rich.png")
    else
        mkdir("output")
        Plots.savefig(p,"output/comparison_lifetime_income_rich.png")
        Plots.savefig(labor_plot,"output/comparison_labor_rich.png")
    end
end

# a = plot_lifetime_rich()
# Plots.plot(a)