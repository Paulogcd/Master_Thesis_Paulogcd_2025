
"""
This function is not to be used alone.
The `survival` function computes the probability of survival for a combination of age and temperature.
"""
function survival(;Age, Temperature, Health)
    HP_predicted = HP(Age = Age, Temperature = Temperature)
    data = DataFrame(Age = Age, Temperature = Temperature, HP_predicted = HP_predicted, Health = Health)
    result = predict(REG3, data)

    return result
end

# survival(Age = 10, Temperature = 1.00, Health = 1)

function population_simulation(;N::Int64,
                                T::Int64,
                                weather_history::Vector{Float64})::NamedTuple

    # Initialisation:
    collective_age 						= []
    collective_living_history 			= []
    collective_health_history 			= []
    collective_probability_history 		= []
    
    # Threads.@threads 
    for i in 1:N # For each individual
        
        # Initialisation of individual results:
        individual_living_history 			= zeros(T)
        individual_health_history 			= zeros(T)
        individual_probability_history 		= zeros(T) # Setting it to 0 makes r ≠ Inf

        individual_past_health 				= 1 	# Excellent health
        cumulative_survival_prob 			= 1 	# Birth probability

        for t in 1:T # For each period 
        
            # Age : 
            age = t
            
            # The weather comes from the weather history
            weather_t = weather_history[t]
            
            # Health status :
                # probability of being in good health: 
                individual_pgh = health(Health_1 	= individual_past_health,
                                        Age 		= age,                         
                                        Temperature = weather_t)
            
                # Health status draw:
                individual_health_t = 	
                    sample(1:5,Weights(individual_pgh))

                # We add it to the history
                individual_health_history[t] = individual_health_t
                # The current health becomes the past one for next period
                individual_past_health = individual_health_t

            # Living status : 
            
                annual_survival = survival(Age 			    = age,
                                            Health 		    = individual_health_t, 
                                            Temperature 	= weather_t)[1]
            
                cumulative_survival_prob = annual_survival
                    # cumulative_survival_prob * annual_survival

                individual_probability_history[t] = cumulative_survival_prob[1]
            
                # Realisation : 
                individual_living_status = 
                    rand(Binomial(1,cumulative_survival_prob))

                # Into its history :
                individual_living_history[t] = individual_living_status

            # When death comes : 
            if individual_living_status == 0
                push!(collective_age, age)
                push!(collective_living_history, individual_living_history)
                push!(collective_health_history, individual_health_history)
                push!(collective_probability_history, individual_probability_history)
                break
            end
            
        end # End of loop over periods
        
    end # End of loop over individuals

    life_expectancy = mean(collective_age)

    results = (;weather_history,
                collective_age,
                collective_living_history,
                collective_health_history, 
                collective_probability_history, 
                life_expectancy)
    println("Life expectancy in this population: ", life_expectancy)
    
    return(results)
end

# population_simulation(N = 100, T = 100, weather_history = zeros(100))

# population_pessimistic_scenario     = population_simulation(N = 100, T = 100, weather_history = pessimistic_path)
# population_intermediate_scenario    = population_simulation(N = 100, T = 100, weather_history = intermediate_path)
# population_good_scenario            = population_simulation(N = 100, T = 100, weather_history = optimistic_path)
# 
# pop_1_2 = produce_population(min_temperature = 0.61, 
#     max_temperature = 2)
# pop_2_2 = produce_population(min_temperature = 0.61,
#     max_temperature = 3)
# pop_3_2 = produce_population(min_temperature = 0.61,
#     max_temperature = 4)
# 
# populations_2 = [pop_1_2,
#     pop_2_2,
#     pop_3_2]
# 
# keys(population_pessimistic_scenario)
# 
# populations = [population_pessimistic_scenario  
# population_intermediate_scenario 
# population_good_scenario         ]

"""
This function is not to be used alone. 
The `produce_graph` function generates a graph with three different populations with three different 
temperature paths. 
"""
function produce_graph(populations)
    
    result_plot = Plots.plot(xaxis = "Time",
    yaxis = "Population")
    
    for population in populations

        min_temperature = minimum(population.weather_history)
        max_temperature = maximum(population.weather_history)

        cls 	= []
        for i in 1:length(population[:collective_living_history])
            tmp = population[:collective_living_history][i]
            push!(cls,tmp)
        end

        Plots.plot!(age_range,sum(cls[:, 1]),
            # legend = false, 
            label = "Temperature: $min_temperature to $max_temperature ", 
            linewidth = 5)
    end

    Plots.plot!(
        size = (2400, 1600),
        legendfontsize = 40,
        guidefontsize = 40,
        tickfontsize = 40,

        bottom_margin = 100Plots.px,
        top_margin = 100Plots.px,
        left_margin = 100Plots.px, 
        color = ["green", "blue", "orange","red"])

    return(result_plot)
end

# produce_graph(populations)

function plot_population_weather(;N::Number, T = 100, weather_histories)
    
    Populations = Array{Any}(undef, length(weather_histories))

    for (i,weather_history) in enumerate(weather_histories)
        Populations[i]  = population_simulation(N = N, T = T, weather_history = weather_history)
    end
    
    p = produce_graph(Populations)

    Plots.plot!(legend = :bottomleft)

    if isdir("output")
        Plots.savefig(p, "output/demographic_comparison.png")

    else
        mkdir("output")
        Plots.savefig(p, "output/demographic_comparison.png")
    end
end

# plot_population_weather(N = 1_000, T = 100, weather_histories = [pessimistic_path, intermediate_path, optimistic_path])

# savefig("working_elements/Draft/output/figure_3.png")

