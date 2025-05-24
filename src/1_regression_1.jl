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