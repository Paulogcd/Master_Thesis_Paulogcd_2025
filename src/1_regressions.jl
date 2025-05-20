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

    pessimistic_path = collect(range(start = 0.5, stop = 4.0, length = 100))
    intermediate_path = collect(range(start = 0.5, stop = 3.0, length = 100))
    optimistic_path = collect(range(start = 0.5, stop = 2.0, length = 100))

    pessimistc_scenario = hcat(age_range, pessimistic_path)
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

include("regression_1.jl")

# REGRESSION 2: HEALTH
include("regression_2.jl")

# REGRESSION 3: SURVIVAL
include("regression_3.jl")

@info("1_regressions.jl compiled.")