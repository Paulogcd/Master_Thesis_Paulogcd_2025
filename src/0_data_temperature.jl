# This file plots the descriptive statistics for temperature.
begin 
    begin 
        using Statistics
        using CSV
        using DataFrames
        using Plots
        default(;fontfamily = "Times")
    end

    """ The `temperature` function returns the plot of average annual 
    temperature from 1900 to 2022."""
    function temperature()
        # Data were obtained here: https://berkeley-earth-temperature.s3.us-west-1.amazonaws.com/Global/Complete_TAVG_complete.txt
        temperature = CSV.read("src/data/temperature.csv", DataFrame)
        tp = temperature[temperature.Year .>= 1900, :]

        # Plots.plot(tp.Year, tp.av_annual_t)

        mid = (tp.Annual_lower_anomaly .+
            tp.Annual_upper_anomaly) ./ 2   #the midpoints (usually representing mean values)
        w = (tp.Annual_upper_anomaly .- tp.Annual_lower_anomaly) ./ 2     #the vertical deviation around the means

        tp_plot = Plots.plot(tp.Year,
            tp.av_annual_t,
            ribbon = w ,
            fillalpha = 0.35,
            c = 1, lw = 2,
            legend = false, #:topleft,
            label = "Mean", 
            linewidth = 5)

        default(;fontfamily = "Times")
        Plots.plot!(size = (2400, 1600),
            legendfontsize = 24,
            guidefontsize = 40,
            tickfontsize = 40,

            bottom_margin = 100Plots.px,
            top_margin = 100Plots.px,
            left_margin = 100Plots.px, 
            fontfamily = "Times")

        Plots.plot!(xaxis = "Year", yaxis = "Temperature", legend = false)
        if isdir("output")
            Plots.savefig("output/figure_1.png")
        else
            mkdir("output")
            Plots.savefig("output/figure_1.png")
        end
    end

end

# temperature()

@info("0_data_temperature.jl compiled.")