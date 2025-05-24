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

    historical_path     = collect(range(start = 0.01, stop = 1.5, length = 100))
    pessimistic_path    = collect(range(start = 0.5, stop = 4.0, length = 100))
    intermediate_path   = collect(range(start = 0.5, stop = 3.0, length = 100))
    optimistic_path     = collect(range(start = 0.5, stop = 2.0, length = 100))

    historical_scenario = hcat(age_range, historical_path)
    historical_scenario = DataFrame(historical_scenario, :auto)
    rename!(historical_scenario, ["Age", "Temperature"])

    pessimistc_scenario = hcat(age_range, pessimistic_path)
    pessimistc_scenario = DataFrame(pessimistc_scenario, :auto)
    rename!(pessimistc_scenario, ["Age", "Temperature"])

    intermediate_scenario = hcat(age_range, intermediate_path)
    intermediate_scenario = DataFrame(intermediate_scenario, :auto)
    rename!(intermediate_scenario, ["Age", "Temperature"])

    optimistic_scenario = hcat(age_range, optimistic_path)
    optimistic_scenario = DataFrame(optimistic_scenario, :auto)
    rename!(optimistic_scenario, ["Age", "Temperature"])

    Plots.default(fontfamily = "Times")
    nothing
end

include("1_regression_1.jl")

# REGRESSION 2: HEALTH
include("1_regression_2.jl")

# REGRESSION 3: SURVIVAL
include("1_regression_3.jl")

@info("1_regression_0.jl compiled.")