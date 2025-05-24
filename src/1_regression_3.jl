
# Demographic comparison
begin 
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

    """
    This function is not to be used alone. 
    The `produce_graph` function generates a plot of demographic evolution
    with three different populations with three different 
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

    """
    This function plots the demographic evolution of the four different scenarios.
    """
    function plot_demographic_comparison(;N = 100::Number, T = 100)
        
        Plots.plot(xaxis = "Year", yaxis = "Individuals still alive")
        weather_histories = [pessimistic_path, intermediate_path, optimistic_path, historical_path]
        names = ["Pessimistic scenario", 
            "Intermediate scenario", 
            "Optimistic scenario", 
            "Historical scenario"]
        colors = ["blue","green", "orange","red"]
        colors = reverse(colors)

        Threads.@threads for (name,weather,couleur) in collect(zip(names,weather_histories,colors))
            population = population_simulation(N = N, T = T, weather_history = weather)
            Plots.plot!(sum(population.collective_living_history[i,:] for i in 1:N), label = name, linewidth=5, color = couleur)
        end

        Plots.plot!(
            size = (2400, 1600),
            legendfontsize = 40,
            guidefontsize = 40,
            tickfontsize = 40,

            bottom_margin = 100Plots.px,
            top_margin = 100Plots.px,
            left_margin = 100Plots.px, 
            fontfamily = "Times", 
            legend = :bottomleft)

        if isdir("output")
            Plots.savefig("output/demographic_comparison.png")

        else
            mkdir("output")
            Plots.savefig("output/demographic_comparison.png")
        end
    end
    # plot_demographic_comparison(N = 10_000)
end

# Probabilities comparison
begin
    function deathless_population_simulation(;N=100::Int64,
                                    T=100::Int64,
                                    weather_history=pessimistic_path::Vector{Float64})::NamedTuple

        # Initialisation:
        collective_health_history 			= Array{Float64}(undef,T,N)
        collective_probability_history 		= Array{Float64}(undef,T,N)
        
        # Threads.@threads 
        for i in 1:N # For each individual
            
            # Initialisation of individual results:
            individual_health_history 			= zeros(T)

            individual_past_health 				= 1 	# Excellent health

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
                collective_health_history[t,i] = individual_health_t
                
                collective_probability_history[t,i] = survival(Age = age,
                    Temperature = weather_t, 
                    Health = individual_health_t)[1]
                
            end # End of loop over periods
            
        end # End of loop over individuals

        results = (;weather_history,
                    collective_health_history, 
                    collective_probability_history)
        # println("Life expectancy in this population: ", life_expectancy)
        
        return(results)
    end

    function plot_probabilities_comparison(;N = 1000::Number, T = 100::Number)

        Plots.plot(xaxis = "Year", yaxis = "Average survival probability")
        weather_histories = [pessimistic_path, intermediate_path, optimistic_path, historical_path]
        names = ["Pessimistic scenario", 
            "Intermediate scenario", 
            "Optimistic scenario", 
            "Historical scenario"]
        colors = ["blue","green", "orange","red"]
        colors = reverse(colors)

        Threads.@threads for (name,weather,color) in collect(zip(names, weather_histories, colors))
            # weather = weather_histories[1]
            population = deathless_population_simulation(N = N, T = T, weather_history = weather)
            # keys(population)
            # population.:collective_probability_history
            Plots.plot!(mean(population.collective_probability_history[:,t] for t in 1:T), label = name, linewidth=5, color = color)
            # Plots.plot(sum(population.collective_living_history))
        end

        Plots.plot!(
            size = (2400, 1600),
            legendfontsize = 40,
            guidefontsize = 40,
            tickfontsize = 40,

            bottom_margin = 100Plots.px,
            top_margin = 100Plots.px,
            left_margin = 100Plots.px, 
            fontfamily = "Times")

        if isdir("output")
            Plots.savefig("output/probabilities_comparison.png")
        else
            mkdir("output")
            Plots.savefig("output/probabilities_comparison.png")
        end
    end

    # plot_life_probabilities(N = 10_000)
end