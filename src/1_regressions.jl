using JLD2
using GLM 
using OrdinalMultinomialModels
using CSV
using DataFrames
using Plots
using PlotlyJS

# INITIALIZATION
begin 
    REG1 = load_object("src/data/regressions/regression_1.jld2")
    REG2 = load_object("src/data/regressions/regression_2.jld2")
    REG3 = load_object("src/data/regressions/regression_3.jld2")

    age_range = collect(1:100)

    temperature_data = CSV.read("src/data/temperature.csv", DataFrame)
    Temperature_2018 = temperature_data[temperature_data.Year .== 2018,:av_annual_t]

    pessimistc_path = collect(range(start = 0.5, stop = 4.0, length = 100))
    intermediate_path = collect(range(start = 0.5, stop = 3.0, length = 100))
    optimistic_path = collect(range(start = 0.5, stop = 2.0, length = 100))

    pessimistc_scenario = hcat(age_range, pessimistc_path)
    pessimistc_scenario = DataFrame(pessimistc_scenario, :auto)
    rename!(pessimistc_scenario, ["Age", "Temperature"])

    intermediate_scenario = hcat(age_range, intermediate_path)
    intermediate_scenario = DataFrame(intermediate_scenario, :auto)
    rename!(intermediate_scenario, ["Age", "Temperature"])

    optimistic_scenario = hcat(age_range, optimistic_path)
    optimistic_scenario = DataFrame(optimistic_scenario, :auto)
    rename!(optimistic_scenario, ["Age", "Temperature"])
    nothing
end

# REGRESSION 1: HEALTH PROXY
begin 
    """
    The `Health_Proxy_plot` function plots the predicted health proxy 
    for a range of age, and for the different temperature scenarios.
    """
    function Health_Proxy_plot()

        Plots.gr()

        Plots.plot(predict(REG1,pessimistc_scenario), label = "Pessimistic path", linewidth = 5)
        Plots.plot!(predict(REG1,intermediate_scenario), label = "Intermediate path", linewidth = 5)
        Plots.plot!(predict(REG1,optimistic_scenario), label = "Optimistic path", linewidth = 5)

        Plots.plot!(size = (2400, 1600),
            legendfontsize = 24,
            guidefontsize = 40,
            tickfontsize = 40,

            bottom_margin = 100Plots.px,
            top_margin = 100Plots.px,
            left_margin = 100Plots.px)

        Plots.plot!(xaxis = "Year", yaxis = "Health Proxy", 
            fontfamily = "Times")

        if isdir("output")
            Plots.savefig("output/figure_2.png")
        else
            mkdir("output")
            Plots.savefig("output/figure_2.png")
        end

    end

    """
    The `HP` function is not to be used alone. 
    It returns the estimated Health Proxy value for a combination of age and temperature values. 
    """
    function HP(;Age, Temperature)
        data = DataFrame(Age = Age, Temperature = Temperature)
        return predict(REG1, data)
    end
    
    nothing
end

# REGRESSION 2: HEALTH
begin 
    """
    The `health` function is not to be used alone. 
    It returns the estimated health transition probabilities for a combination of age, temperature, and previous health state values.
    """
    function health(;Health_1, 
                    Age, 
                    Temperature)

        HP_predicted = HP(Age = Age,
            Temperature = Temperature)

        data = DataFrame(
            Health_1        = Health_1,
            HP_predicted    = HP_predicted, 
            Age             = Age)
        
        probabilities = OrdinalMultinomialModels.predict(REG2, data, kind = :probs)

        probabilities = Matrix(probabilities)[1, :]
        probabilities = convert(Vector{Float64}, probabilities)
        
        return probabilities
    end

    """
    The `health_transition_3D_plot` function generates 3D plots of the health transition 
    probabilities. It produces 5 `html` files, which correspond to transition probabilities 
    from the 5 possible health states.
    """
    function health_transition_3D_plot()
        
        Plots.plotly()
        default(fontfamily = "Times")
        
        av_annual_range = range(start = -4.00, stop = 4.00, length = 100)
        age_range = 1:100
        temperature_range = 0.01:0.1:4.0 

        P = Array{Any}(undef,5)
        Prob_Matrix = Array{Any}(undef, 5)
        i = 1 	# Initialise index
        health_categories = 1:5
        health_names = ["Excellent", "Very Good", "Good", "Fair", "Poor"]
        
        for health_1 in health_categories
            current_health = health_names[health_1]

            # Create a DataFrame with fixed Health_1 and varying av_annual_t
            plot_data = DataFrame(
                Health_1   =
                fill(health_1, length(av_annual_range) * length(age_range)),
                Temperature  = repeat(av_annual_range, length(age_range)),
                Age        = repeat(age_range, inner = length(av_annual_range)))
            
            plot_data.HP_predicted = HP(Age = plot_data.Age, Temperature = plot_data.Temperature)
            
            # Get predicted probabilities
            probs = predict(REG2,plot_data, kind = :probs)
            prob_matrix = reshape(Matrix(probs), length(av_annual_range), length(age_range), :)

            # Create 3D surface plot for each target health category
            p = Plots.surface() 
                Plots.surface!(xlabel = "Temperature", 
                ylabel = "Age", 
                zlabel = "Probability", 
                title = "Initial health state = $current_health")

            for (i,target_health) in enumerate(health_names)
                surface!(av_annual_range, 
                    age_range, 
                    prob_matrix[:, :, i]', 
                    label = "To $target_health"
                )
            end

            if isdir("output")
                Plots.savefig(p, "output/transition_from_$current_health.html")

            else
                mkdir("output")
                Plots.savefig(p, "output/transition_from_$current_health.html")
            end

            P[i] = p
            Prob_Matrix[i] 	= prob_matrix

            i = i + 1
        end

        return P
    end

    """
    The `population_health_simulation` function is not to be used alone.
    It produces a population simulation in which individuals do not draw their living status, 
    but draw their health status each period.
    """
    function population_health_simulation(;N::Int64,
                                    T::Int64,
                                    weather_history::Vector{Float64})::NamedTuple


        collective_health_history 			= Array{Float64}(undef,T,N)
        
        Threads.@threads for i in 1:N # For each individual
            
            # Initialization:
            individual_health_history 			= zeros(T)
            individual_past_health 				= 1 	# Excellent health

            for t in 1:T # For each period 
            
                age = t

                weather_t = weather_history[t]
                
                probabilities = health(Age 		= age, 
                                        Health_1 	= individual_past_health,
                                        Temperature = weather_t)
            
                individual_health = 	
                    sample(1:5,Weights(probabilities))


                individual_health_history[t] = individual_health

                individual_past_health = individual_health
                
            end # End of loop over periods

            collective_health_history[:,i] .= individual_health_history
            
        end

        results = (;collective_health_history)
        
        return(results)
    end

    """ 
    The `average_health_plot` function generates a plot of the average health over time
    for the three different temperature scenarios. 
    It takes N and T as arguments, with N the size of the population, and T the number of periods.
    """
    function average_health_plot(;N::Int64,T::Int64 = 100)

        gr()
        
        sim_pessimistic_path = population_health_simulation(;N = N::Int64,
                                T = T::Int64,
                                weather_history = pessimistc_path::Vector{Float64})::NamedTuple

        sim_intermediate_path = population_health_simulation(;N = N::Int64,
                                T = T::Int64,
                                weather_history = intermediate_path::Vector{Float64})::NamedTuple

        sim_optimistic_path = population_health_simulation(;N = N::Int64,
                                T = T::Int64,
                                weather_history = optimistic_path::Vector{Float64})::NamedTuple

        average_health_pessimistic  = mean.(sim_pessimistic_path.collective_health_history[t,:] for t in 1:100)
        average_health_intermediate = mean.(sim_intermediate_path.collective_health_history[t,:] for t in 1:100)
        average_health_optimistic   = mean.(sim_optimistic_path.collective_health_history[t,:] for t in 1:100)

        Plots.plot(1:100,average_health_optimistic, label       = "Optimistic scenario", linewidth = 5, color = "green")
        Plots.plot!(1:100,average_health_intermediate, label    = "Intermediate scenario", linewidth = 5, color = "orange")
        Plots.plot!(1:100,average_health_pessimistic, label     = "Pessimistic scenario", linewidth = 5, color = "red")

        Plots.plot!(size = (2400, 1600),
                legendfontsize = 24,
                guidefontsize = 40,
                tickfontsize = 40,

                bottom_margin = 100Plots.px,
                top_margin = 100Plots.px,
                left_margin = 100Plots.px, 
                fontfamily = "Times")

        Plots.plot!(xaxis = "Year", yaxis = "Health", 
            legend = :topleft)
        
        if isdir("output")
            Plots.savefig("output/average_health.png")
        else
            mkdir("output")
            Plots.savefig("output/average_health.png")
        end
    end
end

# REGRESSION 3: SURVIVAL

"""
The `survival` function is not to be used alone. 
It returns the survival probability fo a combination of Health, Temperature, and Age.
"""
function survival(;Health,
        Temperature,
        Age)
    data = DataFrame(Health = Health, 
        Temperature = Temperature, 
        Age = Age)
    data.HP_predicted = HP(Temperature = data.Temperature, Age = data.Age)

    return GLM.predict(REG3, data)
end

    # survival(Health = 5.00, Age = 20.0, Temperature = 0.61)
    # Plots.plot(1:100, survival.(Health = 5.00, Age = 1:100,Temperature = 0:10))


    # 3D plot still to be done. 
@info("1_regressions.jl compiled.")